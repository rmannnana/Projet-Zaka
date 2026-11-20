import { getAuth } from "firebase-admin/auth";
import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { z } from "zod";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { parseInput, requireAuth } from "../shared/guards";
import { notifyUser } from "../shared/notify";

const AddMemberInput = z.object({
  orgId: z.string().min(1),
  email: z.string().trim().toLowerCase().pipe(z.email()),
  role: z.enum(["owner", "editor"]).default("editor"),
});

const RemoveMemberInput = z.object({
  orgId: z.string().min(1),
  uid: z.string().min(1),
});

async function assertOwner(orgId: string, uid: string) {
  const orgRef = db.collection("organizations").doc(orgId);
  const [org, member] = await Promise.all([orgRef.get(), orgRef.collection("members").doc(uid).get()]);
  if (!org.exists) throw new HttpsError("not-found", "Organisation introuvable.");
  if (member.get("role") !== "owner") {
    throw new HttpsError("permission-denied", "Seul un propriétaire du compte peut gérer les membres.");
  }
  if (org.get("type") === "individual_owner") {
    throw new HttpsError("failed-precondition", "Un compte particulier n'a qu'un seul membre.");
  }
  return { orgRef, orgName: org.get("name") as string };
}

/** Ajoute un membre (déjà inscrit sur ZAKA) à une organisation pro. */
export const addOrgMember = onCall(async (request) => {
  const uid = requireAuth(request);
  const { orgId, email, role } = parseInput(AddMemberInput, request.data);
  const { orgRef, orgName } = await assertOwner(orgId, uid);

  const user = await getAuth()
    .getUserByEmail(email)
    .catch(() => {
      throw new HttpsError(
        "not-found",
        "Aucun compte ZAKA avec cet e-mail. La personne doit d'abord s'inscrire.",
      );
    });

  const memberRef = orgRef.collection("members").doc(user.uid);
  if ((await memberRef.get()).exists) {
    throw new HttpsError("already-exists", "Cette personne est déjà membre.");
  }

  const batch = db.batch();
  batch.set(memberRef, {
    role,
    displayName: user.displayName ?? null,
    email,
    addedBy: uid,
    addedAt: FieldValue.serverTimestamp(),
  });
  batch.set(
    db.collection("users").doc(user.uid),
    { orgIds: FieldValue.arrayUnion(orgId), updatedAt: FieldValue.serverTimestamp() },
    { merge: true },
  );
  notifyUser(batch, user.uid, {
    title: "Nouvel espace pro",
    body: `Vous avez été ajouté à ${orgName}.`,
    link: `/pro/${orgId}`,
  });
  writeAudit(batch, {
    actorUid: uid,
    action: "organization.addMember",
    targetRef: memberRef.path,
    after: { role },
  });
  await batch.commit();
  return { uid: user.uid };
});

/** Retire un membre. Le dernier propriétaire ne peut pas être retiré. */
export const removeOrgMember = onCall(async (request) => {
  const uid = requireAuth(request);
  const input = parseInput(RemoveMemberInput, request.data);
  const { orgRef } = await assertOwner(input.orgId, uid);

  const memberRef = orgRef.collection("members").doc(input.uid);
  await db.runTransaction(async (tx) => {
    const [member, owners] = await Promise.all([
      tx.get(memberRef),
      tx.get(orgRef.collection("members").where("role", "==", "owner")),
    ]);
    if (!member.exists) throw new HttpsError("not-found", "Membre introuvable.");
    if (member.get("role") === "owner" && owners.size <= 1) {
      throw new HttpsError("failed-precondition", "Le compte doit garder au moins un propriétaire.");
    }
    tx.delete(memberRef);
    tx.set(
      db.collection("users").doc(input.uid),
      { orgIds: FieldValue.arrayRemove(input.orgId), updatedAt: FieldValue.serverTimestamp() },
      { merge: true },
    );
    writeAudit(tx, {
      actorUid: uid,
      action: "organization.removeMember",
      targetRef: memberRef.path,
      before: { role: member.get("role") },
    });
  });
  return { ok: true };
});
