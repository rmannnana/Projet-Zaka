import { describe, expect, it } from "vitest";

import {
  ReviewOrgInput,
  canSubmit,
  isValidDocumentPath,
  nextStatus,
} from "../../src/organizations/verification";
import { ProcessDeletionInput, planOrgCleanup } from "../../src/privacy/deletionPlan";

describe("isValidDocumentPath", () => {
  it("accepte une pièce rangée dans le dossier de l'organisation", () => {
    expect(isValidDocumentPath("org1", "ifu", "private/verification/org1/ifu_1732100000000.pdf")).toBe(true);
    expect(
      isValidDocumentPath("org1", "proofOfAddress", "private/verification/org1/proofOfAddress_17.jpeg"),
    ).toBe(true);
  });

  it("refuse une pièce d'une autre organisation, d'un autre type ou mal nommée", () => {
    expect(isValidDocumentPath("org1", "ifu", "private/verification/org2/ifu_1.pdf")).toBe(false);
    expect(isValidDocumentPath("org1", "ifu", "private/verification/org1/rccm_1.pdf")).toBe(false);
    expect(isValidDocumentPath("org1", "ifu", "private/verification/org1/ifu_1.exe")).toBe(false);
    expect(isValidDocumentPath("org1", "ifu", "private/verification/org1/../org2/ifu_1.pdf")).toBe(false);
  });
});

describe("canSubmit", () => {
  it("un pro envoie son dossier depuis le brouillon ou après un refus", () => {
    expect(canSubmit("hotel", "draft")).toBe(true);
    expect(canSubmit("agency", "rejected")).toBe(true);
  });

  it("pas de nouvel envoi pendant l'examen, après validation, ni pour un particulier", () => {
    expect(canSubmit("hotel", "pending")).toBe(false);
    expect(canSubmit("developer", "verified")).toBe(false);
    expect(canSubmit("individual_owner", "draft")).toBe(false);
  });
});

describe("nextStatus", () => {
  it.each([
    ["pending", "verify", "verified"],
    ["pending", "reject", "rejected"],
    ["verified", "suspend", "suspended"],
    ["suspended", "reinstate", "verified"],
  ] as const)("%s --%s--> %s", (from, decision, to) => {
    expect(nextStatus(from, decision)).toBe(to);
  });

  it.each([
    ["draft", "verify"],
    ["verified", "reject"],
    ["rejected", "verify"],
    ["pending", "suspend"],
    ["verified", "reinstate"],
  ] as const)("refuse %s --%s-->", (from, decision) => {
    expect(nextStatus(from, decision)).toBeNull();
  });
});

describe("motifs obligatoires", () => {
  it("refuser ou suspendre un compte exige un motif", () => {
    expect(ReviewOrgInput.safeParse({ orgId: "o", decision: "reject" }).success).toBe(false);
    expect(ReviewOrgInput.safeParse({ orgId: "o", decision: "suspend", note: "  " }).success).toBe(false);
    expect(ReviewOrgInput.safeParse({ orgId: "o", decision: "reject", note: "RCCM illisible" }).success).toBe(true);
    expect(ReviewOrgInput.safeParse({ orgId: "o", decision: "verify" }).success).toBe(true);
  });

  it("refuser une demande de suppression exige un motif", () => {
    expect(ProcessDeletionInput.safeParse({ requestId: "r", decision: "refused" }).success).toBe(false);
    expect(ProcessDeletionInput.safeParse({ requestId: "r", decision: "done" }).success).toBe(true);
  });
});

describe("planOrgCleanup", () => {
  it("anonymise l'espace particulier et retire la personne des comptes pros", () => {
    const plan = planOrgCleanup([
      { orgId: "p", orgName: "Awa", type: "individual_owner", role: "owner", ownerCount: 1 },
      { orgId: "a", orgName: "Faso Immo", type: "agency", role: "editor", ownerCount: 1 },
      { orgId: "h", orgName: "Hôtel Nazemse", type: "hotel", role: "owner", ownerCount: 2 },
    ]);
    expect(plan).toEqual({ anonymize: ["p"], leave: ["a", "h"], blocking: [] });
  });

  it("bloque si la personne est la seule propriétaire d'un compte pro", () => {
    const plan = planOrgCleanup([
      { orgId: "h", orgName: "Hôtel Nazemse", type: "hotel", role: "owner", ownerCount: 1 },
    ]);
    expect(plan.blocking).toEqual(["Hôtel Nazemse"]);
  });
});
