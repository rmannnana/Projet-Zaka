import { readFileSync } from "node:fs";
import { join } from "node:path";

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import {
  collection,
  doc,
  getDoc,
  getDocs,
  query,
  serverTimestamp,
  setDoc,
  updateDoc,
  where,
} from "firebase/firestore";
import { afterAll, beforeAll, beforeEach, describe, it } from "vitest";

// Lancer avec : npm run test:emulators (démarre l'émulateur Firestore).
let env: RulesTestEnvironment;

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-zaka",
    firestore: {
      rules: readFileSync(join(process.cwd(), "..", "firebase", "firestore.rules"), "utf8"),
    },
  });
});

afterAll(() => env.cleanup());

const contact = { phone: "+22670000000", city: "ouagadougou", country: "BF" };

beforeEach(async () => {
  await env.clearFirestore();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    const orgs: Record<string, object> = {
      // Particulier : vérifié d'office, publication soumise à validation.
      owner1: {
        type: "individual_owner",
        name: "Awa",
        contact,
        verification: { status: "verified" },
        publishingMode: "review",
      },
      // Agence vérifiée : publication directe.
      agency1: {
        type: "agency",
        name: "Faso Immo",
        contact,
        verification: { status: "verified" },
        publishingMode: "direct",
      },
      // Hôtel pas encore vérifié.
      hotel1: {
        type: "hotel",
        name: "Hôtel Nazemse",
        contact,
        verification: { status: "pending" },
        publishingMode: "direct",
      },
    };
    for (const [id, data] of Object.entries(orgs)) {
      await setDoc(doc(db, "organizations", id), data);
    }
    await setDoc(doc(db, "organizations/owner1/members/awa"), { role: "owner" });
    await setDoc(doc(db, "organizations/agency1/members/moussa"), { role: "owner" });
    await setDoc(doc(db, "organizations/hotel1/members/ali"), { role: "owner" });

    await setDoc(doc(db, "users/awa"), { displayName: "Awa", orgIds: ["owner1"], status: "active" });
    await setDoc(doc(db, "properties/published1"), { orgId: "owner1", status: "published", title: "Villa" });
    await setDoc(doc(db, "properties/draft1"), { orgId: "agency1", status: "draft", title: "F3" });

    // Facturation : écrite uniquement par les Cloud Functions.
    const xof = (amount: number) => ({ amount, currency: "XOF" });
    await setDoc(doc(db, "subscriptionPlans/free"), { name: "Gratuit", price: xof(0), active: true });
    await setDoc(doc(db, "commissionRules/rule1"), { scope: "hotel_booking", rate: 10, active: true });
    await setDoc(doc(db, "subscriptions/sub1"), { orgId: "agency1", planId: "pro", status: "active" });
    await setDoc(doc(db, "payments/pay1"), {
      payerUid: "moussa",
      payerOrgId: "agency1",
      amount: xof(15000),
      status: "succeeded",
    });
    await setDoc(doc(db, "commissions/com1"), { orgId: "hotel1", amount: xof(4500), status: "due" });
    await setDoc(doc(db, "organizations/agency1/members/fatou"), { role: "editor" });

    // Annonces et demandes (phases 3 et 4).
    await setDoc(doc(db, "organizations/hotel2"), {
      type: "hotel",
      name: "Hôtel Splendid",
      contact,
      verification: { status: "verified" },
      publishingMode: "direct",
    });
    await setDoc(doc(db, "organizations/hotel2/members/sali"), { role: "owner" });
    await setDoc(doc(db, "hotels/banned"), { orgId: "hotel2", status: "suspended", name: "Suspendu" });
    await setDoc(doc(db, "properties/live2"), { orgId: "agency1", status: "published", title: "Duplex" });
    await setDoc(doc(db, "bookingRequests/b1"), { clientUid: "awa", orgId: "hotel2", status: "pending" });
    await setDoc(doc(db, "leads/l1"), { clientUid: "awa", orgId: "agency1", status: "new", message: "Bonjour" });
  });
});

