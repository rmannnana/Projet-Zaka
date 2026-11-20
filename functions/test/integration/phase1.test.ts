import { initializeApp as initAdmin } from "firebase-admin/app";
import { getAuth as getAdminAuth } from "firebase-admin/auth";
import { getFirestore as getAdminDb } from "firebase-admin/firestore";
import { deleteApp, initializeApp, type FirebaseApp } from "firebase/app";
import {
  connectAuthEmulator,
  createUserWithEmailAndPassword,
  getAuth,
  signInWithEmailAndPassword,
} from "firebase/auth";
import {
  addDoc,
  collection,
  connectFirestoreEmulator,
  doc,
  getFirestore,
  serverTimestamp,
  updateDoc,
} from "firebase/firestore";
import { connectFunctionsEmulator, getFunctions, httpsCallable } from "firebase/functions";
import { connectStorageEmulator, getStorage, ref, uploadBytes } from "firebase/storage";
import { afterAll, beforeAll, describe, expect, it } from "vitest";

// Parcours complet de la phase 1 sur les émulateurs (Auth, Firestore, Storage, Functions).
// Lancer avec : npm run test:integration
const projectId = "demo-zaka";
const host = "127.0.0.1";

process.env.FIREBASE_AUTH_EMULATOR_HOST ??= `${host}:9099`;
process.env.FIRESTORE_EMULATOR_HOST ??= `${host}:8080`;
const admin = initAdmin({ projectId }, "admin");
const adminAuth = getAdminAuth(admin);
const adminDb = getAdminDb(admin);

const apps: FirebaseApp[] = [];
const suffix = Date.now();

/** Un client connecté, avec son propre SDK (comme un téléphone différent). */
async function client(name: string, opts: { signUp?: boolean; claims?: object } = {}) {
  const app = initializeApp(
    { projectId, apiKey: "demo-api-key", storageBucket: `${projectId}.appspot.com` },
    `${name}-${suffix}`,
  );
  apps.push(app);
  const auth = getAuth(app);
  connectAuthEmulator(auth, `http://${host}:9099`, { disableWarnings: true });
  const db = getFirestore(app);
  connectFirestoreEmulator(db, host, 8080);
  const storage = getStorage(app);
  connectStorageEmulator(storage, host, 9199);
  const functions = getFunctions(app, "europe-west1");
  connectFunctionsEmulator(functions, host, 5001);

  const email = `${name}-${suffix}@exemple.bf`;
  if (opts.signUp === false) {
    await adminAuth.createUser({ email, password: "secret123", displayName: name });
  } else {
    await createUserWithEmailAndPassword(auth, email, "secret123");
  }
  if (opts.claims) {
    await adminAuth.setCustomUserClaims(auth.currentUser?.uid ?? (await adminAuth.getUserByEmail(email)).uid, opts.claims);
  }
  if (opts.signUp === false || opts.claims) {
    await signInWithEmailAndPassword(auth, email, "secret123");
  }
  const uid = auth.currentUser!.uid;
  const call = async (fn: string, data: unknown) =>
    (await httpsCallable(functions, fn)(data)).data as Record<string, unknown>;
  return { uid, email, db, storage, call };
}

/** Code d'erreur d'une fonction callable (ex. "functions/permission-denied"). */
async function errorCode(promise: Promise<unknown>) {
  try {
    await promise;
    return "ok";
  } catch (e) {
    return (e as { code: string }).code;
  }
}

const pdf = new Uint8Array([37, 80, 68, 70]);

async function uploadDossier(c: Awaited<ReturnType<typeof client>>, orgId: string) {
  const documents: Record<string, string> = {};
  for (const kind of ["ifu", "rccm", "proofOfAddress"]) {
    const path = `private/verification/${orgId}/${kind}_${Date.now()}.pdf`;
    await uploadBytes(ref(c.storage, path), pdf, { contentType: "application/pdf" });
    documents[kind] = path;
  }
  return documents;
}

let ali: Awaited<ReturnType<typeof client>>;
let moussa: Awaited<ReturnType<typeof client>>;
let modo: Awaited<ReturnType<typeof client>>;
let boss: Awaited<ReturnType<typeof client>>;
let orgId: string;

beforeAll(async () => {
  ali = await client("ali");
  moussa = await client("moussa");
  modo = await client("modo", { claims: { role: "moderator" } });
  boss = await client("boss", { claims: { role: "admin" } });
});

afterAll(async () => {
  await Promise.all(apps.map((a) => deleteApp(a)));
});

