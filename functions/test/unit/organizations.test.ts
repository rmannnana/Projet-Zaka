import { describe, expect, it } from "vitest";

import { CreateOrganizationInput, initialState } from "../../src/organizations/schema";
import { countryFromPhone } from "../../src/shared/phone";

describe("initialState", () => {
  it("un particulier est vérifié d'office mais ses annonces sont validées par ZAKA", () => {
    expect(initialState("individual_owner")).toEqual({
      verificationStatus: "verified",
      publishingMode: "review",
    });
  });

  it.each(["hotel", "agency", "developer"] as const)(
    "un pro (%s) commence en brouillon et publiera directement",
    (type) => {
      expect(initialState(type)).toEqual({ verificationStatus: "draft", publishingMode: "direct" });
    },
  );
});

describe("CreateOrganizationInput", () => {
  const valid = {
    type: "agency",
    name: "  Agence Faso Immo ",
    contact: { phone: "+22670000000", city: "ouagadougou" },
  };

  it("nettoie les champs et applique le Burkina Faso par défaut", () => {
    const parsed = CreateOrganizationInput.parse(valid);
    expect(parsed.name).toBe("Agence Faso Immo");
    expect(parsed.contact.country).toBe("BF");
    expect(parsed.description).toBe("");
  });

  it("refuse un pays hors UEMOA", () => {
    const result = CreateOrganizationInput.safeParse({
      ...valid,
      contact: { ...valid.contact, country: "FR" },
    });
    expect(result.success).toBe(false);
  });

  it("refuse un type inconnu", () => {
    expect(CreateOrganizationInput.safeParse({ ...valid, type: "bank" }).success).toBe(false);
  });
});

describe("countryFromPhone", () => {
  it.each([
    ["+22670123456", "BF"],
    ["+2250701020304", "CI"],
    ["+221771234567", "SN"],
    ["+33612345678", null],
    [null, null],
  ])("%s -> %s", (phone, country) => {
    expect(countryFromPhone(phone)).toBe(country);
  });
});
