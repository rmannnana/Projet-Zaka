import { describe, expect, it } from "vitest";

import {
  CommissionRuleInput,
  canMoveCommission,
  computeCommission,
  ruleProblem,
  selectRule,
  type CommissionRule,
} from "../../src/billing/commissions";
import {
  SubscriptionPlanInput,
  addPeriod,
  isRunning,
  periodFor,
  planFitsOrg,
  planProblem,
} from "../../src/billing/plans";
import { formatMoney, money } from "../../src/shared/format";

const d = (iso: string) => new Date(iso);

function rule(partial: Partial<CommissionRule> & { id: string }): CommissionRule {
  return {
    scope: "hotel_booking",
    rateType: "percent",
    rate: 10,
    fixedAmount: null,
    orgId: null,
    validFrom: d("2026-01-01T00:00:00Z"),
    validTo: null,
    active: true,
    ...partial,
  };
}

describe("choix de la règle de commission", () => {
  const at = d("2026-12-15T12:00:00Z");
  const base = rule({ id: "defaut" });

  it("applique la règle par défaut", () => {
    expect(selectRule([base], { scope: "hotel_booking", orgId: "hotel1", at })?.id).toBe("defaut");
  });

  it("préfère la règle propre au partenaire", () => {
    const special = rule({ id: "special", orgId: "hotel1", rate: 5 });
    const rules = [base, special];
    expect(selectRule(rules, { scope: "hotel_booking", orgId: "hotel1", at })?.id).toBe("special");
    expect(selectRule(rules, { scope: "hotel_booking", orgId: "hotel2", at })?.id).toBe("defaut");
  });

  it("un nouveau taux programmé remplace l'ancien à partir de sa date, sans toucher au passé", () => {
    const next = rule({ id: "2027", rate: 12, validFrom: d("2027-01-01T00:00:00Z") });
    const rules = [base, next];
    expect(selectRule(rules, { scope: "hotel_booking", orgId: null, at })?.id).toBe("defaut");
    expect(
      selectRule(rules, { scope: "hotel_booking", orgId: null, at: d("2027-02-01T00:00:00Z") })?.id,
    ).toBe("2027");
  });

  it("ignore les règles désactivées, terminées ou d'un autre type d'opération", () => {
    const rules = [
      rule({ id: "off", active: false }),
      rule({ id: "finie", validTo: d("2026-06-01T00:00:00Z") }),
      rule({ id: "location", scope: "property_rent" }),
    ];
    expect(selectRule(rules, { scope: "hotel_booking", orgId: null, at })).toBeNull();
  });

  it("la date de fin est exclue", () => {
    const promo = rule({ id: "promo", validTo: d("2026-12-15T12:00:00Z") });
    expect(selectRule([promo], { scope: "hotel_booking", orgId: null, at })).toBeNull();
  });
});

describe("montant de la commission", () => {
  it("pourcentage arrondi au franc près", () => {
    expect(computeCommission(rule({ id: "r", rate: 7.5 }), money(33333))).toEqual(money(2500));
    expect(computeCommission(rule({ id: "r", rate: 10 }), money(45000))).toEqual(money(4500));
  });

  it("montant fixe, quel que soit le montant de base", () => {
    const fixed = rule({ id: "f", rateType: "fixed", rate: null, fixedAmount: money(2000) });
    expect(computeCommission(fixed, money(150000))).toEqual(money(2000));
  });

  it("formate en francs CFA", () => {
    expect(formatMoney(money(125000)).replace(/\s/g, " ")).toBe("125 000 FCFA");
  });
});

describe("saisie d'une règle", () => {
  const valid = {
    scope: "hotel_booking",
    rateType: "percent",
    rate: 7.5,
    validFrom: Date.UTC(2026, 11, 1),
    active: true,
  };

  it("accepte un taux à deux décimales", () => {
    expect(ruleProblem(CommissionRuleInput.parse({ ...valid, rate: 7.25 }))).toBeNull();
  });

  it("refuse un taux absent, trop précis ou hors bornes", () => {
    expect(ruleProblem(CommissionRuleInput.parse({ ...valid, rate: null }))).toMatch(/taux/);
    expect(ruleProblem(CommissionRuleInput.parse({ ...valid, rate: 7.125 }))).toMatch(/décimales/);
    expect(CommissionRuleInput.safeParse({ ...valid, rate: 120 }).success).toBe(false);
    expect(CommissionRuleInput.safeParse({ ...valid, rate: 0 }).success).toBe(false);
  });

  it("exige un montant pour une commission fixe et des dates dans l'ordre", () => {
    expect(ruleProblem(CommissionRuleInput.parse({ ...valid, rateType: "fixed" }))).toMatch(/montant/);
    expect(
      ruleProblem(CommissionRuleInput.parse({ ...valid, validTo: Date.UTC(2026, 10, 1) })),
    ).toMatch(/fin/);
  });
});

