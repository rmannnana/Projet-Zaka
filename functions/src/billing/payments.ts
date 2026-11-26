import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { z } from "zod";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { type Money } from "../shared/format";
import { parseInput, requireAuth } from "../shared/guards";
import { memberUids, notifyUser } from "../shared/notify";
import { hotelLink } from "../bookings/bookingFunctions";
import { bookingMessages, summaryOf } from "../bookings/lifecycle";
import { activeGateway } from "./gateway";
import {
  FREE_PLAN_ID,
  periodFor,
  planFitsOrg,
  subscriptionMessages,
  type CurrentSubscription,
  type PlanPeriod,
} from "./plans";

const StartPaymentInput = z.object({
  /** Compte pro qui souscrit (abonnement uniquement). */
  orgId: z.string().min(1).optional(),
  purpose: z.discriminatedUnion("type", [
    z.object({ type: z.literal("subscription"), planId: z.string().min(1) }),
    z.object({ type: z.literal("booking"), bookingRequestId: z.string().min(1) }),
  ]),
});

const ConfirmSimulatedPaymentInput = z.object({
  paymentId: z.string().min(1),
  outcome: z.enum(["success", "failure", "cancelled"]),
});

/** Copie du plan payé : l'abonnement garde ces conditions même si l'admin modifie le plan ensuite. */
interface PlanSnapshot {
  id: string;
  name: string;
  description: string;
  price: Money;
  period: PlanPeriod;
  target: string;
  features: Record<string, unknown>;
}

/** Paiement en ligne d'une réservation acceptée par l'hôtel (le client peut aussi payer sur place). */
async function startBookingPayment(uid: string, bookingRequestId: string) {
  const booking = await db.collection("bookingRequests").doc(bookingRequestId).get();
  if (!booking.exists) throw new HttpsError("not-found", "Réservation introuvable.");
  if (booking.get("clientUid") !== uid) {
    throw new HttpsError("permission-denied", "Cette réservation ne vous appartient pas.");
  }
  if (booking.get("status") !== "accepted") {
    throw new HttpsError("failed-precondition", "Seule une réservation acceptée par l'hôtel peut être payée.");
  }
  if (booking.get("paymentStatus") !== "unpaid") {
    throw new HttpsError("failed-precondition", "Cette réservation est déjà payée.");
  }
  const amount = booking.get("estimatedTotal") as Money;
  const nights = booking.get("nights") ?? 1;
  const description = `Réservation ${booking.get("hotelName")} (${nights} nuit${nights > 1 ? "s" : ""})`;
  const gateway = activeGateway();
  const ref = db.collection("payments").doc();
  await ref.set({
    provider: gateway.provider,
    purpose: { type: "booking", bookingRequestId },
    payerUid: uid,
    payerOrgId: null,
    orgId: booking.get("orgId"),
    orgName: booking.get("hotelName") ?? null,
    amount,
    description,
    status: "pending",
    simulatedOutcome: null,
    providerRef: null,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
    completedAt: null,
  });
  const checkout = await gateway.start({ id: ref.id, amount, description });
  return { paymentId: ref.id, provider: gateway.provider, amount, description, checkout };
}