const as = (uid: string, claims: object = {}) => env.authenticatedContext(uid, claims).firestore();
const anon = () => env.unauthenticatedContext().firestore();

describe("annonces immobilières", () => {
  it("un visiteur lit une annonce publiée mais pas un brouillon", async () => {
    await assertSucceeds(getDoc(doc(anon(), "properties/published1")));
    await assertFails(getDoc(doc(anon(), "properties/draft1")));
  });

  it("une annonce se crée en brouillon : la mise en ligne passe par publishListing", async () => {
    await assertSucceeds(
      setDoc(doc(as("awa"), "properties/new1"), { orgId: "owner1", status: "draft", title: "F2" }),
    );
    await assertFails(
      setDoc(doc(as("awa"), "properties/new2"), { orgId: "owner1", status: "pending_review", title: "F2" }),
    );
    await assertFails(
      setDoc(doc(as("moussa"), "properties/new3"), { orgId: "agency1", status: "published", title: "Duplex" }),
    );
  });

  it("modifier une annonce publiée d'un particulier la renvoie en validation", async () => {
    const db = as("awa");
    await assertFails(updateDoc(doc(db, "properties/published1"), { title: "Villa rénovée" }));
    await assertSucceeds(
      updateDoc(doc(db, "properties/published1"), { title: "Villa rénovée", status: "pending_review" }),
    );
    // En attente de validation : plus modifiable avant la décision de ZAKA.
    await assertFails(updateDoc(doc(db, "properties/published1"), { title: "Autre", status: "pending_review" }));
  });

  it("une agence modifie son annonce en ligne et la passe en louée, sans pouvoir la republier seule", async () => {
    const db = as("moussa");
    await assertSucceeds(updateDoc(doc(db, "properties/live2"), { title: "Duplex rénové" }));
    await assertSucceeds(updateDoc(doc(db, "properties/live2"), { status: "rented" }));
    await assertFails(updateDoc(doc(db, "properties/live2"), { status: "published" }));
    await assertFails(updateDoc(doc(db, "properties/draft1"), { status: "rented" }));
  });

  it("personne ne publie pour une autre organisation", async () => {
    await assertFails(
      setDoc(doc(as("moussa"), "properties/new4"), { orgId: "owner1", status: "draft", title: "X" }),
    );
  });

  it("un pro ne touche ni à la mise en avant, ni à la modération, ni aux statistiques", async () => {
    const db = as("moussa");
    await assertFails(
      setDoc(doc(db, "properties/new5"), { orgId: "agency1", status: "draft", featured: true }),
    );
    await assertFails(updateDoc(doc(db, "properties/live2"), { featured: true }));
    await assertFails(updateDoc(doc(db, "properties/live2"), { "stats.views": 1000 }));
    await assertFails(updateDoc(doc(db, "properties/live2"), { moderation: { reason: null } }));
  });
});

describe("hôtels", () => {
  it("un hôtel non vérifié ne peut rien créer", async () => {
    await assertFails(
      setDoc(doc(as("ali"), "hotels/h1"), { orgId: "hotel1", status: "draft", name: "Nazemse" }),
    );
  });

  it("un hôtel vérifié crée sa fiche en brouillon, sans prix calculé ni mise en avant", async () => {
    const db = as("sali");
    await assertSucceeds(setDoc(doc(db, "hotels/h2"), { orgId: "hotel2", status: "draft", name: "Splendid" }));
    await assertFails(
      setDoc(doc(db, "hotels/h3"), { orgId: "hotel2", status: "draft", name: "X", minPricePerNight: { amount: 1 } }),
    );
    await assertFails(setDoc(doc(db, "hotels/h4"), { orgId: "hotel2", status: "published", name: "X" }));
    await assertSucceeds(setDoc(doc(db, "hotels/h2/roomTypes/r1"), { name: "Double", active: true }));
  });

  it("une fiche suspendue par ZAKA n'est plus modifiable par l'hôtel", async () => {
    await assertFails(updateDoc(doc(as("sali"), "hotels/banned"), { name: "Nouveau nom" }));
    await assertFails(getDoc(doc(anon(), "hotels/banned")));
  });
});