describe("vérification d'un compte pro", () => {
  it("création de l'hôtel en brouillon", async () => {
    const result = await ali.call("createOrganization", {
      type: "hotel",
      name: "Hôtel Nazemse",
      contact: { phone: "+22670000000", city: "Ouagadougou" },
    });
    orgId = result.orgId as string;
    const org = await adminDb.doc(`organizations/${orgId}`).get();
    expect(org.get("verification.status")).toBe("draft");
  });

  it("le dossier est refusé tant que les données légales manquent", async () => {
    const documents = await uploadDossier(ali, orgId);
    expect(await errorCode(ali.call("submitOrgVerification", { orgId, documents }))).toBe(
      "functions/failed-precondition",
    );
  });

  it("un dossier complet passe en attente et les pièces sont verrouillées", async () => {
    await updateDoc(doc(ali.db, `organizations/${orgId}`), {
      legal: { ifuNumber: "00012345A", rccmNumber: "BF-OUA-2026-B-1234", representativeName: "Ali Ouédraogo" },
    });
    const documents = await uploadDossier(ali, orgId);
    expect(await ali.call("submitOrgVerification", { orgId, documents })).toEqual({ status: "pending" });
    expect(await errorCode(uploadDossier(ali, orgId))).toBe("storage/unauthorized");
  });

  it("seul le staff décide, et un refus exige un motif", async () => {
    expect(await errorCode(ali.call("reviewOrg", { orgId, decision: "verify" }))).toBe(
      "functions/permission-denied",
    );
    expect(await errorCode(modo.call("reviewOrg", { orgId, decision: "reject" }))).toBe(
      "functions/invalid-argument",
    );
    await modo.call("reviewOrg", { orgId, decision: "reject", note: "RCCM illisible" });

    const notifications = await adminDb.collection(`users/${ali.uid}/notifications`).get();
    expect(notifications.docs.map((d) => d.get("title"))).toContain("Dossier refusé");
  });

  it("après correction, le dossier est renvoyé puis validé", async () => {
    const documents = await uploadDossier(ali, orgId);
    await ali.call("submitOrgVerification", { orgId, documents });
    expect(await modo.call("reviewOrg", { orgId, decision: "verify" })).toEqual({ status: "verified" });

    const audit = await adminDb.collection("auditLogs").where("targetRef", "==", `organizations/${orgId}`).get();
    const actions = audit.docs.map((d) => d.get("action"));
    expect(actions).toEqual(
      expect.arrayContaining(["organization.create", "organization.reject", "organization.verify"]),
    );
  });
});

describe("membres et rôles", () => {
  it("le propriétaire ajoute un membre, mais ne peut pas retirer le dernier propriétaire", async () => {
    await ali.call("addOrgMember", { orgId, email: moussa.email, role: "editor" });
    const member = await adminDb.doc(`organizations/${orgId}/members/${moussa.uid}`).get();
    expect(member.get("role")).toBe("editor");
    expect(await errorCode(ali.call("removeOrgMember", { orgId, uid: ali.uid }))).toBe(
      "functions/failed-precondition",
    );
  });

  it("seul un admin attribue les rôles, et jamais à lui-même", async () => {
    expect(await errorCode(modo.call("setUserRole", { uid: moussa.uid, role: "moderator" }))).toBe(
      "functions/permission-denied",
    );
    expect(await errorCode(boss.call("setUserRole", { uid: boss.uid, role: "none" }))).toBe(
      "functions/failed-precondition",
    );
    await boss.call("setUserRole", { uid: modo.uid, role: "moderator" });
    expect((await adminAuth.getUser(modo.uid)).customClaims).toEqual({ role: "moderator" });
  });
});

describe("effacement des données personnelles", () => {
  it("bloqué si l'utilisateur est le seul propriétaire d'un compte pro", async () => {
    const req = await addDoc(collection(ali.db, "deletionRequests"), {
      uid: ali.uid,
      status: "pending",
      requestedAt: serverTimestamp(),
    });
    expect(await errorCode(modo.call("processDataDeletion", { requestId: req.id, decision: "done" }))).toBe(
      "functions/failed-precondition",
    );
  });

  it("efface le profil et le compte, et retire la personne du compte pro", async () => {
    const req = await addDoc(collection(moussa.db, "deletionRequests"), {
      uid: moussa.uid,
      status: "pending",
      requestedAt: serverTimestamp(),
    });
    expect(await modo.call("processDataDeletion", { requestId: req.id, decision: "done" })).toEqual({
      status: "done",
    });

    expect((await adminDb.doc(`users/${moussa.uid}`).get()).exists).toBe(false);
    expect((await adminDb.doc(`organizations/${orgId}/members/${moussa.uid}`).get()).exists).toBe(false);
    expect(await errorCode(adminAuth.getUser(moussa.uid))).toBe("auth/user-not-found");
    expect((await adminDb.doc(`deletionRequests/${req.id}`).get()).get("status")).toBe("done");
  });
});
