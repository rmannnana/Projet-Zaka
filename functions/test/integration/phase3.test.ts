import { Timestamp } from "firebase-admin/firestore";
import { getStorage } from "firebase-admin/storage";
import {
  Timestamp as ClientTimestamp,
  addDoc,
  collection,
  doc,
  serverTimestamp,
  setDoc,
  updateDoc,
} from "firebase/firestore";
import { afterAll, beforeAll, describe, expect, it } from "vitest";

import { adminDb, client, closeClients, errorCode, notificationTitles, projectId, type Client } from "./support";

// Parcours hôtellerie et immobilier (phases 3 et 4) sur les émulateurs.
// Lancer avec : npm run test:integration
const DAY = 24 * 60 * 60 * 1000;
const dayString = (offset: number) => new Date(Date.now() + offset * DAY).toISOString().slice(0, 10);
const xof = (amount: number) => ({ amount, currency: "XOF" });

/** Attend qu'un déclencheur Firestore ait fait son travail. */
async function eventually<T>(read: () => Promise<T>, ok: (v: T) => boolean, ms = 20_000): Promise<T> {
  const start = Date.now();
  for (;;) {
    const value = await read();
    if (ok(value)) return value;
    if (Date.now() - start > ms) throw new Error("Délai dépassé en attendant un déclencheur");
    await new Promise((r) => setTimeout(r, 300));
  }
}

let hotelier: Client;
let traveller: Client;
let owner: Client;
let modo: Client;
let hotelOrg: string;
let hotelId: string;
let bookingId: string;
let propertyId: string;

async function verifiedOrg(c: Client, data: object) {
  const ref = adminDb.collection("organizations").doc();
  await ref.set({ contact: { phone: "+22670000009", city: "Ouagadougou", country: "BF" }, ...data });
  await ref.collection("members").doc(c.uid).set({ role: "owner" });
  return ref.id;
}

beforeAll(async () => {
  hotelier = await client("hotelier3");
  traveller = await client("voyageur3");
  owner = await client("particulier3");
  modo = await client("modo3", { claims: { role: "moderator" } });

  // Plan Gratuit limité à 1 annonce, commission hôtelière de 10 %.
  await adminDb.doc("subscriptionPlans/free").set({
    name: "Gratuit",
    price: xof(0),
    period: "month",
    target: "all",
    features: { maxListings: 1, featuredListings: 0, advancedStats: false },
    active: true,
  });
  await adminDb.doc("commissionRules/test_default").set({
    scope: "hotel_booking",
    rateType: "percent",
    rate: 10,
    fixedAmount: null,
    orgId: null,
    validFrom: Timestamp.fromMillis(Date.UTC(2026, 0, 1)),
    validTo: null,
    active: true,
  });
  hotelOrg = await verifiedOrg(hotelier, {
    type: "hotel",
    name: "Hôtel Laafi",
    verification: { status: "verified" },
    publishingMode: "direct",
  });
}, 120_000);

afterAll(closeClients);

describe("fiche hôtel", () => {
  it("l'hôtel crée sa fiche et une chambre ; le prix « à partir de » se calcule tout seul", async () => {
    const ref = await addDoc(collection(hotelier.db, "hotels"), {
      orgId: hotelOrg,
      name: "Hôtel Laafi",
      city: "Ouagadougou",
      district: "Ouaga 2000",
      photos: ["https://exemple.bf/laafi.jpg"],
      amenities: ["wifi", "pool"],
      status: "draft",
      createdAt: serverTimestamp(),
    });
    hotelId = ref.id;
    expect(await errorCode(hotelier.call("publishListing", { kind: "hotel", id: hotelId }))).toBe(
      "functions/failed-precondition",
    );
    await setDoc(doc(hotelier.db, `hotels/${hotelId}/roomTypes/double`), {
      name: "Chambre double",
      pricePerNight: xof(25000),
      capacityAdults: 2,
      capacityChildren: 1,
      quantity: 3,
      active: true,
    });
    const hotel = await eventually(
      () => adminDb.doc(`hotels/${hotelId}`).get(),
      (s) => s.get("minPricePerNight.amount") === 25000,
    );
    expect(hotel.get("maxGuests")).toBe(3);
  });

  it("la publication respecte la limite du plan", async () => {
    expect(await hotelier.call("publishListing", { kind: "hotel", id: hotelId })).toEqual({ status: "published" });
    const second = await addDoc(collection(hotelier.db, "hotels"), {
      orgId: hotelOrg,
      name: "Annexe",
      city: "Ouagadougou",
      photos: ["https://exemple.bf/annexe.jpg"],
      status: "draft",
    });
    await setDoc(doc(hotelier.db, `hotels/${second.id}/roomTypes/single`), {
      name: "Simple",
      pricePerNight: xof(15000),
      capacityAdults: 1,
      quantity: 2,
      active: true,
    });
    await eventually(() => adminDb.doc(`hotels/${second.id}`).get(), (s) => !!s.get("minPricePerNight"));
    expect(await errorCode(hotelier.call("publishListing", { kind: "hotel", id: second.id }))).toBe(
      "functions/failed-precondition",
    );
  });
});

