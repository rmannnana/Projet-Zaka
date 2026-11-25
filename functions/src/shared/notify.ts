import { FieldValue, type Transaction, type WriteBatch } from "firebase-admin/firestore";

import { db } from "./config";

export interface Notification {
  title: string;
  body: string;
  /** Route de l'app à ouvrir, ex. "/pro/abc". */
  link?: string;
  /** Doublée d'un e-mail (par défaut oui ; non pour les messages de discussion). */
  email?: boolean;
}

/**
 * Ajoute une notification dans `users/{uid}/notifications` (affichée dans l'app).
 * La fonction onNotificationCreated l'envoie ensuite en push et par e-mail.
 */
export function notifyUser(writer: WriteBatch | Transaction, uid: string, n: Notification): void {
  const ref = db.collection("users").doc(uid).collection("notifications").doc();
  (writer as WriteBatch).set(ref, {
    title: n.title,
    body: n.body,
    link: n.link ?? null,
    email: n.email ?? true,
    read: false,
    createdAt: FieldValue.serverTimestamp(),
  });
}

/** Membres d'une organisation (propriétaires et éditeurs). */
export async function memberUids(orgId: string, role?: "owner" | "editor"): Promise<string[]> {
  const members = db.collection("organizations").doc(orgId).collection("members");
  const snap = await (role ? members.where("role", "==", role) : members).select().get();
  return snap.docs.map((d) => d.id);
}

/** Membres de l'équipe ZAKA (admins et modérateurs). */
export async function staffUids(): Promise<string[]> {
  const snap = await db.collection("users").where("staffRole", "in", ["admin", "moderator"]).select().get();
  return snap.docs.map((d) => d.id);
}
