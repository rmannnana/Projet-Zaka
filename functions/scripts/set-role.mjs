// Attribue un rôle staff (admin ou moderator) à un utilisateur.
//
// Sur les émulateurs (par défaut) :
//   npm run set-role -- awa@exemple.com admin
// Sur un vrai projet (identifiants gcloud requis) :
//   USE_EMULATORS=false GCLOUD_PROJECT=zaka-dev npm run set-role -- awa@exemple.com admin
// Pour retirer le rôle : npm run set-role -- awa@exemple.com none
import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";

const [email, role] = process.argv.slice(2);
const allowed = ["admin", "moderator", "none"];
if (!email || !allowed.includes(role)) {
  console.error("Usage : npm run set-role -- <email> <admin|moderator|none>");
  process.exit(1);
}

if (process.env.USE_EMULATORS !== "false") {
  process.env.FIREBASE_AUTH_EMULATOR_HOST ??= "127.0.0.1:9099";
  process.env.GCLOUD_PROJECT ??= "demo-zaka";
}

initializeApp({ projectId: process.env.GCLOUD_PROJECT });
const auth = getAuth();
const user = await auth.getUserByEmail(email);
await auth.setCustomUserClaims(user.uid, role === "none" ? {} : { role });
console.log(`${email} (${user.uid}) -> rôle : ${role}`);
console.log("L'utilisateur doit se reconnecter pour que le rôle soit pris en compte.");
