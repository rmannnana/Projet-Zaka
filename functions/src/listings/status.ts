import { z } from "zod";

import type { OrgType } from "../organizations/schema";

export const ListingKinds = ["hotel", "property", "project"] as const;
export type ListingKind = (typeof ListingKinds)[number];

export const listingCollection: Record<ListingKind, string> = {
  hotel: "hotels",
  property: "properties",
  project: "projects",
};

/** Hôtel : comptes hôtels ; programme : promoteurs ; bien : particuliers, agences, promoteurs. */
export function kindFitsOrg(kind: ListingKind, orgType: OrgType): boolean {
  if (kind === "hotel") return orgType === "hotel";
  if (kind === "project") return orgType === "developer";
  return orgType !== "hotel";
}

/** Statuts visibles des visiteurs (mêmes listes que firestore.rules). */
export const publicStatuses: Record<ListingKind, readonly string[]> = {
  hotel: ["published"],
  property: ["published", "under_offer"],
  project: ["published", "in_progress", "delivered"],
};

/** Statuts qui comptent dans la limite d'annonces publiées du plan. */
export const countedStatuses: Record<ListingKind, readonly string[]> = {
  hotel: ["published"],
  property: ["published", "under_offer", "pending_review"],
  project: ["published", "in_progress", "delivered"],
};

const publishableFrom: Record<ListingKind, readonly string[]> = {
  hotel: ["draft", "inactive"],
  property: ["draft", "inactive", "rejected", "rented", "sold"],
  project: ["draft", "inactive"],
};

/**
 * Statut obtenu en publiant : en ligne directement pour un pro vérifié,
 * en attente de validation ZAKA pour un particulier. null : publication impossible.
 */
export function publishTarget(
  kind: ListingKind,
  status: string,
  mode: string,
): "published" | "pending_review" | null {
  // Sous offre → de nouveau disponible : le contenu n'a pas changé, pas de nouvelle validation.
  if (kind === "property" && status === "under_offer") return "published";
  if (!publishableFrom[kind].includes(status)) return null;
  return mode === "review" ? "pending_review" : "published";
}

/** Contenu minimal d'une annonce publiée. Renvoie ce qui manque, ou null. */
export function missingContent(kind: ListingKind, d: Record<string, unknown>): string | null {
  const photos = Array.isArray(d.photos) ? d.photos.length : 0;
  const price = (d.price as { amount?: number } | undefined)?.amount ?? 0;
  if (kind === "hotel") {
    if (!d.name || !d.city) return "Indiquez le nom et la ville de l'hôtel.";
    if (!d.minPricePerNight) return "Ajoutez au moins un type de chambre actif, avec son prix.";
  } else if (kind === "property") {
    if (!d.title || !d.city) return "Indiquez le titre et la ville du bien.";
    if (price <= 0) return "Indiquez le prix du bien.";
  } else if (!d.title || !d.city) {
    return "Indiquez le nom et la ville du programme.";
  }
  if (photos === 0) return "Ajoutez au moins une photo.";
  return null;
}

/** Limite du plan : null = illimité. */
export function limitProblem(published: number, max: number | null): string | null {
  if (max === null || published < max) return null;
  if (max === 0) return "Votre plan ne permet pas de publier d'annonce. Choisissez un abonnement.";
  const s = max > 1 ? "s" : "";
  return (
    `Votre plan permet ${max} annonce${s} publiée${s} à la fois. ` +
    "Retirez une annonce ou passez à un plan supérieur."
  );
}

export function featuredProblem(featured: number, max: number): string | null {
  if (featured < max) return null;
  if (max === 0) return "Votre plan ne comprend pas de mise en avant. Choisissez un abonnement.";
  const s = max > 1 ? "s" : "";
  return `Votre plan permet ${max} annonce${s} mise${s} en avant.`;
}

export const listingTitle = (d: Record<string, unknown>) =>
  (d.name as string | undefined) ?? (d.title as string | undefined) ?? "Annonce";

export const ListingRef = z.object({ kind: z.enum(ListingKinds), id: z.string().min(1) });

export const ReviewListingInput = ListingRef.extend({
  decision: z.enum(["publish", "reject"]),
  note: z.string().trim().max(1000).optional(),
});

export const ModerateListingInput = ListingRef.extend({
  decision: z.enum(["suspend", "reinstate"]),
  note: z.string().trim().max(1000).optional(),
});

export const SetFeaturedInput = ListingRef.extend({ featured: z.boolean() });
