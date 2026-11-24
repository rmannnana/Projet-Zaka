import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { z } from "zod";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { type Money } from "../shared/format";
import { parseInput, requireAuth } from "../shared/guards";
import { notifyUser } from "../shared/notify";
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
  orgId: z.string().min(1),
  // Phase 3 : { type: "booking", bookingRequestId }.
  purpose: z.discriminatedUnion("type", [
    z.object({ type: z.literal("subscription"), planId: z.string().min(1) }),
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

/**
 * Démarre le paiement d'un abonnement. Le montant vient toujours du plan
 * enregistré, jamais de l'app. Réservé aux propriétaires d'un compte vérifié.
 */
export const startPayment = onCall(async (request) => {
  const uid = requireAuth(request);
  const { orgId, purpose } = parseInput(StartPaymentInput, request.data);

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
