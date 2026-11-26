import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { z } from "zod";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { parseInput, requireStaff } from "../shared/guards";

const ExportInput = z.object({
  targetType: z.enum(["bookingRequest", "lead"]),
  id: z.string().min(1),
  reason: z.string().trim().min(3).max(500),
});

/** Remplace les dates Firestore par des dates lisibles (ISO 8601). */
export function plain(value: unknown): unknown {
  if (value instanceof Timestamp) return value.toDate().toISOString();
  if (Array.isArray(value)) return value.map(plain);
  if (value && typeof value === "object") {
    return Object.fromEntries(Object.entries(value).map(([k, v]) => [k, plain(v)]));
  }
  return value;
}

/**
 * Export du dossier d'une demande (historique, messages, dates) pour un litige.
 * ZAKA n'arbitre pas : elle fournit les informations utiles. Le fichier est
 * privé (équipe ZAKA) et chaque export est tracé.
 */
export const exportDisputeFile = onCall(async (request) => {
  const staffUid = requireStaff(request);
  const { targetType, id, reason } = parseInput(ExportInput, request.data);
  const ref = db.collection(targetType === "bookingRequest" ? "bookingRequests" : "leads").doc(id);
  const [doc, messages] = await Promise.all([ref.get(), ref.collection("messages").orderBy("createdAt").get()]);
  if (!doc.exists) throw new HttpsError("not-found", "Demande introuvable.");

  const exportedAt = new Date();
  const file = {
    exportedAt: exportedAt.toISOString(),
    exportedBy: staffUid,
    reason,
    notice:
      "Dossier fourni par ZAKA à titre d'information. ZAKA n'est pas partie au contrat entre le client et le professionnel.",
    request: { id, path: ref.path, ...(plain(doc.data()) as object) },
    messages: messages.docs.map((m) => ({ id: m.id, ...(plain(m.data()) as object) })),
  };
  const path = `private/exports/${targetType}_${id}_${exportedAt.getTime()}.json`;
  await getStorage()
    .bucket()
    .file(path)
    .save(JSON.stringify(file, null, 2), { contentType: "application/json; charset=utf-8" });

  const batch = db.batch();
  const exportRef = db.collection("disputeExports").doc();
  batch.set(exportRef, {
    requestedBy: staffUid,
    targetRef: ref.path,
    reason,
    path,
    at: FieldValue.serverTimestamp(),
  });
  writeAudit(batch, {
    actorUid: staffUid,
    action: "dispute.export",
    targetRef: ref.path,
    after: { path, reason },
  });
  await batch.commit();
  return { exportId: exportRef.id, path };
});
