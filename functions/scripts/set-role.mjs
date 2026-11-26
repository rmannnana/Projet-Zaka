// Attribue un rôle staff (admin ou moderator) à un utilisateur.
// Sert surtout à nommer le premier admin d'un projet : les rôles suivants
// se donnent depuis le back-office (écran Équipe, fonction setUserRole).
//
// Sur les émulateurs (par défaut) :
//   npm run set-role -- awa@exemple.com admin
// Sur un vrai projet, en PowerShell (identifiants gcloud requis :
// gcloud auth application-default login). L'API Auth exige un projet de quota
// quand on utilise ses identifiants personnels, d'où GOOGLE_CLOUD_QUOTA_PROJECT :
//   $env:USE_EMULATORS = "false"; $env:GCLOUD_PROJECT = "zaka-dev-01"; $env:GOOGLE_CLOUD_QUOTA_PROJECT = "zaka-dev-01"
//   npm run set-role -- awa@exemple.com admin
//   Remove-Item Env:USE_EMULATORS, Env:GCLOUD_PROJECT, Env:GOOGLE_CLOUD_QUOTA_PROJECT
// Pour retirer le rôle : npm run set-role -- awa@exemple.com none
import { initializeApp } from "firebase-admin/app";
import { getAuth } from "firebase-admin/auth";
import { FieldValue, getFirestore } from "firebase-admin/firestore";

const [email, role] = process.argv.slice(2);
const allowed = ["admin", "moderator", "none"];
if (!email || !allowed.includes(role)) {
  console.error("Usage : npm run set-role -- <email> <admin|moderator|none>");
  process.exit(1);
}

if (process.env.USE_EMULATORS !== "false") {
  process.env.FIREBASE_AUTH_EMULATOR_HOST ??= "127.0.0.1:9099";
  process.env.FIRESTORE_EMULATOR_HOST ??= "127.0.0.1:8080";
  process.env.GCLOUD_PROJECT ??= "demo-zaka";
}
console.log(`Projet : ${process.env.GCLOUD_PROJECT}`);

initializeApp({ projectId: process.env.GCLOUD_PROJECT });
const auth = getAuth();
const db = getFirestore();

// Même effet que la fonction setUserRole : les autres claims sont conservés,
// le rôle est recopié dans users/{uid}.staffRole (liste de l'équipe) et journalisé.
const user = await auth.getUserByEmail(email);
const previous = user.customClaims?.role ?? "none";
const { role: _old, ...otherClaims } = user.customClaims ?? {};
await auth.setCustomUserClaims(user.uid, role === "none" ? otherClaims : { ...otherClaims, role });

const batch = db.batch();
batch.set(
  db.doc(`users/${user.uid}`),
  { staffRole: role === "none" ? null : role, updatedAt: FieldValue.serverTimestamp() },
  { merge: true },
);
batch.set(db.collection("auditLogs").doc(), {
  actorUid: "script:set-role",
  action: "user.setRole",
  targetRef: `users/${user.uid}`,
  before: { role: previous },
  after: { role },
  at: FieldValue.serverTimestamp(),
});
await batch.commit();

console.log(`${email} (${user.uid}) : ${previous} -> ${role}`);
console.log("L'utilisateur doit se déconnecter puis se reconnecter pour que le rôle soit pris en compte.");
