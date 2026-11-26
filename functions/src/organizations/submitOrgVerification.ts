import { FieldValue } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { adminUrl } from "../shared/appConfig";
import { parseInput, requireAuth } from "../shared/guards";
import { notifyUser, staffUids } from "../shared/notify";
import {
  DocumentKinds,
  SubmitVerificationInput,
  canSubmit,
  isValidDocumentPath,
} from "./verification";

/**
 * Le propriétaire d'un compte pro envoie son dossier (IFU, RCCM, justificatif
 * de résidence). Le compte passe en `pending` et apparaît dans la file de
 * vérification du back-office.
 */
export const submitOrgVerification = onCall(async (request) => {
  const uid = requireAuth(request);
  const { orgId, documents } = parseInput(SubmitVerificationInput, request.data);

  for (const kind of DocumentKinds) {
    if (!isValidDocumentPath(orgId, kind, documents[kind])) {
      throw new HttpsError("invalid-argument", `Pièce « ${kind} » : chemin invalide.`);
    }
  }
  const bucket = getStorage().bucket();
  for (const kind of DocumentKinds) {
    const [exists] = await bucket.file(documents[kind]).exists();
    if (!exists) {
      throw new HttpsError("failed-precondition", `Pièce « ${kind} » introuvable. Renvoyez le fichier.`);
    }
  }

  const orgRef = db.collection("organizations").doc(orgId);
  const orgName = await db.runTransaction(async (tx) => {
    const [orgSnap, memberSnap] = await Promise.all([
      tx.get(orgRef),
      tx.get(orgRef.collection("members").doc(uid)),
    ]);
    if (!orgSnap.exists) throw new HttpsError("not-found", "Organisation introuvable.");
    if (memberSnap.get("role") !== "owner") {
      throw new HttpsError("permission-denied", "Seul le propriétaire du compte peut envoyer le dossier.");
    }

    const org = orgSnap.data()!;
    if (!canSubmit(org.type, org.verification?.status ?? "draft")) {
      throw new HttpsError("failed-precondition", "Ce dossier ne peut pas être envoyé dans son état actuel.");
    }
    if (!org.legal?.ifuNumber || !org.legal?.rccmNumber || !org.legal?.representativeName) {
      throw new HttpsError(
        "failed-precondition",
        "Renseignez le numéro IFU, le numéro RCCM et le nom du représentant légal.",
      );
    }

    tx.update(orgRef, {
      "verification.status": "pending",
      "verification.documents": documents,
      "verification.submittedAt": FieldValue.serverTimestamp(),
      "verification.note": null,
      updatedAt: FieldValue.serverTimestamp(),
    });
    writeAudit(tx, {
      actorUid: uid,
      action: "organization.submitVerification",
      targetRef: orgRef.path,
      before: { status: org.verification?.status ?? "draft" },
      after: { status: "pending", documents },
    });
    return org.name as string;
  });

  const staff = await staffUids();
  if (staff.length > 0) {
    const batch = db.batch();
    for (const staffUid of staff) {
      notifyUser(batch, staffUid, {
        title: "Dossier à vérifier",
        body: `${orgName} a envoyé son dossier de vérification.`,
        link: `${adminUrl()}/comptes/${orgId}`,
      });
    }
    await batch.commit();
  }

  return { status: "pending" };
});
