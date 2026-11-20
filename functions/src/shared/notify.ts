import { FieldValue, type Transaction, type WriteBatch } from "firebase-admin/firestore";

import { db } from "./config";

export interface Notification {
  title: string;
  body: string;
  /** Route de l'app à ouvrir, ex. "/pro/abc". */
  link?: string;
}

/**
 * Ajoute une notification dans `users/{uid}/notifications` (affichée dans l'app).
 * L'envoi push et e-mail viendra avec la phase 3.
 */
export function notifyUser(writer: WriteBatch | Transaction, uid: string, n: Notification): void {
  const ref = db.collection("users").doc(uid).collection("notifications").doc();
  (writer as WriteBatch).set(ref, {
    title: n.title,
    body: n.body,
    link: n.link ?? null,
    read: false,
    createdAt: FieldValue.serverTimestamp(),
  });
}