describe("messagerie", () => {
  const msg = (fromUid: string, fromRole = "client") => ({
    fromUid,
    fromRole,
    text: "Bonjour, avez-vous un parking ?",
    createdAt: serverTimestamp(),
  });

  it("le client et l'hôtel écrivent dans leur demande, personne d'autre", async () => {
    await assertSucceeds(setDoc(doc(as("awa"), "bookingRequests/b1/messages/m1"), msg("awa")));
    await assertSucceeds(setDoc(doc(as("sali"), "bookingRequests/b1/messages/m2"), msg("sali", "hotel")));
    await assertFails(setDoc(doc(as("moussa"), "bookingRequests/b1/messages/m3"), msg("moussa")));
    await assertFails(setDoc(doc(as("awa"), "bookingRequests/b1/messages/m4"), msg("sali", "hotel")));
    await assertFails(
      setDoc(doc(as("awa"), "bookingRequests/b1/messages/m5"), { ...msg("awa"), silent: true }),
    );
  });

  it("une réservation ne s'écrit que par les Cloud Functions", async () => {
    await assertFails(updateDoc(doc(as("sali"), "bookingRequests/b1"), { status: "accepted" }));
    await assertSucceeds(getDoc(doc(as("awa"), "bookingRequests/b1")));
    await assertFails(getDoc(doc(as("moussa"), "bookingRequests/b1")));
  });
});

describe("organisations et utilisateurs", () => {
  it("le propriétaire ne peut pas changer son statut de vérification", async () => {
    await assertFails(
      updateDoc(doc(as("ali"), "organizations/hotel1"), { "verification.status": "verified" }),
    );
    await assertSucceeds(
      updateDoc(doc(as("ali"), "organizations/hotel1"), { description: "Au centre-ville" }),
    );
  });

  it("les données légales sont figées une fois le dossier envoyé", async () => {
    // hotel1 est "pending" : IFU non modifiable.
    await assertFails(
      updateDoc(doc(as("ali"), "organizations/hotel1"), { legal: { ifuNumber: "000" } }),
    );
    await env.withSecurityRulesDisabled((ctx) =>
      updateDoc(doc(ctx.firestore(), "organizations/hotel1"), { "verification.status": "rejected" }),
    );
    await assertSucceeds(
      updateDoc(doc(as("ali"), "organizations/hotel1"), { legal: { ifuNumber: "000" } }),
    );
  });

  it("un utilisateur modifie son nom mais pas ses organisations", async () => {
    await assertSucceeds(updateDoc(doc(as("awa"), "users/awa"), { displayName: "Awa K." }));
    await assertFails(updateDoc(doc(as("awa"), "users/awa"), { orgIds: ["agency1"] }));
  });

  it("un utilisateur ne lit pas le profil d'un autre, un modérateur oui", async () => {
    await assertFails(getDoc(doc(as("moussa"), "users/awa")));
    await assertSucceeds(getDoc(doc(as("modo", { role: "moderator" }), "users/awa")));
  });
});