describe("demande de réservation", () => {
  it("le client demande une chambre ; l'hôtel est prévenu et a 48 h pour répondre", async () => {
    const result = await traveller.call("createBookingRequest", {
      hotelId,
      roomTypeId: "double",
      checkIn: dayString(10),
      checkOut: dayString(12),
      adults: 2,
      message: "Arrivée tardive vers 22 h.",
    });
    bookingId = result.requestId as string;
    expect(result.estimatedTotal).toEqual(xof(50000));
    const hours = (Date.parse(result.expiresAt as string) - Date.now()) / 3_600_000;
    expect(hours).toBeGreaterThan(47);
    expect(await notificationTitles(hotelier.uid)).toContain("Nouvelle demande de réservation");
    expect(
      await errorCode(
        traveller.call("createBookingRequest", {
          hotelId,
          roomTypeId: "double",
          checkIn: dayString(10),
          checkOut: dayString(11),
          adults: 5,
        }),
      ),
    ).toBe("functions/failed-precondition");
  });

  it("l'hôtel demande des précisions ; la réponse du client remet la demande en attente", async () => {
    expect(
      await errorCode(hotelier.call("updateBookingStatus", { requestId: bookingId, action: "request_info" })),
    ).toBe("functions/invalid-argument");
    await hotelier.call("updateBookingStatus", {
      requestId: bookingId,
      action: "request_info",
      note: "Combien de lits souhaitez-vous ?",
    });
    expect(await notificationTitles(traveller.uid)).toContain("L'hôtel vous demande des précisions");
    await addDoc(collection(traveller.db, `bookingRequests/${bookingId}/messages`), {
      fromUid: traveller.uid,
      fromRole: "client",
      text: "Un grand lit, merci.",
      createdAt: serverTimestamp(),
    });
    await eventually(
      () => adminDb.doc(`bookingRequests/${bookingId}`).get(),
      (s) => s.get("status") === "pending",
    );
  });

  it("acceptée puis payée en ligne (simulation) ; terminée, elle génère la commission", async () => {
    expect(
      await errorCode(traveller.call("updateBookingStatus", { requestId: bookingId, action: "accept" })),
    ).toBe("functions/failed-precondition");
    await hotelier.call("updateBookingStatus", { requestId: bookingId, action: "accept" });
    expect(await notificationTitles(traveller.uid)).toContain("Réservation acceptée");

    const { paymentId } = await traveller.call("startPayment", {
      purpose: { type: "booking", bookingRequestId: bookingId },
    });
    await traveller.call("confirmSimulatedPayment", { paymentId, outcome: "success" });
    const paid = await adminDb.doc(`bookingRequests/${bookingId}`).get();
    expect(paid.get("paymentStatus")).toBe("paid_simulated");

    expect(
      await errorCode(hotelier.call("updateBookingStatus", { requestId: bookingId, action: "complete" })),
    ).toBe("functions/failed-precondition");
    await adminDb.doc(`bookingRequests/${bookingId}`).update({
      checkIn: Timestamp.fromMillis(Date.now() - 2 * DAY),
      checkOut: Timestamp.fromMillis(Date.now() - DAY),
    });
    await hotelier.call("updateBookingStatus", { requestId: bookingId, action: "complete" });
    const commission = await adminDb.doc(`commissions/bookingRequest_${bookingId}`).get();
    expect(commission.get("amount")).toEqual(xof(5000));
    expect(commission.get("ruleSnapshot.rate")).toBe(10);
    const hotel = await adminDb.doc(`hotels/${hotelId}`).get();
    expect(hotel.get("stats")).toMatchObject({ requests: 1, accepted: 1 });
  });

  it("sans réponse dans le délai, la demande expire et le client est prévenu", async () => {
    const { requestId } = await traveller.call("createBookingRequest", {
      hotelId,
      roomTypeId: "double",
      checkIn: dayString(20),
      checkOut: dayString(21),
      adults: 1,
    });
    await adminDb.doc(`bookingRequests/${requestId}`).update({ expiresAt: Timestamp.fromMillis(Date.now() - 1000) });
    const { runBookingMaintenance } = await import("../../src/bookings/bookingMaintenance");
    expect((await runBookingMaintenance()).expired).toBeGreaterThanOrEqual(1);
    expect((await adminDb.doc(`bookingRequests/${requestId}`).get()).get("status")).toBe("expired");
    expect(await notificationTitles(traveller.uid)).toContain("Demande expirée");
  });
});

