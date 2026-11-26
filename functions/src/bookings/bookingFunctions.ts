import { FieldValue, Timestamp, type Transaction } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { loadRules, writeCommission } from "../billing/commissionStore";
import type { CommissionRule } from "../billing/commissions";
import { bookingExpiryHours } from "../shared/appConfig";
import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { formatDate } from "../shared/format";
import { parseInput, requireAuth } from "../shared/guards";
import { memberUids, notifyUser } from "../shared/notify";
import {
  OPEN_STATUSES,
  UpdateBookingInput,
  bookingMessages,
  needsNote,
  nextBookingStatus,
  statusLabels,
  summaryOf,
  type BookingActor,
  type BookingStatus,
} from "./lifecycle";
import {
  CreateBookingInput,
  bestOffer,
  capacityProblem,
  estimateTotal,
  firstFullNight,
  monthKey,
  nightsOf,
  parseDay,
  stayProblem,
  type Availability,
} from "./stay";

export const clientLink = (id: string) => `/reservations/${id}`;
export const hotelLink = (orgId: string, id: string) => `/pro/${orgId}/reservations/${id}`;

/** Champs communs à tout changement de statut : statut, historique, date. */
export function transition(status: BookingStatus, by: string, note?: string | null) {
  return {
    status,
    statusHistory: FieldValue.arrayUnion({ status, by, at: Timestamp.now(), note: note ?? null }),
    updatedAt: FieldValue.serverTimestamp(),
  };
}

/** Séjour terminé : commission inscrite au registre, avec la règle en vigueur ce jour-là. */
export function completeBooking(
  tx: Transaction,
  ref: FirebaseFirestore.DocumentReference,
  booking: FirebaseFirestore.DocumentData,
  rules: CommissionRule[],
  by: string,
  note?: string,
) {
  const commission = writeCommission(tx, rules, {
    scope: "hotel_booking",
    orgId: booking.orgId,
    orgName: booking.orgName ?? booking.hotelName ?? null,
    source: { type: "bookingRequest", id: ref.id },
    baseAmount: booking.estimatedTotal,
    at: new Date(),
  });
  tx.update(ref, { ...transition("completed", by, note), commissionAmount: commission });
  notifyUser(tx, booking.clientUid, { ...bookingMessages.completed(summaryOf(booking)), link: clientLink(ref.id) });
}

/**
 * Demande de réservation d'un client. Toujours soumise à la confirmation de
 * l'hôtel, qui a 48 h (réglable dans `config/app`) pour répondre.
 */
