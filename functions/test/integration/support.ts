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
import { connectFirestoreEmulator, getFirestore } from "firebase/firestore";
import { connectFunctionsEmulator, getFunctions, httpsCallable } from "firebase/functions";
import { connectStorageEmulator, getStorage } from "firebase/storage";

// Outils communs aux parcours testés sur les émulateurs (Auth, Firestore, Storage, Functions).
export const projectId = "demo-zaka";
export const host = "127.0.0.1";

process.env.FIREBASE_AUTH_EMULATOR_HOST ??= `${host}:9099`;
process.env.FIRESTORE_EMULATOR_HOST ??= `${host}:8080`;
process.env.GCLOUD_PROJECT ??= projectId;
const admin = initAdmin({ projectId }, "admin");
export const adminAuth = getAdminAuth(admin);
export const adminDb = getAdminDb(admin);

const apps: FirebaseApp[] = [];
export const suffix = Date.now();

/** Enregistre une app cliente pour la fermer en fin de fichier. */
export function track(app: FirebaseApp) {
  apps.push(app);
  return app;
}

export async function closeClients() {
  await Promise.all(apps.map((a) => deleteApp(a)));
}

/** Un client connecté, avec son propre SDK (comme un téléphone différent). */
export async function client(name: string, opts: { signUp?: boolean; claims?: object } = {}) {
  const app = track(
    initializeApp(
      { projectId, apiKey: "demo-api-key", storageBucket: `${projectId}.appspot.com` },
      `${name}-${suffix}`,
    ),
  );
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
    await adminAuth.setCustomUserClaims(
      auth.currentUser?.uid ?? (await adminAuth.getUserByEmail(email)).uid,
      opts.claims,
    );
  }
  if (opts.signUp === false || opts.claims) {
    await signInWithEmailAndPassword(auth, email, "secret123");
  }
  const uid = auth.currentUser!.uid;
  const call = async (fn: string, data?: unknown) =>
    (await httpsCallable(functions, fn)(data)).data as Record<string, unknown>;
  return { uid, email, db, storage, functions, call };
}

export type Client = Awaited<ReturnType<typeof client>>;

/** Code d'erreur d'une fonction callable (ex. "functions/permission-denied"), ou "ok". */
export async function errorCode(promise: Promise<unknown>) {
  try {
    await promise;
    return "ok";
  } catch (e) {
    return (e as { code: string }).code;
  }
}

/** Titres des notifications reçues par un utilisateur. */
export async function notificationTitles(uid: string) {
  const snap = await adminDb.collection(`users/${uid}/notifications`).get();
  return snap.docs.map((d) => d.get("title") as string);
}