async function confirmBookingPayment(
  paymentRef: FirebaseFirestore.DocumentReference,
  bookingRequestId: string,
  outcome: "success" | "failure" | "cancelled",
) {
  const bookingRef = db.collection("bookingRequests").doc(bookingRequestId);
  const first = await bookingRef.get();
  const members = first.exists ? await memberUids(first.get("orgId")) : [];
  return db.runTransaction(async (tx) => {
    const payment = (await tx.get(paymentRef)).data()!;
    if (payment.status !== "pending") {
      throw new HttpsError("failed-precondition", "Ce paiement a déjà été traité.");
    }
    const booking = (await tx.get(bookingRef)).data();
    const status = outcome === "success" ? "succeeded" : outcome === "failure" ? "failed" : "cancelled";
    if (status === "succeeded") {
      if (!booking || booking.status !== "accepted" || booking.paymentStatus !== "unpaid") {
        throw new HttpsError("failed-precondition", "Cette réservation n'est plus à payer (annulée ou déjà payée).");
      }
      tx.update(bookingRef, {
        paymentStatus: "paid_simulated",
        paymentId: paymentRef.id,
        paidAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
      for (const uid of members) {
        notifyUser(tx, uid, { ...bookingMessages.paid(summaryOf(booking)), link: hotelLink(booking.orgId, bookingRef.id) });
      }
    }
    tx.update(paymentRef, {
      status,
      simulatedOutcome: outcome,
      completedAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
    return { status };
  });
}

/**
 * Démarre un paiement : abonnement (propriétaire d'un compte vérifié) ou
 * réservation acceptée (client). Le montant vient toujours du serveur.
 */
export const startPayment = onCall(async (request) => {
  const uid = requireAuth(request);
  const { orgId, purpose } = parseInput(StartPaymentInput, request.data);
  if (purpose.type === "booking") return startBookingPayment(uid, purpose.bookingRequestId);
  if (!orgId) throw new HttpsError("invalid-argument", "Compte pro manquant.");

  const orgRef = db.collection("organizations").doc(orgId);
  const [org, member, plan] = await Promise.all([
    orgRef.get(),
    orgRef.collection("members").doc(uid).get(),
    db.collection("subscriptionPlans").doc(purpose.planId).get(),
  ]);
  if (!org.exists) throw new HttpsError("not-found", "Organisation introuvable.");
  if (member.get("role") !== "owner") {
    throw new HttpsError("permission-denied", "Seul un propriétaire du compte peut souscrire un abonnement.");
  }
  if (org.get("verification.status") !== "verified") {
    throw new HttpsError("failed-precondition", "Votre compte doit être vérifié pour souscrire un abonnement.");
  }
  if (!plan.exists || plan.get("active") !== true) {
    throw new HttpsError("failed-precondition", "Ce plan n'est plus proposé.");
  }
  if (plan.id === FREE_PLAN_ID || (plan.get("price.amount") ?? 0) <= 0) {
    throw new HttpsError("failed-precondition", "Le plan Gratuit s'applique d'office : il n'y a rien à payer.");
  }
  if (!planFitsOrg(plan.get("target"), org.get("type"))) {
    throw new HttpsError("failed-precondition", "Ce plan ne correspond pas à votre type de compte.");
  }

  const p = plan.data()!;
  const planSnapshot: PlanSnapshot = {
    id: plan.id,
    name: p.name,
    description: p.description ?? "",
    price: p.price,
    period: p.period,
    target: p.target,
    features: p.features,
  };
  const description = `Abonnement ${p.name} (${p.period === "year" ? "1 an" : "1 mois"})`;
  const gateway = activeGateway();
  const ref = db.collection("payments").doc();
  await ref.set({
    provider: gateway.provider,
    purpose: { type: "subscription", planId: plan.id, subscriptionId: null },
    payerUid: uid,
    payerOrgId: orgId,
    orgName: org.get("name") ?? null,
    amount: p.price,
    description,
    planSnapshot,
    status: "pending",
    simulatedOutcome: null,
    providerRef: null,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
    completedAt: null,
  });

  try {
    const checkout = await gateway.start({ id: ref.id, amount: p.price, description });
    return { paymentId: ref.id, provider: gateway.provider, amount: p.price, description, checkout };
  } catch (e) {
    await ref.update({ status: "failed", updatedAt: FieldValue.serverTimestamp() });
    throw e;
  }
});

/**
 * Clôt un paiement simulé avec l'issue choisie dans l'écran de simulation.
 * En cas de succès, active ou prolonge l'abonnement payé et prévient les propriétaires.
 */
export const confirmSimulatedPayment = onCall(async (request) => {
  const uid = requireAuth(request);
  const { paymentId, outcome } = parseInput(ConfirmSimulatedPaymentInput, request.data);

  const paymentRef = db.collection("payments").doc(paymentId);
  const first = await paymentRef.get();
  if (!first.exists) throw new HttpsError("not-found", "Paiement introuvable.");
  if (first.get("payerUid") !== uid) {
    throw new HttpsError("permission-denied", "Ce paiement ne vous appartient pas.");
  }
  if (first.get("provider") !== "simulation") {
    throw new HttpsError("failed-precondition", "Ce paiement n'est pas un paiement simulé.");
  }
  const purpose = first.get("purpose");
  if (purpose?.type === "booking") return confirmBookingPayment(paymentRef, purpose.bookingRequestId, outcome);

  const orgId = first.get("payerOrgId") as string;
  const orgRef = db.collection("organizations").doc(orgId);
  const owners = await orgRef.collection("members").where("role", "==", "owner").get();

  return db.runTransaction(async (tx) => {
    const payment = (await tx.get(paymentRef)).data()!;
    if (payment.status !== "pending") {
      throw new HttpsError("failed-precondition", "Ce paiement a déjà été traité.");
    }
    const status = outcome === "success" ? "succeeded" : outcome === "failure" ? "failed" : "cancelled";
    const closed = {
      status,
      simulatedOutcome: outcome,
      completedAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    };
    if (status !== "succeeded") {
      tx.update(paymentRef, closed);
      return { status };
    }

    // Abonnement payé : lectures d'abord, écritures ensuite (règle des transactions).
    const org = await tx.get(orgRef);
    if (!org.exists || org.get("verification.status") !== "verified") {
      throw new HttpsError("failed-precondition", "Le compte n'est plus vérifié : paiement impossible.");
    }
    const currentId = org.get("subscriptionId") as string | undefined;
    const currentSnap = currentId ? await tx.get(db.collection("subscriptions").doc(currentId)) : null;
    const current: CurrentSubscription | null = currentSnap?.exists
      ? {
          planId: currentSnap.get("planId"),
          status: currentSnap.get("status"),
          currentPeriodEnd: currentSnap.get("currentPeriodEnd").toDate(),
        }
      : null;

    const plan = payment.planSnapshot as PlanSnapshot;
    const now = new Date();
    const period = periodFor(current, plan.id, plan.period, now);
    const subRef =
      period.mode === "renew" ? currentSnap!.ref : db.collection("subscriptions").doc();

    if (period.mode === "renew") {
      tx.update(subRef, {
        currentPeriodEnd: period.end,
        planSnapshot: plan,
        lastPaymentId: paymentId,
        renewalReminderSentAt: null,
        updatedAt: FieldValue.serverTimestamp(),
      });
    } else {
      if (currentSnap?.exists && current?.status === "active") {
        // L'ancien abonnement est soit échu (pas encore traité par la tâche du jour), soit remplacé.
        const ended = current.currentPeriodEnd <= now;
        tx.update(currentSnap.ref, {
          status: ended ? "expired" : "cancelled",
          ...(ended ? { expiredAt: FieldValue.serverTimestamp() } : { cancelledAt: FieldValue.serverTimestamp() }),
          replacedBy: subRef.id,
          updatedAt: FieldValue.serverTimestamp(),
        });
      }
      tx.set(subRef, {
        orgId,
        orgName: org.get("name") ?? null,
        planId: plan.id,
        planSnapshot: plan,
        status: "active",
        currentPeriodStart: period.start,
        currentPeriodEnd: period.end,
        lastPaymentId: paymentId,
        renewalReminderSentAt: null,
        createdBy: uid,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
      tx.update(orgRef, { subscriptionId: subRef.id, updatedAt: FieldValue.serverTimestamp() });
    }

    tx.update(paymentRef, { ...closed, "purpose.subscriptionId": subRef.id });
    writeAudit(tx, {
      actorUid: uid,
      action: period.mode === "renew" ? "subscription.renew" : "subscription.activate",
      targetRef: subRef.path,
      before: current
        ? { planId: current.planId, status: current.status, end: current.currentPeriodEnd.toISOString() }
        : null,
      after: { planId: plan.id, end: period.end.toISOString(), paymentId, amount: plan.price.amount },
    });
    const message =
      period.mode === "renew"
        ? subscriptionMessages.renewed(plan.name, period.end)
        : subscriptionMessages.activated(plan.name, period.end);
    for (const owner of owners.docs) {
      notifyUser(tx, owner.id, { ...message, link: `/pro/${orgId}/abonnement` });
    }
    return { status, subscriptionId: subRef.id, currentPeriodEnd: period.end.toISOString() };
  });
});
