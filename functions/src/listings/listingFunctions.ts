import { FieldValue } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { effectiveLimits } from "../billing/features";
import { adminUrl } from "../shared/appConfig";
import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { parseInput, requireAuth, requireStaff } from "../shared/guards";
import { memberUids, notifyUser, staffUids } from "../shared/notify";
import {
  ListingKinds,
  ListingRef,
  ModerateListingInput,
  ReviewListingInput,
  SetFeaturedInput,
  countedStatuses,
  featuredProblem,
  kindFitsOrg,
  limitProblem,
  listingCollection,
  listingTitle,
  missingContent,
  publicStatuses,
  publishTarget,
  type ListingKind,
} from "./status";

const listingRef = (kind: ListingKind, id: string) => db.collection(listingCollection[kind]).doc(id);

/** Annonces d'un compte qui comptent dans la limite de son plan. */
async function countPublished(orgId: string, except?: string) {
  const snaps = await Promise.all(
    ListingKinds.map((k) =>
      db
        .collection(listingCollection[k])
        .where("orgId", "==", orgId)
        .where("status", "in", [...countedStatuses[k]])
        .select()
        .get(),
    ),
  );
  return snaps.reduce((sum, s) => sum + s.docs.filter((d) => d.id !== except).length, 0);
}

async function loadForMember(kind: ListingKind, id: string, uid: string) {
  const ref = listingRef(kind, id);
  const snap = await ref.get();
  if (!snap.exists) throw new HttpsError("not-found", "Annonce introuvable.");
  const listing = snap.data()!;
  const orgRef = db.collection("organizations").doc(listing.orgId);
  const [org, member] = await Promise.all([orgRef.get(), orgRef.collection("members").doc(uid).get()]);
  if (!member.exists) throw new HttpsError("permission-denied", "Vous n'êtes pas membre de ce compte.");
  if (!org.exists || org.get("verification.status") !== "verified") {
    throw new HttpsError("failed-precondition", "Votre compte doit être vérifié pour publier.");
  }
  return { ref, listing, org: org.data()! };
}

/**
 * Met une annonce en ligne (pro vérifié) ou l'envoie à la validation ZAKA
 * (particulier), après contrôle du contenu et de la limite du plan.
 */
export const publishListing = onCall(async (request) => {
  const uid = requireAuth(request);
  const { kind, id } = parseInput(ListingRef, request.data);
  const { ref, listing, org } = await loadForMember(kind, id, uid);

  if (!kindFitsOrg(kind, org.type)) {
    throw new HttpsError("failed-precondition", "Ce type d'annonce ne correspond pas à votre compte.");
  }
  const target = publishTarget(kind, listing.status, org.publishingMode ?? "direct");
  if (!target) {
    throw new HttpsError("failed-precondition", "Cette annonce ne peut pas être publiée dans son état actuel.");
  }
  const missing = missingContent(kind, listing);
  if (missing) throw new HttpsError("failed-precondition", missing);

  const limits = await effectiveLimits(org);
  const problem = limitProblem(await countPublished(listing.orgId, id), limits.maxListings);
  if (problem) throw new HttpsError("failed-precondition", problem);

  const staff = target === "pending_review" ? await staffUids() : [];
  const batch = db.batch();
  batch.update(ref, {
    status: target,
    ...(target === "published"
      ? { publishedAt: FieldValue.serverTimestamp() }
      : { submittedAt: FieldValue.serverTimestamp() }),
    updatedAt: FieldValue.serverTimestamp(),
  });
  for (const staffUid of staff) {
    notifyUser(batch, staffUid, {
      title: "Annonce à valider",
      body: `${org.name} a envoyé « ${listingTitle(listing)} » à la validation.`,
      link: `${adminUrl()}/annonces`,
    });
  }
  await batch.commit();
  return { status: target };
});