describe("immobilier : annonce de particulier et demande de visite", () => {
  let ownerOrg: string;

  it("l'annonce d'un particulier passe par la validation ZAKA, motif obligatoire en cas de refus", async () => {
    ownerOrg = await verifiedOrg(owner, {
      type: "individual_owner",
      name: "Awa K.",
      verification: { status: "verified" },
      publishingMode: "review",
    });
    const ref = await addDoc(collection(owner.db, "properties"), {
      orgId: ownerOrg,
      title: "Villa 4 pièces à Ouaga 2000",
      transactionType: "rent",
      propertyType: "villa",
      city: "Ouagadougou",
      price: xof(350000),
      rentPeriod: "month",
      photos: ["https://exemple.bf/villa.jpg"],
      status: "draft",
    });
    propertyId = ref.id;
    expect(await owner.call("publishListing", { kind: "property", id: propertyId })).toEqual({
      status: "pending_review",
    });
    expect(
      await errorCode(modo.call("reviewListing", { kind: "property", id: propertyId, decision: "reject" })),
    ).toBe("functions/invalid-argument");
    await modo.call("reviewListing", {
      kind: "property",
      id: propertyId,
      decision: "reject",
      note: "Ajoutez des photos de l'intérieur.",
    });
    expect(await notificationTitles(owner.uid)).toContain("Annonce refusée");

    await owner.call("publishListing", { kind: "property", id: propertyId });
    await modo.call("reviewListing", { kind: "property", id: propertyId, decision: "publish" });
    expect((await adminDb.doc(`properties/${propertyId}`).get()).get("status")).toBe("published");
  });

  it("un visiteur demande une visite ; le propriétaire la programme et le visiteur est prévenu", async () => {
    const { leadId } = await traveller.call("createLead", {
      targetType: "property",
      targetId: propertyId,
      type: "visit",
      message: "Je peux visiter samedi matin ?",
      preferredDates: "Samedi matin",
    });
    expect(await notificationTitles(owner.uid)).toContain("Demande de visite");
    expect(
      await errorCode(owner.call("createLead", { targetType: "property", targetId: propertyId, type: "info", message: "?" })),
    ).toBe("functions/failed-precondition");

    await updateDoc(doc(owner.db, `leads/${leadId}`), {
      status: "visit_scheduled",
      visitAt: ClientTimestamp.fromMillis(Date.now() + 3 * DAY),
    });
    await eventually(() => notificationTitles(traveller.uid), (t) => t.includes("Visite programmée"));
  });

  it("l'équipe suspend une annonce signalée, puis la rétablit dans son état précédent", async () => {
    expect(
      await errorCode(modo.call("moderateListing", { kind: "property", id: propertyId, decision: "suspend" })),
    ).toBe("functions/invalid-argument");
    await modo.call("moderateListing", { kind: "property", id: propertyId, decision: "suspend", note: "Signalement" });
    expect((await adminDb.doc(`properties/${propertyId}`).get()).get("status")).toBe("suspended");
    await modo.call("moderateListing", { kind: "property", id: propertyId, decision: "reinstate" });
    expect((await adminDb.doc(`properties/${propertyId}`).get()).get("status")).toBe("published");
  });
});

describe("litiges et suspension d'un compte", () => {
  it("l'équipe exporte le dossier d'une réservation, et l'export est tracé", async () => {
    expect(
      await errorCode(traveller.call("exportDisputeFile", { targetType: "bookingRequest", id: bookingId, reason: "Litige" })),
    ).toBe("functions/permission-denied");
    const { path } = await modo.call("exportDisputeFile", {
      targetType: "bookingRequest",
      id: bookingId,
      reason: "Réclamation du client",
    });
    const [content] = await getStorage()
      .bucket(`${projectId}.appspot.com`)
      .file(path as string)
      .download();
    const file = JSON.parse(content.toString("utf8"));
    expect(file.request.status).toBe("completed");
    expect(file.messages.length).toBeGreaterThanOrEqual(2);
    const exports = await adminDb.collection("disputeExports").where("targetRef", "==", `bookingRequests/${bookingId}`).get();
    expect(exports.size).toBe(1);
  });

  it("un compte suspendu voit ses annonces retirées, puis rétablies", async () => {
    await modo.call("reviewOrg", { orgId: hotelOrg, decision: "suspend", note: "Vérification en cours" });
    expect((await adminDb.doc(`hotels/${hotelId}`).get()).get("status")).toBe("suspended");
    await modo.call("reviewOrg", { orgId: hotelOrg, decision: "reinstate" });
    expect((await adminDb.doc(`hotels/${hotelId}`).get()).get("status")).toBe("published");
  });
});
