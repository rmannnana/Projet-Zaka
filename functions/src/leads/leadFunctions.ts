import { FieldValue } from "firebase-admin/firestore";
import { onDocumentUpdated } from "firebase-functions/v2/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { z } from "zod";

import { db } from "../shared/config";
import { formatDateTime } from "../shared/format";
import { parseInput, requireAuth } from "../shared/guards";
import { memberUids, notifyUser } from "../shared/notify";
import { publicStatuses } from "../listings/status";

export const LeadTypes = ["contact", "visit", "info"] as const;
export const LeadStatuses = ["new", "in_progress", "visit_scheduled", "closed"] as const;
const OPEN_LEADS = ["new", "in_progress", "visit_scheduled"];

export const CreateLeadInput = z.object({
  targetType: z.enum(["property", "project"]),
  targetId: z.string().min(1),
  unitId: z.string().min(1).optional(),
  type: z.enum(LeadTypes),
  message: z.string().trim().min(1).max(2000),
  preferredDates: z.string().trim().max(200).default(""),
  phone: z.string().trim().max(20).optional(),
});

const typeLabels: Record<(typeof LeadTypes)[number], string> = {
  contact: "Demande de contact",
  visit: "Demande de visite",
  info: "Demande d'information",
};

export const clientLeadLink = (id: string) => `/contacts/${id}`;
export const proLeadLink = (orgId: string, id: string) => `/pro/${orgId}/contacts/${id}`;

/** Demande de contact, de visite ou d'information sur un bien ou un programme. */
export const createLead = onCall(async (request) => {
  const uid = requireAuth(request);
  const input = parseInput(CreateLeadInput, request.data);
  const targetRef = db.collection(input.targetType === "property" ? "properties" : "projects").doc(input.targetId);
  const [target, profile] = await Promise.all([targetRef.get(), db.collection("users").doc(uid).get()]);
  if (!target.exists || !publicStatuses[input.targetType].includes(target.get("status"))) {
    throw new HttpsError("not-found", "Cette annonce n'est plus disponible.");
  }
  const orgId = target.get("orgId") as string;
  const orgRef = db.collection("organizations").doc(orgId);
  const [org, member] = await Promise.all([orgRef.get(), orgRef.collection("members").doc(uid).get()]);
  if (member.exists) throw new HttpsError("failed-precondition", "C'est votre propre annonce.");

  let unitLabel: string | null = null;
  if (input.unitId) {
    const unit = await targetRef.collection("units").doc(input.unitId).get();
    if (!unit.exists) throw new HttpsError("not-found", "Ce lot n'existe plus.");
    unitLabel = unit.get("label") ?? null;
  }

  const open = await db
    .collection("leads")
    .where("clientUid", "==", uid)
    .where("status", "in", OPEN_LEADS)
    .count()
    .get();
  if (open.data().count >= 20) {
    throw new HttpsError("resource-exhausted", "Vous avez déjà 20 demandes en cours. Clôturez-en avant d'en envoyer d'autres.");
  }

  const p = profile.data() ?? {};
  const token = request.auth!.token;
  const clientSnapshot = {
    name: p.displayName || token.name || "Client ZAKA",
    phone: input.phone || p.phone || token.phone_number || null,
    email: p.email ?? token.email ?? null,
  };
  const title = target.get("title") ?? "Annonce";
  const ref = db.collection("leads").doc();
  const members = await memberUids(orgId);
  const batch = db.batch();
  batch.set(ref, {
    type: input.type,
    targetType: input.targetType,
    targetId: input.targetId,
    targetTitle: title,
    targetCity: target.get("city") ?? null,
    targetPhoto: (target.get("photos") ?? [])[0] ?? null,
    unitId: input.unitId ?? null,
    unitLabel,
    orgId,
    orgName: org.get("name") ?? null,
    clientUid: uid,
    clientSnapshot,
    message: input.message,
    preferredDates: input.preferredDates,
    status: "new",
    visitAt: null,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });
  batch.update(targetRef, { "stats.leads": FieldValue.increment(1) });
  for (const memberUid of members) {
    notifyUser(batch, memberUid, {
      title: typeLabels[input.type],
      body: `${clientSnapshot.name} · « ${title} »${unitLabel ? ` (lot ${unitLabel})` : ""}`,
      link: proLeadLink(orgId, ref.id),
    });
  }
  await batch.commit();
  return { leadId: ref.id };
});

/** Le client est prévenu quand le pro prend en charge sa demande, fixe une visite ou la clôt. */
export const onLeadUpdated = onDocumentUpdated("leads/{leadId}", async (event) => {
  const before = event.data?.before.data();
  const after = event.data?.after.data();
  if (!before || !after || before.status === after.status) return;
  const who = after.orgName ?? "Le professionnel";
  const title = after.targetTitle ?? "votre annonce";
  const message =
    after.status === "in_progress"
      ? { title: "Demande prise en charge", body: `${who} a pris en charge votre demande sur « ${title} ».` }
      : after.status === "visit_scheduled"
        ? {
            title: "Visite programmée",
            body: after.visitAt
              ? `${who} vous propose une visite de « ${title} » le ${formatDateTime(after.visitAt.toDate())}.`
              : `${who} va organiser la visite de « ${title} ».`,
          }
        : after.status === "closed"
          ? { title: "Demande clôturée", body: `${who} a clôturé votre demande sur « ${title} ».` }
          : null;
  if (!message) return;
  const batch = db.batch();
  notifyUser(batch, after.clientUid, { ...message, link: clientLeadLink(event.params.leadId) });
  await batch.commit();
});