/** Décision d'un modérateur sur une annonce de particulier : publier ou refuser (motif obligatoire). */
export const reviewListing = onCall(async (request) => {
  const staffUid = requireStaff(request);
  const { kind, id, decision, note } = parseInput(ReviewListingInput, request.data);
  if (decision === "reject" && !note) {
    throw new HttpsError("invalid-argument", "Indiquez le motif du refus : il est transmis au propriétaire.");
  }
  const ref = listingRef(kind, id);
  const first = await ref.get();
  if (!first.exists) throw new HttpsError("not-found", "Annonce introuvable.");
  const members = await memberUids(first.get("orgId"));

  const status = await db.runTransaction(async (tx) => {
    const snap = await tx.get(ref);
    const listing = snap.data()!;
    if (listing.status !== "pending_review") {
      throw new HttpsError("failed-precondition", "Cette annonce n'est plus en attente de validation.");
    }
    const next = decision === "publish" ? "published" : "rejected";
    tx.update(ref, {
      status: next,
      moderation: { reviewedBy: staffUid, reviewedAt: FieldValue.serverTimestamp(), reason: note ?? null },
      ...(next === "published" ? { publishedAt: FieldValue.serverTimestamp() } : {}),
      updatedAt: FieldValue.serverTimestamp(),
    });
    writeAudit(tx, {
      actorUid: staffUid,
      action: `listing.${decision}`,
      targetRef: ref.path,
      before: { status: listing.status },
      after: { status: next, note: note ?? null },
    });
    const title = listingTitle(listing);
    for (const uid of members) {
      notifyUser(
        tx,
        uid,
        next === "published"
          ? { title: "Annonce publiée", body: `« ${title} » est en ligne.`, link: `/pro/${listing.orgId}/annonces` }
          : {
              title: "Annonce refusée",
              body: `« ${title} » n'a pas été publiée : ${note}. Corrigez-la puis renvoyez-la.`,
              link: `/pro/${listing.orgId}/annonces`,
            },
      );
    }
    return next;
  });
  return { status };
});

/** Suspension d'une annonce par l'équipe (signalement, fraude), ou rétablissement. Motif obligatoire pour suspendre. */
export const moderateListing = onCall(async (request) => {
  const staffUid = requireStaff(request);
  const { kind, id, decision, note } = parseInput(ModerateListingInput, request.data);
  if (decision === "suspend" && !note) {
    throw new HttpsError("invalid-argument", "Indiquez le motif de la suspension.");
  }
  const ref = listingRef(kind, id);
  const first = await ref.get();
  if (!first.exists) throw new HttpsError("not-found", "Annonce introuvable.");
  const members = await memberUids(first.get("orgId"));

  const status = await db.runTransaction(async (tx) => {
    const listing = (await tx.get(ref)).data()!;
    const suspend = decision === "suspend";
    if (suspend === (listing.status === "suspended")) {
      throw new HttpsError(
        "failed-precondition",
        suspend ? "Cette annonce est déjà suspendue." : "Cette annonce n'est pas suspendue.",
      );
    }
    const next = suspend ? "suspended" : (listing.previousStatus ?? "inactive");
    tx.update(ref, {
      status: next,
      previousStatus: suspend ? listing.status : null,
      featured: false,
      moderation: { reviewedBy: staffUid, reviewedAt: FieldValue.serverTimestamp(), reason: note ?? null },
      updatedAt: FieldValue.serverTimestamp(),
    });
    writeAudit(tx, {
      actorUid: staffUid,
      action: `listing.${decision}`,
      targetRef: ref.path,
      before: { status: listing.status },
      after: { status: next, note: note ?? null },
    });
    const title = listingTitle(listing);
    for (const uid of members) {
      notifyUser(tx, uid, {
        title: suspend ? "Annonce suspendue" : "Annonce rétablie",
        body: suspend
          ? `« ${title} » a été retirée par l'équipe ZAKA : ${note}`
          : `« ${title} » est de nouveau disponible.`,
        link: `/pro/${listing.orgId}/annonces`,
      });
    }
    return next;
  });
  return { status };
});

/** Mise en avant d'une annonce publiée, dans la limite du plan. */
export const setFeatured = onCall(async (request) => {
  const uid = requireAuth(request);
  const { kind, id, featured } = parseInput(SetFeaturedInput, request.data);
  const { ref, listing, org } = await loadForMember(kind, id, uid);
  if (featured) {
    if (!publicStatuses[kind].includes(listing.status)) {
      throw new HttpsError("failed-precondition", "Seule une annonce en ligne peut être mise en avant.");
    }
    const counts = await Promise.all(
      ListingKinds.map((k) =>
        db.collection(listingCollection[k]).where("orgId", "==", listing.orgId).where("featured", "==", true).select().get(),
      ),
    );
    const current = counts.reduce((sum, s) => sum + s.docs.filter((d) => d.id !== id).length, 0);
    const problem = featuredProblem(current, (await effectiveLimits(org)).featuredListings);
    if (problem) throw new HttpsError("failed-precondition", problem);
  }
  await ref.update({ featured, updatedAt: FieldValue.serverTimestamp() });
  return { featured };
});

/** Compteur de vues d'une annonce publique (statistiques des pros). */
export const recordView = onCall(async (request) => {
  const { kind, id } = parseInput(ListingRef, request.data);
  const ref = listingRef(kind, id);
  const snap = await ref.get();
  if (!snap.exists || !publicStatuses[kind].includes(snap.get("status"))) return { ok: false };
  await ref.update({ "stats.views": FieldValue.increment(1) });
  return { ok: true };
});
