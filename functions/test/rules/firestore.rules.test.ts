import { readFileSync } from "node:fs";
import { join } from "node:path";

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, getDoc, setDoc, updateDoc } from "firebase/firestore";
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
  });
});

const as = (uid: string, claims: object = {}) => env.authenticatedContext(uid, claims).firestore();
const anon = () => env.unauthenticatedContext().firestore();

describe("annonces immobilières", () => {
  it("un visiteur lit une annonce publiée mais pas un brouillon", async () => {
    await assertSucceeds(getDoc(doc(anon(), "properties/published1")));
    await assertFails(getDoc(doc(anon(), "properties/draft1")));
  });

  it("un particulier ne peut pas publier directement", async () => {
    await assertFails(
      setDoc(doc(as("awa"), "properties/new1"), { orgId: "owner1", status: "published", title: "F2" }),
    );
  });

  it("un particulier peut soumettre une annonce à validation", async () => {
    await assertSucceeds(
      setDoc(doc(as("awa"), "properties/new1"), { orgId: "owner1", status: "pending_review", title: "F2" }),
    );
  });

  it("modifier une annonce publiée d'un particulier la renvoie en validation", async () => {
    const db = as("awa");
    await assertFails(updateDoc(doc(db, "properties/published1"), { title: "Villa rénovée" }));
    await assertSucceeds(
      updateDoc(doc(db, "properties/published1"), { title: "Villa rénovée", status: "pending_review" }),
    );
  });

  it("une agence vérifiée publie directement", async () => {
    await assertSucceeds(
      setDoc(doc(as("moussa"), "properties/new2"), { orgId: "agency1", status: "published", title: "Duplex" }),
    );
  });

  it("personne ne publie pour une autre organisation", async () => {
    await assertFails(
      setDoc(doc(as("moussa"), "properties/new3"), { orgId: "owner1", status: "pending_review", title: "X" }),
    );
  });

  it("un pro ne peut pas se mettre lui-même en avant", async () => {
    await assertFails(
      setDoc(doc(as("moussa"), "properties/new4"), { orgId: "agency1", status: "published", featured: true }),
    );
  });
});

describe("hôtels", () => {
  it("un hôtel non vérifié ne peut rien publier", async () => {
    await assertFails(
      setDoc(doc(as("ali"), "hotels/h1"), { orgId: "hotel1", status: "draft", name: "Nazemse" }),
    );
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

  it("un client crée une demande de contact à son nom uniquement", async () => {
    await assertSucceeds(
      setDoc(doc(as("awa"), "leads/l1"), { clientUid: "awa", orgId: "agency1", status: "new" }),
    );
    await assertFails(
      setDoc(doc(as("awa"), "leads/l2"), { clientUid: "moussa", orgId: "agency1", status: "new" }),
    );
  });
});
