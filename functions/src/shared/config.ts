import { initializeApp } from "firebase-admin/app";
import { getFirestore } from "firebase-admin/firestore";
import { setGlobalOptions } from "firebase-functions/v2";

import { REGION } from "./constants";

export * from "./constants";

setGlobalOptions({ region: REGION, maxInstances: 10 });

initializeApp();

export const db = getFirestore();
