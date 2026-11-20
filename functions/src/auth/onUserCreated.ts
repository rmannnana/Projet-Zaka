import { FieldValue } from "firebase-admin/firestore";
import * as functionsV1 from "firebase-functions/v1";

import { DEFAULT_COUNTRY, REGION, db } from "../shared/config";
import { countryFromPhone } from "../shared/phone";

/**
 * Crée le document `users/{uid}` à chaque inscription (e-mail, téléphone ou Google).
 * Les règles Firestore interdisent au client de le créer lui-même.
 *
 * Le déclencheur peut s'exécuter après une première action de l'utilisateur
 * (ex. création d'un espace pro, qui remplit `orgIds`) : les listes déjà
 * présentes ne sont jamais écrasées.
 */
export const onUserCreated = functionsV1
  .region(REGION)
  .auth.user()
  .onCreate(async (user) => {
    const ref = db.collection("users").doc(user.uid);
    await db.runTransaction(async (tx) => {
      const existing = await tx.get(ref);
      tx.set(
        ref,
        {
          displayName: user.displayName ?? "",
          email: user.email ?? null,
          phone: user.phoneNumber ?? null,
          photoUrl: user.photoURL ?? null,
          country: countryFromPhone(user.phoneNumber) ?? DEFAULT_COUNTRY,
          locale: "fr",
          ...(existing.get("orgIds") ? {} : { orgIds: [] }),
          ...(existing.get("fcmTokens") ? {} : { fcmTokens: [] }),
          status: "active",
          ...(existing.exists ? {} : { createdAt: FieldValue.serverTimestamp() }),
          updatedAt: FieldValue.serverTimestamp(),
        },
        { merge: true },
      );
    });
  });
