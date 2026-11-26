// Remplit les catalogues de référence (villes, équipements, types de biens)
// et la configuration de l'app (`config/app` : délai de réponse aux réservations).
// Les listes restent ensuite modifiables depuis le back-office (admin).
//
// Sur les émulateurs (par défaut) :
//   npm run seed-catalog
// Sur un vrai projet, en PowerShell (identifiants gcloud requis :
// gcloud auth application-default login) :
//   $env:USE_EMULATORS = "false"; $env:GCLOUD_PROJECT = "zaka-dev-01"
//   npm run seed-catalog
//   Remove-Item Env:USE_EMULATORS, Env:GCLOUD_PROJECT
// Option --force : remplace les listes existantes.
import { initializeApp } from "firebase-admin/app";
import { FieldValue, getFirestore } from "firebase-admin/firestore";

if (process.env.USE_EMULATORS !== "false") {
  process.env.FIRESTORE_EMULATOR_HOST ??= "127.0.0.1:8080";
  process.env.GCLOUD_PROJECT ??= "demo-zaka";
}
const force = process.argv.includes("--force");

const city = (country) => (name) => ({ name, country });

const catalogs = {
  cities: [
    // Burkina Faso en tête (marché prioritaire).
    ...[
      "Ouagadougou",
      "Bobo-Dioulasso",
      "Koudougou",
      "Banfora",
      "Ouahigouya",
      "Kaya",
      "Tenkodogo",
      "Fada N'Gourma",
      "Dédougou",
      "Ziniaré",
      "Manga",
      "Gaoua",
      "Dori",
      "Réo",
      "Koupéla",
    ].map(city("BF")),
    ...["Cotonou", "Porto-Novo", "Abomey-Calavi", "Parakou"].map(city("BJ")),
    ...["Abidjan", "Yamoussoukro", "Bouaké", "San-Pédro", "Korhogo"].map(city("CI")),
    ...["Bissau"].map(city("GW")),
    ...["Bamako", "Sikasso", "Ségou", "Kayes"].map(city("ML")),
    ...["Niamey", "Maradi", "Zinder"].map(city("NE")),
    ...["Dakar", "Thiès", "Saint-Louis", "Mbour", "Touba"].map(city("SN")),
    ...["Lomé", "Kara", "Sokodé"].map(city("TG")),
  ],
  amenities: [
    ["wifi", "Wi-Fi", "both"],
    ["air_conditioning", "Climatisation", "both"],
    ["parking", "Parking", "both"],
    ["generator", "Groupe électrogène", "both"],
    ["water_tank", "Réserve d'eau", "both"],
    ["security", "Gardiennage", "both"],
    ["pool", "Piscine", "both"],
    ["restaurant", "Restaurant", "hotel"],
    ["breakfast", "Petit-déjeuner", "hotel"],
    ["room_service", "Service en chambre", "hotel"],
    ["meeting_room", "Salle de conférence", "hotel"],
    ["airport_shuttle", "Navette aéroport", "hotel"],
    ["tv", "Télévision", "hotel"],
    ["furnished", "Meublé", "property"],
    ["garden", "Jardin", "property"],
    ["terrace", "Terrasse", "property"],
    ["fitted_kitchen", "Cuisine équipée", "property"],
    ["boys_quarter", "Dépendance", "property"],
  ].map(([id, label, scope]) => ({ id, label, scope })),
  propertyTypes: [
    ["villa", "Villa"],
    ["apartment", "Appartement"],
    ["studio", "Studio"],
    ["entrance_room", "Chambre-salon"],
    ["courtyard_house", "Maison en cour commune"],
    ["duplex", "Duplex"],
    ["land", "Terrain"],
    ["office", "Bureau"],
    ["shop", "Boutique"],
    ["warehouse", "Entrepôt"],
  ].map(([id, label]) => ({ id, label })),
};

initializeApp({ projectId: process.env.GCLOUD_PROJECT });
const db = getFirestore();

for (const [name, items] of Object.entries(catalogs)) {
  const ref = db.doc(`catalog/${name}`);
  const existing = await ref.get();
  if (existing.exists && !force) {
    console.log(`catalog/${name} : déjà rempli (${existing.get("items")?.length ?? 0} entrées), ignoré.`);
    continue;
  }
  await ref.set({ items, updatedAt: FieldValue.serverTimestamp() });
  console.log(`catalog/${name} : ${items.length} entrées.`);
}

// Configuration générale : délai de réponse d'un hôtel à une demande de réservation.
const configRef = db.doc("config/app");
if ((await configRef.get()).exists && !force) {
  console.log("config/app : déjà rempli, ignoré.");
} else {
  await configRef.set({ bookingExpiryHours: 48, minAppVersion: "1.0.0", updatedAt: FieldValue.serverTimestamp() });
  console.log("config/app : créé (réponse sous 48 h).");
}
