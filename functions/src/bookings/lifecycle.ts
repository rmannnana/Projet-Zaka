import { z } from "zod";

import { formatDate, formatDateTime } from "../shared/format";

export const BookingStatuses = [
  "pending",
  "info_requested",
  "accepted",
  "rejected",
  "cancelled",
  "expired",
  "completed",
] as const;
export type BookingStatus = (typeof BookingStatuses)[number];

export const BookingActions = ["accept", "reject", "request_info", "complete", "cancel"] as const;
export type BookingAction = (typeof BookingActions)[number];
export type BookingActor = "hotel" | "client";

/** Demandes en attente d'une réponse de l'hôtel (soumises à l'expiration de 48 h). */
export const OPEN_STATUSES: readonly BookingStatus[] = ["pending", "info_requested"];

/** Après la date de départ, une réservation acceptée est considérée terminée au bout de ce délai. */
export const AUTO_COMPLETE_DAYS = 3;

const transitions: Record<BookingActor, Partial<Record<BookingAction, { from: BookingStatus[]; to: BookingStatus }>>> = {
  hotel: {
    accept: { from: ["pending", "info_requested"], to: "accepted" },
    reject: { from: ["pending", "info_requested"], to: "rejected" },
    request_info: { from: ["pending"], to: "info_requested" },
    complete: { from: ["accepted"], to: "completed" },
    cancel: { from: ["accepted"], to: "cancelled" },
  },
  client: {
    cancel: { from: ["pending", "info_requested", "accepted"], to: "cancelled" },
  },
};

export function nextBookingStatus(actor: BookingActor, action: BookingAction, from: string): BookingStatus | null {
  const t = transitions[actor][action];
  return t && t.from.includes(from as BookingStatus) ? t.to : null;
}

/** Demander des précisions ou annuler une réservation acceptée exige un message pour l'autre partie. */
export const needsNote = (actor: BookingActor, action: BookingAction) =>
  action === "request_info" || (actor === "hotel" && action === "cancel");

export const UpdateBookingInput = z.object({
  requestId: z.string().min(1),
  action: z.enum(BookingActions),
  note: z.string().trim().max(1000).optional(),
});

export const statusLabels: Record<BookingStatus, string> = {
  pending: "en attente",
  info_requested: "en attente de vos précisions",
  accepted: "acceptée",
  rejected: "refusée",
  cancelled: "annulée",
  expired: "expirée",
  completed: "terminée",
};

interface BookingSummary {
  hotelName: string;
  roomTypeName: string;
  clientName: string;
  checkIn: Date;
  checkOut: Date;
}

const stay = (b: BookingSummary) => `du ${formatDate(b.checkIn)} au ${formatDate(b.checkOut)}`;

/** Textes des notifications d'une demande de réservation. */
export const bookingMessages = {
  created: (b: BookingSummary, deadline: Date) => ({
    title: "Nouvelle demande de réservation",
    body: `${b.clientName} souhaite une ${b.roomTypeName} ${stay(b)}. Répondez avant le ${formatDateTime(deadline)}.`,
  }),
  accepted: (b: BookingSummary) => ({
    title: "Réservation acceptée",
    body: `${b.hotelName} a accepté votre demande ${stay(b)}. Vous pouvez payer en ligne ou à l'hôtel.`,
  }),
  rejected: (b: BookingSummary, note?: string) => ({
    title: "Demande refusée",
    body: `${b.hotelName} ne peut pas vous accueillir ${stay(b)}.${note ? ` Message : ${note}` : ""}`,
  }),
  infoRequested: (b: BookingSummary, note: string) => ({
    title: "L'hôtel vous demande des précisions",
    body: `${b.hotelName} : ${note}`,
  }),
  cancelledByHotel: (b: BookingSummary, note: string) => ({
    title: "Réservation annulée par l'hôtel",
    body: `${b.hotelName} a annulé votre réservation ${stay(b)} : ${note}`,
  }),
  cancelledByClient: (b: BookingSummary) => ({
    title: "Demande annulée par le client",
    body: `${b.clientName} a annulé sa demande ${stay(b)}.`,
  }),
  completed: (b: BookingSummary) => ({
    title: "Séjour terminé",
    body: `Merci d'avoir séjourné à ${b.hotelName}. À bientôt sur ZAKA !`,
  }),
  expiredClient: (b: BookingSummary) => ({
    title: "Demande expirée",
    body: `${b.hotelName} n'a pas répondu à temps à votre demande ${stay(b)}. Essayez un autre hôtel.`,
  }),
  expiredHotel: (b: BookingSummary) => ({
    title: "Demande expirée sans réponse",
    body: `La demande de ${b.clientName} ${stay(b)} a expiré sans réponse.`,
  }),
  reminder: (b: BookingSummary, deadline: Date) => ({
    title: "Demande bientôt expirée",
    body: `Répondez à ${b.clientName} avant le ${formatDateTime(deadline)}, sinon sa demande expirera.`,
  }),
  paid: (b: BookingSummary) => ({
    title: "Réservation payée",
    body: `${b.clientName} a payé sa réservation ${stay(b)} (paiement de test).`,
  }),
};

/** Résumé d'un document `bookingRequests` pour les messages. */
export function summaryOf(d: FirebaseFirestore.DocumentData): BookingSummary {
  return {
    hotelName: d.hotelName ?? "L'hôtel",
    roomTypeName: d.roomTypeName ?? "chambre",
    clientName: d.clientSnapshot?.name ?? "Un client",
    checkIn: d.checkIn.toDate(),
    checkOut: d.checkOut.toDate(),
  };
}
