// Point d'entrée des Cloud Functions de ZAKA.
// La liste complète prévue est dans docs/PLAN_CONCEPTION.md (section 6).
import "./shared/config";

export { onUserCreated } from "./auth/onUserCreated";
export { createOrganization } from "./organizations/createOrganization";
