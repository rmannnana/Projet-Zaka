import { z } from "zod";

import type { OrgType } from "../organizations/schema";

export const DELETED_USER_NAME = "Utilisateur supprimé";
export const DELETED_OWNER_NAME = "Particulier supprimé";

export const ProcessDeletionInput = z
  .object({
    requestId: z.string().min(1),
    decision: z.enum(["done", "refused"]),
    note: z.string().trim().max(1000).optional(),
  })
  .refine((v) => v.decision === "done" || !!v.note, {
    message: "Un motif est obligatoire pour refuser une demande.",
    path: ["note"],
  });

export interface Membership {
  orgId: string;
  orgName: string;
  type: OrgType;
  role: "owner" | "editor";
  ownerCount: number;
}

export interface OrgCleanupPlan {
  /** Espaces particuliers : profil public anonymisé et compte suspendu. */
  anonymize: string[];
  /** Comptes pros : la personne est simplement retirée des membres. */
  leave: string[];
  /** Comptes pros dont elle est la seule propriétaire : à régler avant. */
  blocking: string[];
}

/**
 * Ce qu'il faut faire des organisations d'un utilisateur qui demande
 * l'effacement de ses données. Un compte pro appartient à une entreprise
 * (données conservées), mais il ne peut pas rester sans propriétaire.
 */
export function planOrgCleanup(memberships: Membership[]): OrgCleanupPlan {
  const plan: OrgCleanupPlan = { anonymize: [], leave: [], blocking: [] };
  for (const m of memberships) {
    if (m.type === "individual_owner") plan.anonymize.push(m.orgId);
    else if (m.role === "owner" && m.ownerCount <= 1) plan.blocking.push(m.orgName);
    else plan.leave.push(m.orgId);
  }
  return plan;
}
