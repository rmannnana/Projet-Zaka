import { z } from "zod";

import { money, type Money } from "../shared/format";

export const DAY_MS = 86_400_000;
export const MAX_NIGHTS = 30;

/** Jour calendaire « AAAA-MM-JJ », stocké à minuit UTC (heure du Burkina Faso). */
export const parseDay = (s: string) => new Date(`${s}T00:00:00Z`);
export const dayKey = (d: Date) => d.toISOString().slice(0, 10);
export const monthKey = (d: Date) => d.toISOString().slice(0, 7);
export const startOfUtcDay = (d: Date) =>
  new Date(Date.UTC(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate()));

export const DayString = z
  .string()
  .regex(/^\d{4}-\d{2}-\d{2}$/)
  .refine((s) => !Number.isNaN(parseDay(s).getTime()) && dayKey(parseDay(s)) === s, "Date invalide");

/** Nuits du séjour (date de chaque nuit). */
export function nightsOf(checkIn: Date, checkOut: Date): Date[] {
  const nights: Date[] = [];
  for (let t = checkIn.getTime(); t < checkOut.getTime(); t += DAY_MS) nights.push(new Date(t));
  return nights;
}

export function stayProblem(checkIn: Date, checkOut: Date, now: Date): string | null {
  const today = startOfUtcDay(now);
  if (checkIn < today) return "La date d'arrivée est passée.";
  if (checkIn.getTime() > today.getTime() + 365 * DAY_MS) {
    return "Les demandes se font au plus un an à l'avance.";
  }
  const nights = Math.round((checkOut.getTime() - checkIn.getTime()) / DAY_MS);
  if (nights < 1) return "La date de départ doit suivre la date d'arrivée.";
  if (nights > MAX_NIGHTS) return `Un séjour compte au plus ${MAX_NIGHTS} nuits.`;
  return null;
}

export interface RoomCapacity {
  capacityAdults: number;
  capacityChildren: number;
  quantity: number;
}

export function capacityProblem(
  guests: { adults: number; children: number; rooms: number },
  room: RoomCapacity,
): string | null {
  if (guests.rooms > room.quantity) {
    return `L'hôtel propose ${room.quantity} chambre${room.quantity > 1 ? "s" : ""} de ce type.`;
  }
  if (guests.adults > room.capacityAdults * guests.rooms) {
    return "Trop d'adultes pour le nombre de chambres choisi.";
  }
  if (guests.adults + guests.children > (room.capacityAdults + room.capacityChildren) * guests.rooms) {
    return "Trop de personnes pour le nombre de chambres choisi.";
  }
  return null;
}

/**
 * Disponibilités déclarées par l'hôtel, par mois : `{ "2026-12": { "24": 0 } }`.
 * Un jour absent compte toutes les chambres du type comme disponibles.
 */
export type Availability = Record<string, Record<string, number>>;

export function firstFullNight(
  nights: Date[],
  availability: Availability,
  quantity: number,
  rooms: number,
): Date | null {
  for (const night of nights) {
    const declared = availability[monthKey(night)]?.[dayKey(night).slice(8)];
    const free = typeof declared === "number" ? declared : quantity;
    if (free < rooms) return night;
  }
  return null;
}

export interface Offer {
  id: string;
  title: string;
  discountPercent: number;
  roomTypeIds: string[];
  validFrom: Date;
  validTo: Date;
}

/** Meilleure offre active applicable : date d'arrivée dans la période, type de chambre concerné. */
export function bestOffer(offers: Offer[], roomTypeId: string, checkIn: Date): Offer | null {
  return (
    offers
      .filter(
        (o) =>
          o.discountPercent > 0 &&
          o.discountPercent < 100 &&
          o.validFrom <= checkIn &&
          checkIn < o.validTo &&
          (o.roomTypeIds.length === 0 || o.roomTypeIds.includes(roomTypeId)),
      )
      .sort((a, b) => b.discountPercent - a.discountPercent)[0] ?? null
  );
}

/** Estimation montrée au client : prix par nuit × nuits × chambres, remise déduite, au franc près. */
export function estimateTotal(pricePerNight: Money, nights: number, rooms: number, discountPercent = 0): Money {
  return money(Math.round(pricePerNight.amount * nights * rooms * (1 - discountPercent / 100)));
}

export const CreateBookingInput = z.object({
  hotelId: z.string().min(1),
  roomTypeId: z.string().min(1),
  checkIn: DayString,
  checkOut: DayString,
  adults: z.number().int().min(1).max(50),
  children: z.number().int().min(0).max(50).default(0),
  rooms: z.number().int().min(1).max(20).default(1),
  message: z.string().trim().max(1000).default(""),
});
