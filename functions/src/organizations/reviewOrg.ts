import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { parseInput, requireStaff } from "../shared/guards";
import { notifyUser } from "../shared/notify";
import { ReviewOrgInput, decisionMessage, nextStatus } from "./verification";

/**
 * Décision d'un modérateur sur un compte : valider, refuser (avec motif),
 * suspendre (avec motif) ou rétablir. Les propriétaires sont notifiés.
 */
export const reviewOrg = onCall(async (request) => {
  const staffUid = requireStaff(request);
  const { orgId, decision, note } = parseInput(ReviewOrgInput, request.data);

  const orgRef = db.collection("organizations").doc(orgId);
  const owners = await orgRef.collection("members").where("role", "==", "owner").get();

  const status = await db.runTransaction(async (tx) => {
    const snap = await tx.get(orgRef);
    if (!snap.exists) throw new HttpsError("not-found", "Organisation introuvable.");
    const org = snap.data()!;
    const current = org.verification?.status ?? "draft";
    const next = nextStatus(current, decision);
    if (!next) {
      throw new HttpsError(
        "failed-precondition",
        `Décision « ${decision} » impossible : le compte est « ${current} ».`,
      );
    }

    tx.update(orgRef, {
      "verification.status": next,
      "verification.reviewedBy": staffUid,
      "verification.reviewedAt": FieldValue.serverTimestamp(),
      "verification.note": note ?? null,
      updatedAt: FieldValue.serverTimestamp(),
    });
    writeAudit(tx, {
      actorUid: staffUid,
      action: `organization.${decision}`,
      targetRef: orgRef.path,
      before: { status: current },
      after: { status: next, note: note ?? null },
    });
    const message = decisionMessage(decision, org.name, note);
    for (const owner of owners.docs) {
      notifyUser(tx, owner.id, { ...message, link: `/pro/${orgId}` });
    }
    return next;
  });

  return { status };
});
