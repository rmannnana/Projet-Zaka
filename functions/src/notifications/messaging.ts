import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

import { clientLink, hotelLink } from "../bookings/bookingFunctions";
import { clientLeadLink, proLeadLink } from "../leads/leadFunctions";
import { adminUrl } from "../shared/appConfig";
import { db } from "../shared/config";
import { excerpt } from "../shared/format";
import { memberUids, notifyUser, staffUids } from "../shared/notify";

/**
 * Message dans une demande de réservation : l'autre partie est prévenue.
 * Si l'hôtel attendait des précisions, la réponse du client remet la demande en attente.
 */
export const onBookingMessageCreated = onDocumentCreated(
  "bookingRequests/{requestId}/messages/{messageId}",
  async (event) => {
    const m = event.data?.data();
    if (!m || m.silent) return;
    const ref = db.collection("bookingRequests").doc(event.params.requestId);
    const b = (await ref.get()).data();
    if (!b) return;
    const batch = db.batch();
    if (m.fromUid === b.clientUid) {
      for (const uid of await memberUids(b.orgId)) {
        notifyUser(batch, uid, {
          title: `Message de ${b.clientSnapshot?.name ?? "votre client"}`,
          body: excerpt(m.text ?? ""),
          link: hotelLink(b.orgId, ref.id),
          email: false,
        });
      }
      if (b.status === "info_requested") {
        batch.update(ref, {
          status: "pending",
          statusHistory: FieldValue.arrayUnion({
            status: "pending",
            by: m.fromUid,
            at: Timestamp.now(),
            note: "Précisions envoyées par le client",
          }),
          updatedAt: FieldValue.serverTimestamp(),
        });
      }
    } else {
      notifyUser(batch, b.clientUid, {
        title: `Message de ${b.hotelName ?? "l'hôtel"}`,
        body: excerpt(m.text ?? ""),
        link: clientLink(ref.id),
        email: false,
      });
    }
    await batch.commit();
  },
);

/** Message dans une demande de contact ou de visite : l'autre partie est prévenue. */
export const onLeadMessageCreated = onDocumentCreated("leads/{leadId}/messages/{messageId}", async (event) => {
  const m = event.data?.data();
  if (!m) return;
  const lead = (await db.collection("leads").doc(event.params.leadId).get()).data();
  if (!lead) return;
  const batch = db.batch();
  if (m.fromUid === lead.clientUid) {
    for (const uid of await memberUids(lead.orgId)) {
      notifyUser(batch, uid, {
        title: `Message de ${lead.clientSnapshot?.name ?? "votre contact"}`,
        body: excerpt(m.text ?? ""),
        link: proLeadLink(lead.orgId, event.params.leadId),
        email: false,
      });
    }
  } else {
    notifyUser(batch, lead.clientUid, {
      title: `Message de ${lead.orgName ?? "l'annonceur"}`,
      body: excerpt(m.text ?? ""),
      link: clientLeadLink(event.params.leadId),
      email: false,
    });
  }
  await batch.commit();
});

/** Nouveau signalement : l'équipe ZAKA est alertée. */
export const onReportCreated = onDocumentCreated("reports/{reportId}", async (event) => {
  const report = event.data?.data();
  if (!report) return;
  const batch = db.batch();
  for (const uid of await staffUids()) {
    notifyUser(batch, uid, {
      title: "Nouveau signalement",
      body: `${report.targetType} ${report.targetId} : ${report.reason}`,
      link: `${adminUrl()}/signalements`,
    });
  }
  await batch.commit();
});
