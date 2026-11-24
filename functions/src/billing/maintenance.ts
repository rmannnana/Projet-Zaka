import { FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { onSchedule } from "firebase-functions/v2/scheduler";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { notifyUser } from "../shared/notify";
import { RENEWAL_REMINDER_DAYS, subscriptionMessages } from "./plans";

const DAY_MS = 24 * 60 * 60 * 1000;
const PAGE = 200;

async function ownersOf(orgId: string) {
  const snap = await db
    .collection("organizations")
    .doc(orgId)
    .collection("members")
    .where("role", "==", "owner")
    .get();
  return snap.docs.map((d) => d.id);
}

/**
 * Tâche quotidienne sur les abonnements :
 * - les abonnements échus repassent au plan Gratuit (statut « expired ») ;
 * - les propriétaires sont prévenus quelques jours avant la fin.
 * Il n'y a pas de renouvellement automatique : chaque période est payée à part.
 */
export async function runSubscriptionMaintenance(now = new Date()) {
  const subscriptions = db.collection("subscriptions");
  let expired = 0;
  let reminded = 0;

  const due = await subscriptions
    .where("status", "==", "active")
    .where("currentPeriodEnd", "<=", now)
    .limit(PAGE)
    .get();
  for (const doc of due.docs) {
    const orgId = doc.get("orgId") as string;
    const owners = await ownersOf(orgId);
    const done = await db.runTransaction(async (tx) => {
      const snap = await tx.get(doc.ref);
      // Renouvelé entre-temps : rien à faire.
      if (snap.get("status") !== "active" || snap.get("currentPeriodEnd").toDate() > now) return false;
      const orgRef = db.collection("organizations").doc(orgId);
      const org = await tx.get(orgRef);

      tx.update(doc.ref, {
        status: "expired",
        expiredAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
      if (org.exists && org.get("subscriptionId") === doc.id) {
        tx.update(orgRef, { subscriptionId: null, updatedAt: FieldValue.serverTimestamp() });
      }
      writeAudit(tx, {
        actorUid: "system",
        action: "subscription.expire",
        targetRef: doc.ref.path,
        before: { status: "active" },
        after: { status: "expired" },
      });
      for (const uid of owners) {
        notifyUser(tx, uid, {
          ...subscriptionMessages.expired(snap.get("planSnapshot.name")),
          link: `/pro/${orgId}/abonnement`,
        });
      }
      return true;
    });
    if (done) expired++;
  }

  const soon = new Date(now.getTime() + RENEWAL_REMINDER_DAYS * DAY_MS);
  const ending = await subscriptions
    .where("status", "==", "active")
    .where("currentPeriodEnd", "<=", soon)
    .limit(PAGE)
    .get();
  for (const doc of ending.docs) {
    const end = doc.get("currentPeriodEnd").toDate() as Date;
    if (doc.get("renewalReminderSentAt") != null || end <= now) continue;
    const orgId = doc.get("orgId") as string;
    const batch = db.batch();
    batch.update(doc.ref, { renewalReminderSentAt: FieldValue.serverTimestamp() });
    for (const uid of await ownersOf(orgId)) {
      notifyUser(batch, uid, {
        ...subscriptionMessages.expiringSoon(doc.get("planSnapshot.name"), end),
        link: `/pro/${orgId}/abonnement`,
      });
    }
    await batch.commit();
    reminded++;
  }

  return { expired, reminded };
}

export const expireSubscriptions = onSchedule(
  { schedule: "every day 03:00", timeZone: "Africa/Ouagadougou" },
  async () => {
    const result = await runSubscriptionMaintenance();
    logger.info("Abonnements traités", result);
  },
);
