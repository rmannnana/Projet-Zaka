import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { loadRules } from "../billing/commissionStore";
import { db } from "../shared/config";
import { memberUids, notifyUser } from "../shared/notify";
import { clientLink, completeBooking, hotelLink, transition } from "./bookingFunctions";
import { AUTO_COMPLETE_DAYS, OPEN_STATUSES, bookingMessages, summaryOf } from "./lifecycle";
import { DAY_MS } from "./stay";

const HOUR_MS = 3_600_000;
const REMINDER_HOURS = 12;
const PAGE = 200;

/**
 * Tâche régulière sur les demandes de réservation :
 * - expiration des demandes sans réponse dans le délai (48 h par défaut) ;
 * - rappel à l'hôtel quand il reste moins de 12 h pour répondre ;
 * - séjours acceptés terminés depuis 3 jours : terminés d'office (commission due).
 */
export async function runBookingMaintenance(now = new Date()) {
  const requests = db.collection("bookingRequests");
  let expired = 0;
  let reminded = 0;
  let completed = 0;

  const due = await requests
    .where("status", "in", [...OPEN_STATUSES])
    .where("expiresAt", "<=", Timestamp.fromDate(now))
    .limit(PAGE)
    .get();
  for (const doc of due.docs) {
    const members = await memberUids(doc.get("orgId"));
    const done = await db.runTransaction(async (tx) => {
      const b = (await tx.get(doc.ref)).data()!;
      if (!OPEN_STATUSES.includes(b.status) || b.expiresAt.toDate() > now) return false;
      tx.update(doc.ref, transition("expired", "system"));
      tx.set(db.collection("hotels").doc(b.hotelId), { stats: { expired: FieldValue.increment(1) } }, { merge: true });
      const summary = summaryOf(b);
      notifyUser(tx, b.clientUid, { ...bookingMessages.expiredClient(summary), link: clientLink(doc.id) });
      for (const uid of members) {
        notifyUser(tx, uid, { ...bookingMessages.expiredHotel(summary), link: hotelLink(b.orgId, doc.id) });
      }
      return true;
    });
    if (done) expired++;
  }

  const soon = await requests
    .where("status", "in", [...OPEN_STATUSES])
    .where("expiresAt", "<=", Timestamp.fromDate(new Date(now.getTime() + REMINDER_HOURS * HOUR_MS)))
    .limit(PAGE)
    .get();
  for (const doc of soon.docs) {
    const b = doc.data();
    if (b.reminderSentAt || b.expiresAt.toDate() <= now) continue;
    const batch = db.batch();
    batch.update(doc.ref, { reminderSentAt: FieldValue.serverTimestamp() });
    for (const uid of await memberUids(b.orgId)) {
      notifyUser(batch, uid, {
        ...bookingMessages.reminder(summaryOf(b), b.expiresAt.toDate()),
        link: hotelLink(b.orgId, doc.id),
      });
    }
    await batch.commit();
    reminded++;
  }

  const finished = await requests
    .where("status", "==", "accepted")
    .where("checkOut", "<=", Timestamp.fromDate(new Date(now.getTime() - AUTO_COMPLETE_DAYS * DAY_MS)))
    .limit(PAGE)
    .get();
  if (!finished.empty) {
    const rules = await loadRules("hotel_booking");
    for (const doc of finished.docs) {
      const done = await db.runTransaction(async (tx) => {
        const b = (await tx.get(doc.ref)).data()!;
        if (b.status !== "accepted") return false;
        completeBooking(tx, doc.ref, b, rules, "system", "Séjour terminé (automatique)");
        return true;
      });
      if (done) completed++;
    }
  }

  return { expired, reminded, completed };
}

export const bookingMaintenance = onSchedule(
  { schedule: "every 15 minutes", timeZone: "Africa/Ouagadougou" },
  async () => {
    const result = await runBookingMaintenance();
    if (result.expired + result.reminded + result.completed > 0) logger.info("Réservations traitées", result);
  },
);
