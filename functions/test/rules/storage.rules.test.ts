import { readFileSync } from "node:fs";
import { join } from "node:path";

import {
  assertFails,
  assertSucceeds,
  initializeTestEnvironment,
  type RulesTestEnvironment,
} from "@firebase/rules-unit-testing";
import { doc, setDoc } from "firebase/firestore";
import { getBytes, ref, uploadBytes, uploadString } from "firebase/storage";
import { afterAll, beforeAll, beforeEach, describe, it } from "vitest";

// Lancer avec : npm run test:emulators (démarre les émulateurs Firestore et Storage).
// Les règles Storage lisent Firestore (membres, statut du dossier).
let env: RulesTestEnvironment;
const root = join(process.cwd(), "..", "firebase");

beforeAll(async () => {
  env = await initializeTestEnvironment({
    projectId: "demo-zaka",
    firestore: { rules: readFileSync(join(root, "firestore.rules"), "utf8") },
    storage: { rules: readFileSync(join(root, "storage.rules"), "utf8") },
  });
});

afterAll(() => env.cleanup());

beforeEach(async () => {
  await env.clearFirestore();
  await env.clearStorage();
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    const orgs = {
      hotelDraft: { type: "hotel", verification: { status: "draft" } },
      hotelPending: { type: "hotel", verification: { status: "pending" } },
      owner1: { type: "individual_owner", verification: { status: "verified" } },
    };
    for (const [id, data] of Object.entries(orgs)) {
      await setDoc(doc(db, "organizations", id), data);
      await setDoc(doc(db, `organizations/${id}/members/ali`), { role: "owner" });
    }
    await uploadString(
      ref(ctx.storage(), "private/verification/hotelPending/ifu_1.pdf"),
      "pdf",
      undefined,
      { contentType: "application/pdf" },
    );
  });
});

const pdf = new Uint8Array([37, 80, 68, 70]);
const asPdf = { contentType: "application/pdf" };
const storageOf = (uid: string, claims: object = {}) => env.authenticatedContext(uid, claims).storage();

describe("pièces justificatives", () => {
  it("un membre dépose une pièce tant que le dossier est en brouillon", async () => {
    await assertSucceeds(
      uploadBytes(ref(storageOf("ali"), "private/verification/hotelDraft/rccm_1732.pdf"), pdf, asPdf),
    );
  });

  it("le nom du fichier doit suivre le format attendu", async () => {
    await assertFails(
      uploadBytes(ref(storageOf("ali"), "private/verification/hotelDraft/statuts.pdf"), pdf, asPdf),
    );
  });

  it("aucun dépôt pendant l'examen du dossier, ni pour un particulier", async () => {
    await assertFails(
      uploadBytes(ref(storageOf("ali"), "private/verification/hotelPending/rccm_2.pdf"), pdf, asPdf),
    );
    await assertFails(
      uploadBytes(ref(storageOf("ali"), "private/verification/owner1/ifu_2.pdf"), pdf, asPdf),
    );
  });

  it("une pièce déposée ne peut pas être écrasée", async () => {
    await env.withSecurityRulesDisabled((ctx) =>
      setDoc(doc(ctx.firestore(), "organizations/hotelPending"), {
        type: "hotel",
        verification: { status: "rejected" },
      }),
    );
    await assertFails(
      uploadBytes(ref(storageOf("ali"), "private/verification/hotelPending/ifu_1.pdf"), pdf, asPdf),
    );
  });

  it("un non-membre ne dépose ni ne lit les pièces, un modérateur les lit", async () => {
    await assertFails(
      uploadBytes(ref(storageOf("moussa"), "private/verification/hotelDraft/ifu_3.pdf"), pdf, asPdf),
    );
    await assertFails(getBytes(ref(storageOf("moussa"), "private/verification/hotelPending/ifu_1.pdf")));
    await assertSucceeds(
      getBytes(ref(storageOf("modo", { role: "moderator" }), "private/verification/hotelPending/ifu_1.pdf")),
    );
  });
});
