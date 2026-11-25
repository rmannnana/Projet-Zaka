// Point d'entrée des Cloud Functions de ZAKA.
// La liste complète prévue est dans docs/PLAN_CONCEPTION.md (section 6).
import "./shared/config";

export { onUserCreated } from "./auth/onUserCreated";
export { syncProfileFromAuth } from "./auth/syncProfileFromAuth";
export { createOrganization } from "./organizations/createOrganization";
export { submitOrgVerification } from "./organizations/submitOrgVerification";
export { reviewOrg } from "./organizations/reviewOrg";
export { addOrgMember, removeOrgMember } from "./organizations/members";
export { setUserRole } from "./admin/setUserRole";
export { processDataDeletion } from "./privacy/processDataDeletion";
export {
  upsertSubscriptionPlan,
  upsertCommissionRule,
  previewCommission,
  updateCommissionStatus,
} from "./billing/adminBilling";
export { startPayment, confirmSimulatedPayment } from "./billing/payments";
export { expireSubscriptions } from "./billing/maintenance";
export { onNotificationCreated } from "./notifications/onNotificationCreated";
export { onBookingMessageCreated, onLeadMessageCreated, onReportCreated } from "./notifications/messaging";
export {
  publishListing,
  reviewListing,
  moderateListing,
  setFeatured,
  recordView,
} from "./listings/listingFunctions";
export { onRoomTypeWritten, onUnitWritten } from "./listings/triggers";
export { createBookingRequest, updateBookingStatus } from "./bookings/bookingFunctions";
export { bookingMaintenance } from "./bookings/bookingMaintenance";
export { createLead, onLeadUpdated } from "./leads/leadFunctions";
export { exportDisputeFile } from "./moderation/exportDisputeFile";
