// Point d'entrée des Cloud Functions de ZAKA.
// La liste complète prévue est dans docs/PLAN_CONCEPTION.md (section 6).
import "./shared/config";

export { onUserCreated } from "./auth/onUserCreated";
export { createOrganization } from "./organizations/createOrganization";
export { submitOrgVerification } from "./organizations/submitOrgVerification";
export { reviewOrg } from "./organizations/reviewOrg";
export { addOrgMember, removeOrgMember } from "./organizations/members";
export { setUserRole } from "./admin/setUserRole";
export { processDataDeletion } from "./privacy/processDataDeletion";
