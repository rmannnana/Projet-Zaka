import { z } from "zod";

import { AmountInput, money, type Money } from "../shared/format";

export const CommissionScopes = ["hotel_booking", "property_rent", "property_sale"] as const;
export type CommissionScope = (typeof CommissionScopes)[number];

export const RateTypes = ["percent", "fixed"] as const;
export type RateType = (typeof RateTypes)[number];

/** Règle de commission, telle que lue dans `commissionRules`. */
export interface CommissionRule {
  id: string;
  scope: CommissionScope;
  rateType: RateType;
  /** Pourcentage (ex. 7.5 pour 7,5 %) si rateType = percent. */
  rate: number | null;
  fixedAmount: Money | null;
  /** null : règle par défaut ; sinon règle propre à un partenaire. */
  orgId: string | null;
  validFrom: Date;
  /** null : sans date de fin. */
  validTo: Date | null;
  active: boolean;
}

interface TimestampLike {
  toDate(): Date;
}

/** Lit un document `commissionRules/{id}`. */
export function ruleFromData(id: string, d: Record<string, unknown>): CommissionRule {
  return {
    id,
    scope: d.scope as CommissionScope,
    rateType: d.rateType as RateType,
    rate: (d.rate as number | null | undefined) ?? null,
    fixedAmount: (d.fixedAmount as Money | null | undefined) ?? null,
    orgId: (d.orgId as string | null | undefined) ?? null,
    validFrom: (d.validFrom as TimestampLike).toDate(),
    validTo: d.validTo ? (d.validTo as TimestampLike).toDate() : null,
    active: d.active === true,
  };
}

export function isInForce(rule: CommissionRule, at: Date): boolean {
  return rule.active && rule.validFrom <= at && (rule.validTo === null || at < rule.validTo);
}

/**
 * Règle applicable à une date : celle du partenaire s'il en a une, sinon la règle
 * par défaut. Si plusieurs règles sont en vigueur, la plus récente (date de début
 * la plus tardive) l'emporte : un nouveau taux se programme sans toucher à l'ancien.
 */
export function selectRule(
  rules: CommissionRule[],
  query: { scope: CommissionScope; orgId: string | null; at: Date },
): CommissionRule | null {
  const inForce = rules.filter((r) => r.scope === query.scope && isInForce(r, query.at));
  const latest = (list: CommissionRule[]) =>
    list.sort((a, b) => b.validFrom.getTime() - a.validFrom.getTime())[0] ?? null;
  const specific = query.orgId ? latest(inForce.filter((r) => r.orgId === query.orgId)) : null;
  return specific ?? latest(inForce.filter((r) => r.orgId === null));
}

/** Montant de la commission, arrondi au franc près. */
export function computeCommission(rule: CommissionRule, base: Money): Money {
  if (rule.rateType === "fixed") return money(rule.fixedAmount?.amount ?? 0);
  return money(Math.round((base.amount * (rule.rate ?? 0)) / 100));
}

/**
 * Copie de la règle enregistrée avec chaque commission : un changement de taux
 * ultérieur ne modifie jamais les commissions déjà calculées.
 */
export function ruleSnapshot(rule: CommissionRule) {
  return {
    ruleId: rule.id,
    scope: rule.scope,
    rateType: rule.rateType,
    rate: rule.rate,
    fixedAmount: rule.fixedAmount,
    orgId: rule.orgId,
    validFrom: rule.validFrom,
    validTo: rule.validTo,
  };
}

/** Données envoyées par le back-office (fonction upsertCommissionRule). Dates en millisecondes. */
export const CommissionRuleInput = z.object({
  /** Absent : nouvelle règle. */
  ruleId: z.string().min(1).optional(),
  scope: z.enum(CommissionScopes),
  rateType: z.enum(RateTypes),
  rate: z.number().gt(0).max(100).nullable().optional(),
  fixedAmount: AmountInput.nullable().optional(),
  orgId: z.string().min(1).nullable().optional(),
  validFrom: z.number().int().positive(),
  validTo: z.number().int().positive().nullable().optional(),
  active: z.boolean(),
});
export type CommissionRuleInput = z.infer<typeof CommissionRuleInput>;

/** Règles métier d'une règle de commission. Renvoie le message à afficher, ou null. */
export function ruleProblem(r: CommissionRuleInput): string | null {
  if (r.rateType === "percent") {
    if (r.rate == null) return "Indiquez le taux de la commission.";
    if (Math.abs(r.rate * 100 - Math.round(r.rate * 100)) > 1e-9) {
      return "Le taux accepte au plus deux décimales.";
    }
  } else if (r.fixedAmount == null || r.fixedAmount <= 0) {
    return "Indiquez le montant fixe de la commission.";
  }
  if (r.validTo != null && r.validTo <= r.validFrom) {
    return "La date de fin doit être postérieure à la date de début.";
  }
  return null;
}

export const CommissionStatuses = ["due", "invoiced", "paid", "waived"] as const;
export type CommissionStatus = (typeof CommissionStatuses)[number];

// « Payée » et « offerte » sont définitives ; une facture peut être annulée (retour à « due »).
const transitions: Record<CommissionStatus, readonly CommissionStatus[]> = {
  due: ["invoiced", "paid", "waived"],
  invoiced: ["due", "paid", "waived"],
  paid: [],
  waived: [],
};

export function canMoveCommission(from: string, to: CommissionStatus): boolean {
  return (transitions[from as CommissionStatus] ?? []).includes(to);
}

export const UpdateCommissionStatusInput = z.object({
  commissionIds: z.array(z.string().min(1)).min(1).max(100),
  status: z.enum(CommissionStatuses),
  note: z.string().trim().max(500).optional(),
});

export const PreviewCommissionInput = z.object({
  scope: z.enum(CommissionScopes),
  orgId: z.string().min(1).nullable().optional(),
  amount: AmountInput,
  /** Date du calcul (millisecondes) ; maintenant par défaut. */
  at: z.number().int().positive().optional(),
});
