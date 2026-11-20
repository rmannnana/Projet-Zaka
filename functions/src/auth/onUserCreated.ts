import { FieldValue } from "firebase-admin/firestore";
import * as functionsV1 from "firebase-functions/v1";

import { DEFAULT_COUNTRY, REGION, db } from "../shared/config";
import { countryFromPhone } from "../shared/phone";

/**
 * Crée le document `users/{uid}` à chaque inscription (e-mail, téléphone ou Google).
 * Les règles Firestore interdisent au client de le créer lui-même.
 */
export const onUserCreated = functionsV1
  .region(REGION)
  .auth.user()
  .onCreate(async (user) => {
    await db.collection("users").doc(user.uid).set(
      {
        displayName: user.displayName ?? "",
        email: user.email ?? null,
        phone: user.phoneNumber ?? null,
        photoUrl: user.photoURL ?? null,
        country: countryFromPhone(user.phoneNumber) ?? DEFAULT_COUNTRY,
        locale: "fr",
        orgIds: [],
        fcmTokens: [],
        status: "active",
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      },
      { merge: true },
    );
  });
