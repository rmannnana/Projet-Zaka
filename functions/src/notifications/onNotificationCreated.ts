import { getMessaging } from "firebase-admin/messaging";
import { FieldValue } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";
import { onDocumentCreated } from "firebase-functions/v2/firestore";

import { absoluteLink } from "../shared/appConfig";
import { db } from "../shared/config";

const escapeHtml = (s: string) =>
  s.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");

/** Contenu de l'e-mail (collection `mail`, envoyée par l'extension Trigger Email). */
export function mailFor(n: { title: string; body: string; link?: string | null }) {
  const url = absoluteLink(n.link);
  return {
    subject: `ZAKA · ${n.title}`,
    text: `${n.body}\n\nOuvrir ZAKA : ${url}\n\nCet e-mail vous est envoyé automatiquement par ZAKA.`,
    html:
      `<div style="font-family:Arial,sans-serif;max-width:560px">` +
      `<h2 style="color:#1F4EA1">${escapeHtml(n.title)}</h2>` +
      `<p>${escapeHtml(n.body)}</p>` +
      `<p><a href="${escapeHtml(url)}" style="background:#1F4EA1;color:#fff;padding:10px 16px;` +
      `border-radius:6px;text-decoration:none">Ouvrir ZAKA</a></p>` +
      `<p style="color:#777;font-size:12px">Cet e-mail vous est envoyé automatiquement par ZAKA.</p></div>`,
  };
}

/**
 * Chaque notification de l'app part aussi en push (appareils enregistrés) et,
 * sauf indication contraire, par e-mail. Sans l'extension Trigger Email, les
 * e-mails restent en attente dans la collection `mail`.
 */
export const onNotificationCreated = onDocumentCreated(
  "users/{uid}/notifications/{notificationId}",
  async (event) => {
    const n = event.data?.data();
    if (!n) return;
    const userRef = db.collection("users").doc(event.params.uid);
    const user = (await userRef.get()).data();
    if (!user) return;

    const tokens: string[] = Array.isArray(user.fcmTokens) ? user.fcmTokens : [];
    if (tokens.length > 0) {
      const link = absoluteLink(n.link);
      const result = await getMessaging().sendEachForMulticast({
        tokens,
        notification: { title: n.title, body: n.body },
        data: { link: n.link ?? "/" },
        webpush: { fcmOptions: { link } },
        android: { priority: "high", notification: { channelId: "zaka" } },
      });
      const stale = result.responses
        .map((r, i) => (!r.success && r.error?.code?.includes("registration-token") ? tokens[i] : null))
        .filter((t): t is string => t !== null);
      if (stale.length > 0) {
        await userRef.update({ fcmTokens: FieldValue.arrayRemove(...stale) });
      }
      logger.info("Push envoyé", { success: result.successCount, failure: result.failureCount });
    }

    if (n.email !== false && typeof user.email === "string" && user.email.includes("@")) {
      await db.collection("mail").add({
        to: user.email,
        message: mailFor(n as { title: string; body: string; link?: string }),
        createdAt: FieldValue.serverTimestamp(),
      });
    }
  },
);
