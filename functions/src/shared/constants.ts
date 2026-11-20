/** Région de toutes les fonctions (voir docs/PLAN_CONCEPTION.md). */
export const REGION = "europe-west1";

/** Pays ouverts au lancement : zone UEMOA. Burkina Faso par défaut. */
export const UEMOA_COUNTRIES = ["BF", "BJ", "CI", "GW", "ML", "NE", "SN", "TG"] as const;
export const DEFAULT_COUNTRY = "BF";

export type StaffRole = "admin" | "moderator";
