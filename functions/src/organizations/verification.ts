import { z } from "zod";

import type { OrgType } from "./schema";

/** Pièces exigées des pros (décision du 20/11/2026). */
export const DocumentKinds = ["ifu", "rccm", "proofOfAddress"] as const;
export type DocumentKind = (typeof DocumentKinds)[number];

export type VerificationStatus = "draft" | "pending" | "verified" | "rejected" | "suspended";

/**
 * Chemin Storage d'une pièce : `private/verification/{orgId}/{kind}_{horodatage}.{ext}`.
 * Les fichiers ne sont jamais écrasés : un dossier refusé puis renvoyé garde
 * la trace des pièces précédentes.
 */
export function isValidDocumentPath(orgId: string, kind: DocumentKind, path: string): boolean {
  const prefix = `private/verification/${orgId}/`;
  if (!path.startsWith(prefix)) return false;
  return new RegExp(`^${kind}_\\d+\\.(pdf|jpe?g|png|webp)$`).test(path.slice(prefix.length));
}

export const SubmitVerificationInput = z.object({
  orgId: z.string().min(1),
  documents: z.object({
    ifu: z.string().min(1),
    rccm: z.string().min(1),
    proofOfAddress: z.string().min(1),
  }),
});

export const ReviewDecisions = ["verify", "reject", "suspend", "reinstate"] as const;
export type ReviewDecision = (typeof ReviewDecisions)[number];

export const ReviewOrgInput = z
  .object({
    orgId: z.string().min(1),
    decision: z.enum(ReviewDecisions),
    note: z.string().trim().max(1000).optional(),
  })
  .refine((v) => (v.decision === "reject" || v.decision === "suspend" ? !!v.note : true), {
    message: "Un motif est obligatoire pour refuser ou suspendre.",
    path: ["note"],
  });

/** Un pro peut (re)déposer son dossier tant qu'il n'est pas en cours d'examen ou validé. */
export function canSubmit(type: OrgType, status: VerificationStatus): boolean {
  return type !== "individual_owner" && (status === "draft" || status === "rejected");
}

/**
 * Transition demandée par un modérateur. Renvoie le nouveau statut, ou null si
 * la décision n'est pas possible depuis le statut actuel.
 *
 *   pending   --verify-->    verified
 *   pending   --reject-->    rejected   (motif obligatoire)
 *   verified  --suspend-->   suspended  (motif obligatoire)
 *   suspended --reinstate--> verified
 */
export function nextStatus(
  current: VerificationStatus,
  decision: ReviewDecision,
): VerificationStatus | null {
  switch (decision) {
    case "verify":
      return current === "pending" ? "verified" : null;
    case "reject":
      return current === "pending" ? "rejected" : null;
    case "suspend":
      return current === "verified" ? "suspended" : null;
    case "reinstate":
      return current === "suspended" ? "verified" : null;
  }
}

/** Message envoyé au propriétaire du compte après la décision. */
export function decisionMessage(decision: ReviewDecision, orgName: string, note?: string) {
  const reason = note ? ` Motif : ${note}` : "";
  switch (decision) {
    case "verify":
      return {
        title: "Compte vérifié",
        body: `${orgName} est vérifié. Vous pouvez publier vos annonces.`,
      };
    case "reject":
      return {
        title: "Dossier refusé",
        body: `Le dossier de ${orgName} n'a pas été validé.${reason} Corrigez-le puis renvoyez-le.`,
      };
    case "suspend":
      return {
        title: "Compte suspendu",
        body: `${orgName} est suspendu et ses annonces ne sont plus modifiables.${reason}`,
      };
    case "reinstate":
      return { title: "Compte rétabli", body: `${orgName} est de nouveau actif.` };
  }
}
