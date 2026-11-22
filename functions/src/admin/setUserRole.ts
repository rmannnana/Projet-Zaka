import { getAuth } from "firebase-admin/auth";
import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";
import { z } from "zod";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { parseInput, requireAdmin } from "../shared/guards";

const SetUserRoleInput = z.object({
  uid: z.string().min(1),
  role: z.enum(["admin", "moderator", "none"]),
});

/**
 * Donne ou retire un rôle staff (custom claim `role`). Réservé aux admins.
 * Un admin ne peut pas modifier son propre rôle, pour éviter de se bloquer.
 */
export const setUserRole = onCall(async (request) => {
  const adminUid = requireAdmin(request);
  const { uid, role } = parseInput(SetUserRoleInput, request.data);
  if (uid === adminUid) {
    throw new HttpsError("failed-precondition", "Vous ne pouvez pas modifier votre propre rôle.");
  }

  const auth = getAuth();
  const user = await auth.getUser(uid).catch(() => {
    throw new HttpsError("not-found", "Utilisateur introuvable.");
  });
  const previous = (user.customClaims?.role as string | undefined) ?? "none";
  const { role: _old, ...otherClaims } = user.customClaims ?? {};
  await auth.setCustomUserClaims(uid, role === "none" ? otherClaims : { ...otherClaims, role });

  // Copie lisible dans Firestore pour lister l'équipe dans le back-office.
  const batch = db.batch();
  batch.set(
    db.collection("users").doc(uid),
    { staffRole: role === "none" ? null : role, updatedAt: FieldValue.serverTimestamp() },
    { merge: true },
  );
  writeAudit(batch, {
    actorUid: adminUid,
    action: "user.setRole",
    targetRef: `users/${uid}`,
    before: { role: previous },
    after: { role },
  });
  await batch.commit();
  return { role };
});
