import { db } from "./config";

/** Délai de réponse d'un hôtel à une demande de réservation (document `config/app`). */
export async function bookingExpiryHours(): Promise<number> {
  const snap = await db.collection("config").doc("app").get();
  const hours = snap.get("bookingExpiryHours");
  return typeof hours === "number" && hours > 0 && hours <= 24 * 14 ? hours : 48;
}

/** Adresse du site public, pour les liens des e-mails et des notifications push. */
export function appUrl(): string {
  return process.env.APP_URL ?? `https://${process.env.GCLOUD_PROJECT ?? "zaka"}.web.app`;
}

/** Adresse du back-office, pour les alertes envoyées à l'équipe ZAKA. */
export function adminUrl(): string {
  return process.env.ADMIN_URL ?? appUrl();
}

/** Lien absolu (back-office) ou chemin de l'app publique. */
export function absoluteLink(link: string | null | undefined): string {
  if (!link) return appUrl();
  return link.startsWith("http") ? link : `${appUrl()}${link}`;
}
