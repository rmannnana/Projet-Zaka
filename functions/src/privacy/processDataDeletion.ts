import { getAuth } from "firebase-admin/auth";
import { FieldValue } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { setOrgListingsSuspended } from "../listings/triggers";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { parseInput, requireStaff } from "../shared/guards";
import { notifyUser } from "../shared/notify";
import {
  DELETED_OWNER_NAME,
  DELETED_USER_NAME,
  ProcessDeletionInput,
  planOrgCleanup,
  type Membership,
} from "./deletionPlan";

/**
 * Traite une demande d'effacement des données personnelles (CGU, politique de
 * confidentialité) :
 * - supprime le profil, ses favoris et notifications, sa photo et son compte Auth ;
 * - remplace le nom et le téléphone figés dans ses demandes par « Utilisateur supprimé »,
 *   en gardant les dates et montants (comptabilité, litiges) ;
 * - anonymise son espace particulier et le retire des comptes pros.
 */
export const processDataDeletion = onCall(async (request) => {
  const staffUid = requireStaff(request);
  const { requestId, decision, note } = parseInput(ProcessDeletionInput, request.data);

  const requestRef = db.collection("deletionRequests").doc(requestId);
  const req = await requestRef.get();
  if (!req.exists) throw new HttpsError("not-found", "Demande introuvable.");
  if (req.get("status") !== "pending") {
    throw new HttpsError("failed-precondition", "Cette demande a déjà été traitée.");
  }
  const uid = req.get("uid") as string;

  if (decision === "refused") {
    const batch = db.batch();
    batch.update(requestRef, {
      status: "refused",
      note: note ?? null,
      processedBy: staffUid,
      processedAt: FieldValue.serverTimestamp(),
    });
    notifyUser(batch, uid, {
      title: "Demande de suppression",
      body: `Votre demande n'a pas pu être traitée. Motif : ${note}`,
    });
    writeAudit(batch, {
      actorUid: staffUid,
      action: "privacy.refuseDeletion",
      targetRef: requestRef.path,
      after: { note },
    });
    await batch.commit();
    return { status: "refused" };
  }

  // 1. Organisations : vérifier qu'aucun compte pro ne se retrouve sans propriétaire.
  const userRef = db.collection("users").doc(uid);
  const orgIds: string[] = (await userRef.get()).get("orgIds") ?? [];
  const memberships: Membership[] = [];
  for (const orgId of orgIds) {
    const orgRef = db.collection("organizations").doc(orgId);
    const [org, member, owners] = await Promise.all([
      orgRef.get(),
      orgRef.collection("members").doc(uid).get(),
      orgRef.collection("members").where("role", "==", "owner").count().get(),
    ]);
    if (!org.exists || !member.exists) continue;
    memberships.push({
      orgId,
      orgName: org.get("name"),
      type: org.get("type"),
      role: member.get("role"),
      ownerCount: owners.data().count,
    });
  }
  const plan = planOrgCleanup(memberships);
  if (plan.blocking.length > 0) {
    throw new HttpsError(
      "failed-precondition",
      `Seul propriétaire de : ${plan.blocking.join(", ")}. ` +
        "Ajouter un autre propriétaire ou fermer ce compte pro avant l'effacement.",
    );
  }

  const writer = db.bulkWriter();
  for (const orgId of plan.anonymize) {
    const orgRef = db.collection("organizations").doc(orgId);
    const org = await orgRef.get();
    writer.update(orgRef, {
      name: DELETED_OWNER_NAME,
      description: "",
      logoUrl: null,
      contact: { country: org.get("contact.country") ?? null },
      "verification.status": "suspended",
      "verification.note": "Données personnelles effacées à la demande de l'utilisateur.",
      deletedAt: FieldValue.serverTimestamp(),
      updatedAt: FieldValue.serverTimestamp(),
    });
  }
  for (const orgId of [...plan.anonymize, ...plan.leave]) {
    writer.delete(db.collection("organizations").doc(orgId).collection("members").doc(uid));
  }

  // 2. Demandes envoyées par l'utilisateur : on garde l'historique, sans données personnelles.
  for (const collection of ["bookingRequests", "leads"]) {
    const snap = await db.collection(collection).where("clientUid", "==", uid).get();
    for (const doc of snap.docs) {
      writer.update(doc.ref, {
        clientSnapshot: { name: DELETED_USER_NAME },
        clientDeleted: true,
      });
    }
  }
  await writer.close();
  for (const orgId of plan.anonymize) await setOrgListingsSuspended(orgId, true);

  // 3. Profil (avec favoris et notifications), photos, compte Auth.
  await db.recursiveDelete(userRef);
  await getStorage().bucket().deleteFiles({ prefix: `public/users/${uid}/` });
  await getAuth()
    .deleteUser(uid)
    .catch((e: { code?: string }) => {
      if (e.code !== "auth/user-not-found") throw e;
    });

  const batch = db.batch();
  batch.update(requestRef, {
    status: "done",
    note: note ?? null,
    processedBy: staffUid,
    processedAt: FieldValue.serverTimestamp(),
  });
  writeAudit(batch, {
    actorUid: staffUid,
    action: "privacy.deleteUserData",
    targetRef: `users/${uid}`,
    after: { anonymizedOrgs: plan.anonymize, leftOrgs: plan.leave },
  });
  await batch.commit();

  return { status: "done" };
});
