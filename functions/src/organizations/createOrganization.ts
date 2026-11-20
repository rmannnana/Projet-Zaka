import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { parseInput, requireAuth } from "../shared/guards";
import { CreateOrganizationInput, initialState } from "./schema";

/** Crée une organisation dont l'appelant devient propriétaire (owner). */
export const createOrganization = onCall(async (request) => {
  const uid = requireAuth(request);
  const input = parseInput(CreateOrganizationInput, request.data);

  if (input.type === "individual_owner") {
    // Seule garantie demandée à un particulier : un numéro vérifié par SMS.
    if (!request.auth?.token.phone_number) {
      throw new HttpsError(
        "failed-precondition",
        "Un numéro de téléphone vérifié est nécessaire pour publier en tant que particulier.",
      );
    }
    const existing = await db
      .collection("organizations")
      .where("createdBy", "==", uid)
      .where("type", "==", "individual_owner")
      .limit(1)
      .get();
    if (!existing.empty) {
      throw new HttpsError("already-exists", "Vous avez déjà un espace particulier.");
    }
  }

  const { verificationStatus, publishingMode } = initialState(input.type);
  const orgRef = db.collection("organizations").doc();
  const org = {
    type: input.type,
    name: input.name,
    description: input.description,
    contact: input.contact,
    ...(input.legal ? { legal: input.legal } : {}),
    verification: { status: verificationStatus, documents: {} },
    publishingMode,
    createdBy: uid,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  };

  const batch = db.batch();
  batch.set(orgRef, org);
  batch.set(orgRef.collection("members").doc(uid), {
    role: "owner",
    displayName: request.auth?.token.name ?? null,
    email: request.auth?.token.email ?? null,
    addedAt: FieldValue.serverTimestamp(),
  });
  batch.set(
    db.collection("users").doc(uid),
    { orgIds: FieldValue.arrayUnion(orgRef.id), updatedAt: FieldValue.serverTimestamp() },
    { merge: true },
  );
  writeAudit(batch, {
    actorUid: uid,
    action: "organization.create",
    targetRef: orgRef.path,
    after: { type: input.type, name: input.name, verificationStatus, publishingMode },
  });
  await batch.commit();

  return { orgId: orgRef.id };
});
