import { z } from "zod";

import { DEFAULT_COUNTRY, UEMOA_COUNTRIES } from "../shared/constants";

export const OrgTypes = ["hotel", "individual_owner", "agency", "developer"] as const;
export type OrgType = (typeof OrgTypes)[number];

export const CreateOrganizationInput = z.object({
  type: z.enum(OrgTypes),
  name: z.string().trim().min(2).max(120),
  description: z.string().trim().max(2000).default(""),
  contact: z.object({
    phone: z.string().trim().min(8).max(20),
    email: z.email().optional(),
    address: z.string().trim().max(200).optional(),
    city: z.string().trim().min(2).max(80),
    country: z.enum(UEMOA_COUNTRIES).default(DEFAULT_COUNTRY),
  }),
  legal: z
    .object({
      ifuNumber: z.string().trim().max(40).optional(),
      rccmNumber: z.string().trim().max(60).optional(),
      representativeName: z.string().trim().max(120).optional(),
    })
    .optional(),
});
export type CreateOrganizationInput = z.infer<typeof CreateOrganizationInput>;

/**
 * Statut initial selon le type de publieur (décisions du 20/11/2026) :
 * - pro (hôtel, agence, promoteur) : brouillon, en attente des pièces IFU,
 *   RCCM et justificatif de résidence ; publication directe une fois vérifié ;
 * - particulier : aucun document, vérifié d'office, mais chaque annonce est
 *   validée par ZAKA (mode "review").
 */
export function initialState(type: OrgType) {
  return type === "individual_owner"
    ? { verificationStatus: "verified", publishingMode: "review" }
    : { verificationStatus: "draft", publishingMode: "direct" };
}
