import { HttpsError, type CallableRequest } from "firebase-functions/v2/https";
import { z } from "zod";

import type { StaffRole } from "./constants";

/** Uid de l'appelant, ou erreur si personne n'est connecté. */
export function requireAuth(request: CallableRequest): string {
  const uid = request.auth?.uid;
  if (!uid) throw new HttpsError("unauthenticated", "Connexion requise.");
  return uid;
}

export function staffRoleOf(request: CallableRequest): StaffRole | null {
  const role = request.auth?.token.role;
  return role === "admin" || role === "moderator" ? role : null;
}

/** Modérateur ou admin. */
export function requireStaff(request: CallableRequest): string {
  const uid = requireAuth(request);
  if (!staffRoleOf(request)) {
    throw new HttpsError("permission-denied", "Réservé à l'équipe ZAKA.");
  }
  return uid;
}

export function requireAdmin(request: CallableRequest): string {
  const uid = requireAuth(request);
  if (staffRoleOf(request) !== "admin") {
    throw new HttpsError("permission-denied", "Réservé aux administrateurs.");
  }
  return uid;
}

/** Valide les données reçues avec un schéma zod. */
export function parseInput<T extends z.ZodType>(schema: T, data: unknown): z.infer<T> {
  const parsed = schema.safeParse(data);
  if (!parsed.success) {
    throw new HttpsError("invalid-argument", "Données invalides.", z.treeifyError(parsed.error));
  }
  return parsed.data;
}
