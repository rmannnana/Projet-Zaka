import { describe, expect, it } from "vitest";

import { nextBookingStatus, needsNote } from "../../src/bookings/lifecycle";
import {
  CreateBookingInput,
  bestOffer,
  capacityProblem,
  estimateTotal,
  firstFullNight,
  nightsOf,
  parseDay,
  stayProblem,
} from "../../src/bookings/stay";
import {
  featuredProblem,
  kindFitsOrg,
  limitProblem,
  missingContent,
  publishTarget,
} from "../../src/listings/status";
import { money } from "../../src/shared/format";

const now = new Date("2026-12-01T10:00:00Z");
const day = parseDay;

describe("séjour demandé", () => {
  it("compte les nuits entre l'arrivée et le départ", () => {
    expect(nightsOf(day("2026-12-24"), day("2026-12-27")).map((d) => d.toISOString().slice(0, 10))).toEqual([
      "2026-12-24",
      "2026-12-25",
      "2026-12-26",
    ]);
  });

  it("refuse une arrivée passée, un départ avant l'arrivée, un séjour trop long ou trop lointain", () => {
    expect(stayProblem(day("2026-12-01"), day("2026-12-02"), now)).toBeNull();
    expect(stayProblem(day("2026-11-30"), day("2026-12-02"), now)).toMatch(/passée/);
    expect(stayProblem(day("2026-12-05"), day("2026-12-05"), now)).toMatch(/suivre/);
    expect(stayProblem(day("2026-12-05"), day("2027-01-10"), now)).toMatch(/30 nuits/);
    expect(stayProblem(day("2028-01-01"), day("2028-01-02"), now)).toMatch(/un an/);
  });

  it("valide les dates reçues de l'app", () => {
    const base = { hotelId: "h", roomTypeId: "r", checkOut: "2026-12-27", adults: 2 };
    expect(CreateBookingInput.safeParse({ ...base, checkIn: "2026-12-24" }).success).toBe(true);
    expect(CreateBookingInput.safeParse({ ...base, checkIn: "2026-02-30" }).success).toBe(false);
    expect(CreateBookingInput.parse({ ...base, checkIn: "2026-12-24" })).toMatchObject({ rooms: 1, children: 0 });
  });

  it("vérifie la capacité des chambres", () => {
    const room = { capacityAdults: 2, capacityChildren: 1, quantity: 3 };
    expect(capacityProblem({ adults: 2, children: 1, rooms: 1 }, room)).toBeNull();
    expect(capacityProblem({ adults: 3, children: 0, rooms: 1 }, room)).toMatch(/adultes/);
    expect(capacityProblem({ adults: 2, children: 2, rooms: 1 }, room)).toMatch(/personnes/);
    expect(capacityProblem({ adults: 4, children: 0, rooms: 4 }, room)).toMatch(/3 chambres/);
  });

  it("respecte les disponibilités déclarées (un jour non renseigné = tout est libre)", () => {
    const nights = nightsOf(day("2026-12-30"), day("2027-01-02"));
    const availability = { "2026-12": { "31": 1 }, "2027-01": { "01": 0 } };
    expect(firstFullNight(nights, availability, 5, 1)?.toISOString().slice(0, 10)).toBe("2027-01-01");
    expect(firstFullNight(nights, { "2026-12": { "31": 1 } }, 5, 1)).toBeNull();
    expect(firstFullNight(nights, { "2026-12": { "31": 1 } }, 5, 2)?.toISOString().slice(0, 10)).toBe("2026-12-31");
  });
});

describe("prix estimé", () => {
  const offers = [
    { id: "noel", title: "Noël", discountPercent: 15, roomTypeIds: [], validFrom: day("2026-12-20"), validTo: day("2026-12-27") },
    { id: "suite", title: "Suite", discountPercent: 25, roomTypeIds: ["suite"], validFrom: day("2026-12-01"), validTo: day("2027-01-01") },
  ];

  it("applique la meilleure offre valable à la date d'arrivée pour ce type de chambre", () => {
    expect(bestOffer(offers, "double", day("2026-12-24"))?.id).toBe("noel");
    expect(bestOffer(offers, "suite", day("2026-12-24"))?.id).toBe("suite");
    expect(bestOffer(offers, "double", day("2026-12-27"))).toBeNull();
  });

  it("prix par nuit × nuits × chambres, remise déduite, au franc près", () => {
    expect(estimateTotal(money(25000), 3, 2)).toEqual(money(150000));
    expect(estimateTotal(money(33333), 1, 1, 15)).toEqual(money(28333));
  });
});