export const createBookingRequest = onCall(async (request) => {
  const uid = requireAuth(request);
  const input = parseInput(CreateBookingInput, request.data);
  const checkIn = parseDay(input.checkIn);
  const checkOut = parseDay(input.checkOut);
  const now = new Date();
  const stay = stayProblem(checkIn, checkOut, now);
  if (stay) throw new HttpsError("invalid-argument", stay);

  const hotelRef = db.collection("hotels").doc(input.hotelId);
  const roomRef = hotelRef.collection("roomTypes").doc(input.roomTypeId);
  const [hotel, room, profile] = await Promise.all([
    hotelRef.get(),
    roomRef.get(),
    db.collection("users").doc(uid).get(),
  ]);
  if (!hotel.exists || hotel.get("status") !== "published") {
    throw new HttpsError("not-found", "Cet hôtel n'accepte pas de demande pour le moment.");
  }
  if (!room.exists || room.get("active") !== true) {
    throw new HttpsError("not-found", "Ce type de chambre n'est plus proposé.");
  }
  const orgId = hotel.get("orgId") as string;
  const [org, member] = await Promise.all([
    db.collection("organizations").doc(orgId).get(),
    db.collection("organizations").doc(orgId).collection("members").doc(uid).get(),
  ]);
  if (member.exists) throw new HttpsError("failed-precondition", "Vous ne pouvez pas réserver dans votre propre hôtel.");

  const r = room.data()!;
  const quantity = r.quantity ?? 1;
  const capacity = capacityProblem(input, {
    capacityAdults: r.capacityAdults ?? 1,
    capacityChildren: r.capacityChildren ?? 0,
    quantity,
  });
  if (capacity) throw new HttpsError("failed-precondition", capacity);

  const nights = nightsOf(checkIn, checkOut);
  const months = [...new Set(nights.map(monthKey))];
  const declared = await Promise.all(months.map((m) => roomRef.collection("availability").doc(m).get()));
  const availability: Availability = Object.fromEntries(
    declared.map((d, i) => [months[i], (d.get("days") ?? {}) as Record<string, number>]),
  );
  const full = firstFullNight(nights, availability, quantity, input.rooms);
  if (full) {
    throw new HttpsError(
      "failed-precondition",
      `Plus de chambre disponible la nuit du ${formatDate(full)}. Choisissez d'autres dates.`,
    );
  }

  const offers = await hotelRef.collection("offers").where("active", "==", true).get();
  const offer = bestOffer(
    offers.docs.map((d) => ({
      id: d.id,
      title: d.get("title") ?? "",
      discountPercent: d.get("discountPercent") ?? 0,
      roomTypeIds: d.get("roomTypeIds") ?? [],
      validFrom: d.get("validFrom")?.toDate() ?? new Date(0),
      validTo: d.get("validTo")?.toDate() ?? new Date(8.64e15),
    })),
    input.roomTypeId,
    checkIn,
  );
  const estimatedTotal = estimateTotal(r.pricePerNight, nights.length, input.rooms, offer?.discountPercent ?? 0);

  const open = await db
    .collection("bookingRequests")
    .where("clientUid", "==", uid)
    .where("status", "in", [...OPEN_STATUSES])
    .count()
    .get();
  if (open.data().count >= 5) {
    throw new HttpsError(
      "resource-exhausted",
      "Vous avez déjà 5 demandes en attente. Attendez une réponse ou annulez-en une.",
    );
  }

  const expiresAt = new Date(now.getTime() + (await bookingExpiryHours()) * 3_600_000);
  const p = profile.data() ?? {};
  const token = request.auth!.token;
  const clientSnapshot = {
    name: p.displayName || token.name || "Client ZAKA",
    phone: p.phone ?? token.phone_number ?? null,
    email: p.email ?? token.email ?? null,
  };
  const booking = {
    hotelId: input.hotelId,
    hotelName: hotel.get("name"),
    hotelCity: hotel.get("city") ?? null,
    hotelPhoto: (hotel.get("photos") ?? [])[0] ?? null,
    orgId,
    orgName: org.get("name") ?? null,
    roomTypeId: input.roomTypeId,
    roomTypeName: r.name,
    offerId: offer?.id ?? null,
    offerTitle: offer?.title ?? null,
    discountPercent: offer?.discountPercent ?? 0,
    clientUid: uid,
    clientSnapshot,
    checkIn: Timestamp.fromDate(checkIn),
    checkOut: Timestamp.fromDate(checkOut),
    nights: nights.length,
    adults: input.adults,
    children: input.children,
    rooms: input.rooms,
    pricePerNight: r.pricePerNight,
    estimatedTotal,
    message: input.message,
    status: "pending",
    paymentStatus: "unpaid",
    expiresAt: Timestamp.fromDate(expiresAt),
    reminderSentAt: null,
    statusHistory: [{ status: "pending", by: uid, at: Timestamp.now(), note: null }],
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };

  const ref = db.collection("bookingRequests").doc();
  const members = await memberUids(orgId);
  const batch = db.batch();
  batch.set(ref, booking);
  batch.update(hotelRef, { "stats.requests": FieldValue.increment(1) });
  for (const memberUid of members) {
    notifyUser(batch, memberUid, {
      ...bookingMessages.created(summaryOf(booking), expiresAt),
      link: hotelLink(orgId, ref.id),
    });
  }
  await batch.commit();
  return { requestId: ref.id, estimatedTotal, expiresAt: expiresAt.toISOString() };
});

