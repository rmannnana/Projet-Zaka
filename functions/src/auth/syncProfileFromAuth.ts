import { FieldValue } from "firebase-admin/firestore";
import { onCall } from "firebase-functions/v2/https";

import { db } from "../shared/config";
import { requireAuth } from "../shared/guards";
import { countryFromPhone } from "../shared/phone";

/**
 * Recopie dans `users/{uid}` le téléphone et l'e-mail vérifiés par Firebase Auth
 * (après une connexion par SMS ou l'ajout d'un numéro au compte). Le client ne
 * peut pas écrire ces champs lui-même : seules les valeurs vérifiées comptent.
 */
export const syncProfileFromAuth = onCall(async (request) => {
  const uid = requireAuth(request);
  const token = request.auth!.token;
  const phone = token.phone_number ?? null;

  const update: Record<string, unknown> = {
    phone,
    email: token.email ?? null,
    updatedAt: FieldValue.serverTimestamp(),
  };
  const ref = db.collection("users").doc(uid);
  const current = await ref.get();
  // Le pays suit le premier numéro vérifié, sauf si l'utilisateur l'a déjà choisi.
  if (phone && (!current.exists || !current.get("phone"))) {
    const country = countryFromPhone(phone);
    if (country) update.country = country;
  }
  await ref.set(update, { merge: true });
  return { phone };
});