describe("demandes", () => {
  it("un client ne crée pas de réservation directement (Cloud Function obligatoire)", async () => {
    await assertFails(
      setDoc(doc(as("awa"), "bookingRequests/b1"), { clientUid: "awa", orgId: "hotel1", status: "pending" }),
    );
  });

  it("un signalement est créé au nom de son auteur, avec des champs contrôlés", async () => {
    const report = {
      targetType: "property",
      targetId: "published1",
      reporterUid: "moussa",
      reason: "fraud",
      status: "open",
      createdAt: serverTimestamp(),
    };
    await assertSucceeds(setDoc(doc(as("moussa"), "reports/r1"), report));
    await assertFails(setDoc(doc(as("moussa"), "reports/r2"), { ...report, status: "resolved" }));
    await assertFails(setDoc(doc(as("moussa"), "reports/r3"), { ...report, reporterUid: "awa" }));
    await assertFails(setDoc(doc(as("moussa"), "reports/r4"), { ...report, handledBy: "moussa" }));
    await assertFails(getDoc(doc(as("moussa"), "reports/r1")));
  });

  it("un utilisateur demande la suppression de ses propres données uniquement", async () => {
    const req = { uid: "awa", status: "pending", requestedAt: serverTimestamp() };
    await assertSucceeds(setDoc(doc(as("awa"), "deletionRequests/d1"), req));
    await assertFails(setDoc(doc(as("moussa"), "deletionRequests/d2"), req));
    await assertFails(setDoc(doc(as("awa"), "deletionRequests/d3"), { ...req, status: "done" }));
    await assertFails(updateDoc(doc(as("awa"), "deletionRequests/d1"), { status: "done" }));
  });

  it("une demande de contact passe par createLead ; le pro en change seulement le statut", async () => {
    await assertFails(
      setDoc(doc(as("awa"), "leads/l2"), { clientUid: "awa", orgId: "agency1", status: "new" }),
    );
    await assertSucceeds(updateDoc(doc(as("moussa"), "leads/l1"), { status: "in_progress" }));
    await assertFails(updateDoc(doc(as("moussa"), "leads/l1"), { message: "modifié" }));
    await assertFails(updateDoc(doc(as("awa"), "leads/l1"), { status: "closed" }));
  });
});

describe("facturation", () => {
  it("la grille des plans est publique, les règles de commission réservées à l'équipe", async () => {
    await assertSucceeds(getDoc(doc(anon(), "subscriptionPlans/free")));
    await assertFails(getDoc(doc(as("ali"), "commissionRules/rule1")));
    await assertSucceeds(getDoc(doc(as("modo", { role: "moderator" }), "commissionRules/rule1")));
  });

  it("personne n'écrit les plans, règles, abonnements, paiements ou commissions depuis l'app", async () => {
    const admin = as("boss", { role: "admin" });
    await assertFails(setDoc(doc(admin, "subscriptionPlans/pro"), { name: "Pro", active: true }));
    await assertFails(updateDoc(doc(admin, "commissionRules/rule1"), { rate: 1 }));
    await assertFails(updateDoc(doc(as("moussa"), "subscriptions/sub1"), { status: "active" }));
    await assertFails(updateDoc(doc(as("moussa"), "payments/pay1"), { status: "succeeded" }));
    await assertFails(setDoc(doc(as("moussa"), "payments/pay2"), { payerUid: "moussa", status: "succeeded" }));
    await assertFails(updateDoc(doc(as("ali"), "commissions/com1"), { status: "paid" }));
  });

  it("les membres d'un compte voient ses abonnements et paiements, pas les autres", async () => {
    await assertSucceeds(getDoc(doc(as("fatou"), "subscriptions/sub1")));
    await assertSucceeds(getDoc(doc(as("fatou"), "payments/pay1")));
    await assertSucceeds(
      getDocs(query(collection(as("fatou"), "payments"), where("payerOrgId", "==", "agency1"))),
    );
    await assertFails(getDoc(doc(as("awa"), "subscriptions/sub1")));
    await assertFails(getDoc(doc(as("awa"), "payments/pay1")));
    await assertFails(
      getDocs(query(collection(as("awa"), "payments"), where("payerOrgId", "==", "agency1"))),
    );
  });

  it("un hôtel voit ses commissions, pas celles des autres", async () => {
    await assertSucceeds(getDoc(doc(as("ali"), "commissions/com1")));
    await assertFails(getDoc(doc(as("moussa"), "commissions/com1")));
    await assertSucceeds(getDocs(query(collection(as("ali"), "commissions"), where("orgId", "==", "hotel1"))));
  });
});