/**
 * Réponse de l'hôtel (accepter, refuser, demander des précisions, séjour
 * terminé, annuler) ou annulation par le client. Chaque étape est historisée,
 * l'autre partie est prévenue.
 */
export const updateBookingStatus = onCall(async (request) => {
  const uid = requireAuth(request);
  const { requestId, action, note } = parseInput(UpdateBookingInput, request.data);
  const ref = db.collection("bookingRequests").doc(requestId);
  const first = await ref.get();
  if (!first.exists) throw new HttpsError("not-found", "Demande introuvable.");
  const b0 = first.data()!;
  const isMember = (await db.doc(`organizations/${b0.orgId}/members/${uid}`).get()).exists;
  const actor: BookingActor | null = isMember ? "hotel" : b0.clientUid === uid ? "client" : null;
  if (!actor) throw new HttpsError("permission-denied", "Cette demande ne vous concerne pas.");
  if (needsNote(actor, action) && !note) {
    throw new HttpsError("invalid-argument", "Écrivez un message pour l'autre partie.");
  }
  const members = await memberUids(b0.orgId);
  const rules = action === "complete" ? await loadRules("hotel_booking") : [];

  const status = await db.runTransaction(async (tx) => {
    const b = (await tx.get(ref)).data()!;
    const now = new Date();
    if (OPEN_STATUSES.includes(b.status) && b.expiresAt.toDate() <= now) {
      throw new HttpsError("failed-precondition", "Cette demande a expiré.");
    }
    const next = nextBookingStatus(actor, action, b.status);
    if (!next) {
      throw new HttpsError(
        "failed-precondition",
        `Action impossible : la demande est ${statusLabels[b.status as BookingStatus] ?? b.status}.`,
      );
    }
    if (action === "complete" && b.checkIn.toDate() > now) {
      throw new HttpsError("failed-precondition", "Le séjour n'a pas encore commencé.");
    }
    const summary = summaryOf(b);
    const hotelRef = db.collection("hotels").doc(b.hotelId);

    if (next === "completed") {
      completeBooking(tx, ref, b, rules, uid, note);
    } else {
      tx.update(ref, {
        ...transition(next, uid, note),
        ...(next === "cancelled" && b.paymentStatus === "paid_simulated"
          ? { paymentStatus: "refunded_simulated" }
          : {}),
      });
    }
    if (action === "request_info") {
      // Le message apparaît dans la discussion ; la notification part avec le changement de statut.
      tx.set(ref.collection("messages").doc(), {
        fromUid: uid,
        fromRole: "hotel",
        text: note,
        silent: true,
        createdAt: FieldValue.serverTimestamp(),
      });
    }
    if (next === "accepted" || next === "rejected") {
      tx.set(hotelRef, { stats: { [next]: FieldValue.increment(1) } }, { merge: true });
    }

    if (actor === "hotel") {
      const message =
        next === "accepted"
          ? bookingMessages.accepted(summary)
          : next === "rejected"
            ? bookingMessages.rejected(summary, note)
            : next === "info_requested"
              ? bookingMessages.infoRequested(summary, note!)
              : next === "cancelled"
                ? bookingMessages.cancelledByHotel(summary, note!)
                : null;
      if (message) notifyUser(tx, b.clientUid, { ...message, link: clientLink(ref.id) });
      writeAudit(tx, {
        actorUid: uid,
        action: `booking.${action}`,
        targetRef: ref.path,
        before: { status: b.status },
        after: { status: next, note: note ?? null },
      });
    } else {
      for (const memberUid of members) {
        notifyUser(tx, memberUid, {
          ...bookingMessages.cancelledByClient(summary),
          link: hotelLink(b.orgId, ref.id),
        });
      }
    }
    return next;
  });
  return { status };
});