describe("registre des commissions", () => {
  it("payée et offerte sont définitives ; une facture peut être annulée", () => {
    expect(canMoveCommission("due", "invoiced")).toBe(true);
    expect(canMoveCommission("invoiced", "due")).toBe(true);
    expect(canMoveCommission("invoiced", "paid")).toBe(true);
    expect(canMoveCommission("paid", "due")).toBe(false);
    expect(canMoveCommission("waived", "paid")).toBe(false);
    expect(canMoveCommission("inconnu", "paid")).toBe(false);
  });
});

describe("plans d'abonnement", () => {
  const plan = {
    name: "Essentiel",
    price: 15000,
    period: "month",
    target: "hotel",
    features: { maxListings: 10, featuredListings: 1, advancedStats: false },
    active: true,
  };

  it("protège le plan Gratuit", () => {
    const free = { ...plan, planId: "free", name: "Gratuit", price: 0, target: "all" };
    expect(planProblem(SubscriptionPlanInput.parse(free))).toBeNull();
    expect(planProblem(SubscriptionPlanInput.parse({ ...free, price: 500 }))).toMatch(/0 FCFA/);
    expect(planProblem(SubscriptionPlanInput.parse({ ...free, active: false }))).toMatch(/désactivé/);
    expect(planProblem(SubscriptionPlanInput.parse({ ...free, target: "hotel" }))).toMatch(/tous/);
  });

  it("un plan payant a un prix", () => {
    expect(planProblem(SubscriptionPlanInput.parse(plan))).toBeNull();
    expect(planProblem(SubscriptionPlanInput.parse({ ...plan, price: 0 }))).toMatch(/prix/);
  });

  it("un plan s'adresse aux hôtels, à l'immobilier ou à tous", () => {
    expect(planFitsOrg("hotel", "hotel")).toBe(true);
    expect(planFitsOrg("hotel", "agency")).toBe(false);
    expect(planFitsOrg("real_estate", "individual_owner")).toBe(true);
    expect(planFitsOrg("real_estate", "hotel")).toBe(false);
    expect(planFitsOrg("all", "developer")).toBe(true);
  });
});

describe("périodes d'abonnement", () => {
  it("un mois plus tard, ramené au dernier jour du mois", () => {
    expect(addPeriod(d("2026-01-31T10:00:00Z"), "month")).toEqual(d("2026-02-28T10:00:00Z"));
    expect(addPeriod(d("2026-12-15T08:30:00Z"), "month")).toEqual(d("2027-01-15T08:30:00Z"));
  });

  it("un an plus tard, 29 février compris", () => {
    expect(addPeriod(d("2028-02-29T00:00:00Z"), "year")).toEqual(d("2029-02-28T00:00:00Z"));
  });

  const now = d("2026-12-01T00:00:00Z");
  const current = { planId: "pro", status: "active", currentPeriodEnd: d("2026-12-20T00:00:00Z") };

  it("renouveler le même plan prolonge la période en cours", () => {
    expect(periodFor(current, "pro", "month", now)).toEqual({
      mode: "renew",
      start: d("2026-12-20T00:00:00Z"),
      end: d("2027-01-20T00:00:00Z"),
    });
  });

  it("changer de plan, ou repartir après la fin, ouvre une nouvelle période", () => {
    expect(periodFor(current, "premium", "month", now).mode).toBe("new");
    expect(periodFor(current, "pro", "month", d("2026-12-21T00:00:00Z")).mode).toBe("new");
    expect(periodFor(null, "pro", "year", now)).toEqual({
      mode: "new",
      start: now,
      end: d("2027-12-01T00:00:00Z"),
    });
  });

  it("un abonnement compte jusqu'à la fin de sa période", () => {
    expect(isRunning(current, now)).toBe(true);
    expect(isRunning(current, d("2026-12-20T00:00:00Z"))).toBe(false);
    expect(isRunning({ ...current, status: "cancelled" }, now)).toBe(false);
    expect(isRunning(null, now)).toBe(false);
  });
});