describe("cycle de vie d'une demande de réservation", () => {
  it("l'hôtel accepte, refuse ou demande des précisions sur une demande en attente", () => {
    expect(nextBookingStatus("hotel", "accept", "pending")).toBe("accepted");
    expect(nextBookingStatus("hotel", "reject", "info_requested")).toBe("rejected");
    expect(nextBookingStatus("hotel", "request_info", "pending")).toBe("info_requested");
    expect(nextBookingStatus("hotel", "request_info", "info_requested")).toBeNull();
  });

  it("après acceptation : séjour terminé ou annulation", () => {
    expect(nextBookingStatus("hotel", "complete", "accepted")).toBe("completed");
    expect(nextBookingStatus("hotel", "cancel", "accepted")).toBe("cancelled");
    expect(nextBookingStatus("hotel", "complete", "pending")).toBeNull();
  });

  it("le client annule tant que le séjour n'est pas terminé, et ne peut rien d'autre", () => {
    expect(nextBookingStatus("client", "cancel", "pending")).toBe("cancelled");
    expect(nextBookingStatus("client", "cancel", "accepted")).toBe("cancelled");
    expect(nextBookingStatus("client", "cancel", "completed")).toBeNull();
    expect(nextBookingStatus("client", "accept", "pending")).toBeNull();
  });

  it("demander des précisions ou annuler côté hôtel exige un message", () => {
    expect(needsNote("hotel", "request_info")).toBe(true);
    expect(needsNote("hotel", "cancel")).toBe(true);
    expect(needsNote("client", "cancel")).toBe(false);
    expect(needsNote("hotel", "reject")).toBe(false);
  });
});

describe("publication des annonces", () => {
  it("chaque type d'annonce correspond à un type de compte", () => {
    expect(kindFitsOrg("hotel", "hotel")).toBe(true);
    expect(kindFitsOrg("hotel", "agency")).toBe(false);
    expect(kindFitsOrg("property", "individual_owner")).toBe(true);
    expect(kindFitsOrg("property", "hotel")).toBe(false);
    expect(kindFitsOrg("project", "developer")).toBe(true);
    expect(kindFitsOrg("project", "agency")).toBe(false);
  });

  it("un pro publie directement, un particulier passe par la validation ZAKA", () => {
    expect(publishTarget("property", "draft", "direct")).toBe("published");
    expect(publishTarget("property", "draft", "review")).toBe("pending_review");
    expect(publishTarget("property", "rejected", "review")).toBe("pending_review");
    expect(publishTarget("property", "rented", "direct")).toBe("published");
    expect(publishTarget("property", "published", "direct")).toBeNull();
    expect(publishTarget("property", "suspended", "direct")).toBeNull();
    expect(publishTarget("hotel", "inactive", "direct")).toBe("published");
  });

  it("une annonce publiée a un titre, une ville, un prix et une photo", () => {
    const property = { title: "Villa", city: "Ouagadougou", price: money(150000), photos: ["a.jpg"] };
    expect(missingContent("property", property)).toBeNull();
    expect(missingContent("property", { ...property, photos: [] })).toMatch(/photo/);
    expect(missingContent("property", { ...property, price: money(0) })).toMatch(/prix/);
    expect(missingContent("hotel", { name: "Splendid", city: "Bobo", photos: ["a"] })).toMatch(/chambre/);
    expect(missingContent("hotel", { name: "Splendid", city: "Bobo", photos: ["a"], minPricePerNight: money(1) })).toBeNull();
  });

  it("respecte le nombre d'annonces et de mises en avant du plan", () => {
    expect(limitProblem(2, 3)).toBeNull();
    expect(limitProblem(3, 3)).toMatch(/3 annonces publiées/);
    expect(limitProblem(0, 0)).toMatch(/abonnement/);
    expect(limitProblem(500, null)).toBeNull();
    expect(featuredProblem(0, 1)).toBeNull();
    expect(featuredProblem(1, 1)).toMatch(/1 annonce mise en avant/);
  });
});
