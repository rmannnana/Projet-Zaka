import { FieldValue } from "firebase-admin/firestore";
import { onDocumentWritten } from "firebase-functions/v2/firestore";

import { db } from "../shared/config";
import { money } from "../shared/format";
import { ListingKinds, listingCollection } from "./status";

/**
 * Prix « à partir de » et capacité maximale d'un hôtel, recalculés à chaque
 * modification d'un type de chambre (servent aux filtres de recherche).
 */
export const onRoomTypeWritten = onDocumentWritten("hotels/{hotelId}/roomTypes/{roomTypeId}", async (event) => {
  const hotelRef = db.collection("hotels").doc(event.params.hotelId);
  const rooms = await hotelRef.collection("roomTypes").where("active", "==", true).get();
  const prices = rooms.docs
    .map((d) => d.get("pricePerNight.amount"))
    .filter((p): p is number => typeof p === "number" && p > 0);
  const guests = rooms.docs.map((d) => (d.get("capacityAdults") ?? 0) + (d.get("capacityChildren") ?? 0));
  if (!(await hotelRef.get()).exists) return;
  await hotelRef.update({
    minPricePerNight: prices.length ? money(Math.min(...prices)) : null,
    maxGuests: guests.length ? Math.max(...guests) : 0,
    roomTypesCount: rooms.size,
  });
});

/** Prix « à partir de » et lots disponibles d'un programme, recalculés à chaque modification d'un lot. */
export const onUnitWritten = onDocumentWritten("projects/{projectId}/units/{unitId}", async (event) => {
  const projectRef = db.collection("projects").doc(event.params.projectId);
  const units = await projectRef.collection("units").get();
  const available = units.docs.filter((d) => d.get("status") === "available");
  const prices = available
    .map((d) => d.get("price.amount"))
    .filter((p): p is number => typeof p === "number" && p > 0);
  if (!(await projectRef.get()).exists) return;
  await projectRef.update({
    priceFrom: prices.length ? money(Math.min(...prices)) : null,
    unitsCount: units.size,
    unitsAvailable: available.length,
  });
});

/**
 * Compte pro suspendu (ou données effacées) : ses annonces sont retirées ;
 * elles reviennent dans leur état précédent quand le compte est rétabli.
 */
export async function setOrgListingsSuspended(orgId: string, suspended: boolean) {
  const writer = db.bulkWriter();
  for (const kind of ListingKinds) {
    const collection = db.collection(listingCollection[kind]);
    const snap = suspended
      ? await collection.where("orgId", "==", orgId).get()
      : await collection.where("orgId", "==", orgId).where("suspendedWithOrg", "==", true).get();
    for (const doc of snap.docs) {
      if (suspended) {
        if (doc.get("status") === "suspended") continue;
        writer.update(doc.ref, {
          status: "suspended",
          previousStatus: doc.get("status"),
          suspendedWithOrg: true,
          featured: false,
          updatedAt: FieldValue.serverTimestamp(),
        });
      } else {
        writer.update(doc.ref, {
          status: doc.get("previousStatus") ?? "inactive",
          previousStatus: null,
          suspendedWithOrg: FieldValue.delete(),
          updatedAt: FieldValue.serverTimestamp(),
        });
      }
    }
  }
  await writer.close();
}
