import { z } from "zod";

/** Devise unique au lancement : le franc CFA de l'UEMOA. */
export const CURRENCY = "XOF";

/** Montant stocké en entier : le XOF n'a pas de centimes. Format Firestore `{ amount, currency }`. */
export interface Money {
  amount: number;
  currency: typeof CURRENCY;
}

export const money = (amount: number): Money => ({ amount, currency: CURRENCY });

/** Montant saisi par l'admin ou calculé : entier positif en francs CFA. */
export const AmountInput = z.number().int().min(0).max(1_000_000_000);

const amountFormat = new Intl.NumberFormat("fr-FR");

/** « 125 000 FCFA » */
export function formatMoney(m: Money): string {
  return `${amountFormat.format(m.amount)} FCFA`;
}

// Le Burkina Faso, marché prioritaire, est à l'heure UTC toute l'année.
const dateFormat = new Intl.DateTimeFormat("fr-FR", {
  day: "numeric",
  month: "long",
  year: "numeric",
  timeZone: "Africa/Ouagadougou",
});

/** « 24 décembre 2026 » */
export function formatDate(date: Date): string {
  return dateFormat.format(date);
}
