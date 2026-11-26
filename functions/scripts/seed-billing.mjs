// Crée le plan « Gratuit » et la règle de commission hôtelière par défaut.
// Les valeurs sont PROVISOIRES : l'équipe les ajuste ensuite dans le back-office
// (Facturation), sans développeur. Un élément déjà présent n'est pas modifié.
//
// Sur les émulateurs (par défaut) :
//   npm run seed-billing
// Sur un vrai projet, en PowerShell (identifiants gcloud requis :
// gcloud auth application-default login) :
//   $env:USE_EMULATORS = "false"; $env:GCLOUD_PROJECT = "zaka-dev-01"
//   npm run seed-billing
//   Remove-Item Env:USE_EMULATORS, Env:GCLOUD_PROJECT
// Option --force : remplace les éléments existants.
import { initializeApp } from "firebase-admin/app";
import { FieldValue, Timestamp, getFirestore } from "firebase-admin/firestore";

if (process.env.USE_EMULATORS !== "false") {
  process.env.FIRESTORE_EMULATOR_HOST ??= "127.0.0.1:8080";
  process.env.GCLOUD_PROJECT ??= "demo-zaka";
}
const force = process.argv.includes("--force");
console.log(`Projet : ${process.env.GCLOUD_PROJECT}`);

initializeApp({ projectId: process.env.GCLOUD_PROJECT });
const db = getFirestore();
const now = FieldValue.serverTimestamp();
const xof = (amount) => ({ amount, currency: "XOF" });

const items = [
  {
    path: "subscriptionPlans/free",
    action: "subscriptionPlan.create",
    data: {
      name: "Gratuit",
      description: "Plan de base de tout compte vérifié, sans abonnement payant.",
      price: xof(0),
      period: "month",
      target: "all",
      features: { maxListings: 3, featuredListings: 0, advancedStats: false },
      active: true,
    },
  },
  {
    path: "commissionRules/default_hotel_booking",
    action: "commissionRule.create",
    data: {
      scope: "hotel_booking",
      rateType: "percent",
      rate: 10,
      fixedAmount: null,
      orgId: null,
      orgName: null,
      validFrom: Timestamp.fromDate(new Date(Date.UTC(2026, 0, 1))),
      validTo: null,
      active: true,
    },
  },
];

for (const { path, action, data } of items) {
  const ref = db.doc(path);
  if ((await ref.get()).exists && !force) {
    console.log(`${path} : existe déjà, ignoré.`);
    continue;
  }
  const after = { ...data };
  if (after.validFrom) after.validFrom = after.validFrom.toDate().toISOString();
  const batch = db.batch();
  batch.set(ref, { ...data, updatedBy: "script:seed-billing", createdAt: now, updatedAt: now });
  batch.set(db.collection("auditLogs").doc(), {
    actorUid: "script:seed-billing",
    action,
    targetRef: path,
    before: null,
    after,
    at: now,
  });
  await batch.commit();
  console.log(`${path} : créé.`);
}
