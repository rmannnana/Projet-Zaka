import { z } from "zod";

import type { OrgType } from "../organizations/schema";
import { AmountInput, formatDate } from "../shared/format";

/** Plan de base, appliqué d'office à tout compte sans abonnement payant en cours. */
export const FREE_PLAN_ID = "free";

export const PlanPeriods = ["month", "year"] as const;
export type PlanPeriod = (typeof PlanPeriods)[number];

export const PlanTargets = ["hotel", "real_estate", "all"] as const;
export type PlanTarget = (typeof PlanTargets)[number];

export const PlanFeatures = z.object({
  /** Nombre d'annonces publiées en même temps ; null = illimité. */
  maxListings: z.number().int().min(0).max(100_000).nullable(),
  /** Annonces mises en avant dans les résultats. */
  featuredListings: z.number().int().min(0).max(1_000),
  advancedStats: z.boolean(),
});

/** Données envoyées par le back-office (fonction upsertSubscriptionPlan). */
export const SubscriptionPlanInput = z.object({
  /** Absent : nouveau plan. */
  planId: z
    .string()
    .regex(/^[A-Za-z0-9_-]{2,40}$/)
    .optional(),
  name: z.string().trim().min(2).max(60),
  description: z.string().trim().max(500).default(""),
  price: AmountInput,
  period: z.enum(PlanPeriods),
  target: z.enum(PlanTargets),
  features: PlanFeatures,
  active: z.boolean(),
});
export type SubscriptionPlanInput = z.infer<typeof SubscriptionPlanInput>;

/** Règles métier d'un plan. Renvoie le message à afficher à l'admin, ou null. */
export function planProblem(p: SubscriptionPlanInput): string | null {
  if (p.planId === FREE_PLAN_ID) {
    if (p.price !== 0) return "Le plan Gratuit reste à 0 FCFA.";
    if (!p.active) {
      return "Le plan Gratuit ne peut pas être désactivé : c'est le plan de base de tous les comptes.";
    }
    if (p.target !== "all") return "Le plan Gratuit s'adresse à tous les types de comptes.";
    return null;
  }
  if (p.price <= 0) return "Un plan payant doit avoir un prix supérieur à 0.";
  return null;
}

/** Un plan « hôtel » ne concerne que les hôtels, un plan « immobilier » tous les autres publieurs. */
export function planFitsOrg(target: PlanTarget, orgType: OrgType): boolean {
  if (target === "all") return true;
  return target === "hotel" ? orgType === "hotel" : orgType !== "hotel";
}

/**
 * Ajoute une période (en UTC). Le mois suivant garde le même jour, ramené
 * au dernier jour du mois si besoin : un abonnement du 31 janvier finit le 28 février.
 */
export function addPeriod(from: Date, period: PlanPeriod): Date {
  const date = new Date(from.getTime());
  const day = date.getUTCDate();
  date.setUTCDate(1);
  date.setUTCMonth(date.getUTCMonth() + (period === "month" ? 1 : 12));
  const lastDay = new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + 1, 0)).getUTCDate();
  date.setUTCDate(Math.min(day, lastDay));
  return date;
}

export interface CurrentSubscription {
  planId: string;
  status: string;
  currentPeriodEnd: Date;
}

export interface PaidPeriod {
  /** "renew" : prolonge l'abonnement en cours ; "new" : nouvel abonnement. */
  mode: "renew" | "new";
  start: Date;
  end: Date;
}

/**
 * Période couverte par un paiement :
 * - même plan, encore en cours : prolongation à partir de la fin actuelle (renouvellement anticipé) ;
 * - sinon : nouvelle période à partir de maintenant. L'abonnement précédent est remplacé,
 *   sans remboursement au prorata.
 */
export function periodFor(
  current: CurrentSubscription | null,
  planId: string,
  period: PlanPeriod,
  now: Date,
): PaidPeriod {
  if (
    current &&
    current.status === "active" &&
    current.planId === planId &&
    current.currentPeriodEnd > now
  ) {
    return {
      mode: "renew",
      start: current.currentPeriodEnd,
      end: addPeriod(current.currentPeriodEnd, period),
    };
  }
  return { mode: "new", start: now, end: addPeriod(now, period) };
}

/** Un abonnement compte tant qu'il est actif et que sa période n'est pas finie. */
export function isRunning(sub: CurrentSubscription | null, now: Date): boolean {
  return sub !== null && sub.status === "active" && sub.currentPeriodEnd > now;
}

/** Délai du rappel avant la fin d'un abonnement. */
export const RENEWAL_REMINDER_DAYS = 7;

export const subscriptionMessages = {
  activated: (plan: string, end: Date) => ({
    title: "Abonnement activé",
    body: `Votre abonnement ${plan} est actif jusqu'au ${formatDate(end)}.`,
  }),
  renewed: (plan: string, end: Date) => ({
    title: "Abonnement prolongé",
    body: `Votre abonnement ${plan} est prolongé jusqu'au ${formatDate(end)}.`,
  }),
  expiringSoon: (plan: string, end: Date) => ({
    title: "Abonnement bientôt terminé",
    body: `Votre abonnement ${plan} se termine le ${formatDate(end)}. Renouvelez-le pour garder ses avantages.`,
  }),
  expired: (plan: string) => ({
    title: "Abonnement terminé",
    body: `Votre abonnement ${plan} est terminé : votre compte est repassé au plan Gratuit.`,
  }),
};
