import { Timestamp } from "firebase-admin/firestore";
import { collection, getDocs, query, where } from "firebase/firestore";
import { afterAll, beforeAll, describe, expect, it } from "vitest";

import {
  adminDb,
  client,
  closeClients,
  errorCode,
  notificationTitles,
  type Client,
} from "./support";

// Parcours de la phase 2 (facturation simulée) sur les émulateurs.
// Lancer avec : npm run test:integration
const DAY = 24 * 60 * 60 * 1000;

let boss: Client;
let modo: Client;
let ali: Client;
let fatou: Client;
let orgId: string;
let otherOrgId: string;
const plans: Record<string, string> = {};

beforeAll(async () => {
  boss = await client("boss2", { claims: { role: "admin" } });
  modo = await client("modo2", { claims: { role: "moderator" } });
  ali = await client("hotelier");
  fatou = await client("fatou");

  // Hôtel vérifié (le parcours de vérification est couvert par phase1.test.ts).
  orgId = (await ali.call("createOrganization", {
    type: "hotel",
    name: "Hôtel Splendid",
    contact: { phone: "+22670000001", city: "Bobo-Dioulasso" },
  })).orgId as string;
  await adminDb.doc(`organizations/${orgId}`).update({ "verification.status": "verified" });
  await ali.call("addOrgMember", { orgId, email: fatou.email, role: "editor" });

  otherOrgId = (await fatou.call("createOrganization", {
    type: "agency",
    name: "Faso Immo",
    contact: { phone: "+22670000002", city: "Ouagadougou" },
  })).orgId as string;
  // Premiers appels : les fonctions démarrent à froid dans l'émulateur.
}, 120_000);

afterAll(closeClients);

const plan = (name: string, price: number, extra: object = {}) => ({
  name,
  price,
  period: "month",
  target: "hotel",
  features: { maxListings: 20, featuredListings: 2, advancedStats: true },
  active: true,
  ...extra,
});

describe("grille des plans (admin)", () => {
  it("seul un admin modifie les plans, et le plan Gratuit reste gratuit", async () => {
    expect(await errorCode(modo.call("upsertSubscriptionPlan", plan("Pirate", 1000)))).toBe(
      "functions/permission-denied",
    );
    const free = plan("Gratuit", 0, { planId: "free", target: "all" });
    expect(await boss.call("upsertSubscriptionPlan", free)).toEqual({ planId: "free" });
    expect(
      await errorCode(boss.call("upsertSubscriptionPlan", { ...free, price: 500 })),
    ).toBe("functions/invalid-argument");

    plans.hotel = (await boss.call("upsertSubscriptionPlan", plan("Hôtel Pro", 15000))).planId as string;
    plans.premium = (await boss.call(
      "upsertSubscriptionPlan",
      plan("Hôtel Premium", 150000, { period: "year" }),
    )).planId as string;
    plans.immo = (await boss.call(
      "upsertSubscriptionPlan",
      plan("Immo Plus", 10000, { target: "real_estate" }),
    )).planId as string;

    // Modification : le prix change, la date de création reste.
    const before = await adminDb.doc(`subscriptionPlans/${plans.hotel}`).get();
    await boss.call("upsertSubscriptionPlan", { ...plan("Hôtel Pro", 17500), planId: plans.hotel });
    const after = await adminDb.doc(`subscriptionPlans/${plans.hotel}`).get();
    expect(after.get("price")).toEqual({ amount: 17500, currency: "XOF" });
    expect(after.get("createdAt")).toEqual(before.get("createdAt"));

    const audit = await adminDb
      .collection("auditLogs")
      .where("targetRef", "==", `subscriptionPlans/${plans.hotel}`)
      .get();
    expect(audit.docs.map((d) => d.get("action")).sort()).toEqual([
      "subscriptionPlan.create",
      "subscriptionPlan.update",
    ]);
  });
});

describe("règles de commission", () => {
  it("l'admin définit un taux par défaut et un taux partenaire, le simulateur applique le bon", async () => {
    const rule = {
      scope: "hotel_booking",
      rateType: "percent",
      rate: 10,
      validFrom: Date.UTC(2026, 0, 1),
      active: true,
    };
    expect(await errorCode(modo.call("upsertCommissionRule", rule))).toBe("functions/permission-denied");
    await boss.call("upsertCommissionRule", rule);
    await boss.call("upsertCommissionRule", { ...rule, rate: 7.5, orgId });
    expect(
      await errorCode(boss.call("upsertCommissionRule", { ...rule, orgId: "inconnu" })),
    ).toBe("functions/not-found");

    // Le modérateur peut simuler, pas modifier.
    const forHotel = await modo.call("previewCommission", { scope: "hotel_booking", orgId, amount: 45000 });
    expect(forHotel).toMatchObject({ specific: true, commission: { amount: 3375, currency: "XOF" } });
    const forOthers = await boss.call("previewCommission", { scope: "hotel_booking", amount: 45000 });
    expect(forOthers).toMatchObject({ specific: false, commission: { amount: 4500 } });
    const none = await boss.call("previewCommission", { scope: "property_sale", amount: 45000 });
    expect(none).toEqual({ ruleId: null, commission: null });
  });
});

describe("abonnement payé par paiement simulé", () => {
  let subscriptionId: string;

  it("seul un propriétaire d'un compte vérifié souscrit, à un plan qui le concerne", async () => {
    const start = (c: Client, org: string, planId: string) =>
      errorCode(c.call("startPayment", { orgId: org, purpose: { type: "subscription", planId } }));
    expect(await start(fatou, orgId, plans.hotel)).toBe("functions/permission-denied");
    expect(await start(ali, orgId, plans.immo)).toBe("functions/failed-precondition");
    expect(await start(ali, orgId, "free")).toBe("functions/failed-precondition");
    expect(await start(fatou, otherOrgId, plans.immo)).toBe("functions/failed-precondition");
  });

  it("un échec simulé n'active rien et le paiement ne peut plus être rejoué", async () => {
    const { paymentId, checkout, amount } = await ali.call("startPayment", {
      orgId,
      purpose: { type: "subscription", planId: plans.hotel },
    });
    expect(checkout).toEqual({ type: "simulation" });
    expect(amount).toEqual({ amount: 17500, currency: "XOF" });

    expect(await errorCode(fatou.call("confirmSimulatedPayment", { paymentId, outcome: "success" }))).toBe(
      "functions/permission-denied",
    );
    expect(await ali.call("confirmSimulatedPayment", { paymentId, outcome: "failure" })).toEqual({
      status: "failed",
    });
    expect(await errorCode(ali.call("confirmSimulatedPayment", { paymentId, outcome: "success" }))).toBe(
      "functions/failed-precondition",
    );
    expect((await adminDb.doc(`organizations/${orgId}`).get()).get("subscriptionId")).toBeUndefined();
  });

  it("un paiement réussi active l'abonnement pour un mois et prévient le propriétaire", async () => {
    const { paymentId } = await ali.call("startPayment", {
      orgId,
      purpose: { type: "subscription", planId: plans.hotel },
    });
    const result = await ali.call("confirmSimulatedPayment", { paymentId, outcome: "success" });
    expect(result.status).toBe("succeeded");
    subscriptionId = result.subscriptionId as string;

    const org = await adminDb.doc(`organizations/${orgId}`).get();
    expect(org.get("subscriptionId")).toBe(subscriptionId);
    const sub = await adminDb.doc(`subscriptions/${subscriptionId}`).get();
    expect(sub.get("status")).toBe("active");
    expect(sub.get("planSnapshot.price")).toEqual({ amount: 17500, currency: "XOF" });
    const days = (sub.get("currentPeriodEnd").toMillis() - Date.now()) / DAY;
    expect(days).toBeGreaterThan(27);
    expect(days).toBeLessThan(32);
    const payment = await adminDb.doc(`payments/${paymentId}`).get();
    expect(payment.get("purpose.subscriptionId")).toBe(subscriptionId);

    expect(await notificationTitles(ali.uid)).toContain("Abonnement activé");
    // Un éditeur du compte voit l'historique des paiements.
    const history = await getDocs(
      query(collection(fatou.db, "payments"), where("payerOrgId", "==", orgId)),
    );
    expect(history.size).toBe(2);
  });

  it("renouveler le même plan prolonge la période en cours", async () => {
    const before = (await adminDb.doc(`subscriptions/${subscriptionId}`).get()).get("currentPeriodEnd");
    const { paymentId } = await ali.call("startPayment", {
      orgId,
      purpose: { type: "subscription", planId: plans.hotel },
    });
    const result = await ali.call("confirmSimulatedPayment", { paymentId, outcome: "success" });
    expect(result.subscriptionId).toBe(subscriptionId);
    const after = (await adminDb.doc(`subscriptions/${subscriptionId}`).get()).get("currentPeriodEnd");
    const days = (after.toMillis() - before.toMillis()) / DAY;
    expect(days).toBeGreaterThan(27);
    expect(days).toBeLessThan(32);
  });

  it("changer de plan remplace l'abonnement en cours", async () => {
    const { paymentId } = await ali.call("startPayment", {
      orgId,
      purpose: { type: "subscription", planId: plans.premium },
    });
    const result = await ali.call("confirmSimulatedPayment", { paymentId, outcome: "success" });
    expect(result.subscriptionId).not.toBe(subscriptionId);
    const old = await adminDb.doc(`subscriptions/${subscriptionId}`).get();
    expect(old.get("status")).toBe("cancelled");
    expect(old.get("replacedBy")).toBe(result.subscriptionId);
    subscriptionId = result.subscriptionId as string;
  });

  it("la tâche du jour prévient avant la fin, puis repasse le compte au plan Gratuit", async () => {
    const { runSubscriptionMaintenance } = await import("../../src/billing/maintenance");
    const subRef = adminDb.doc(`subscriptions/${subscriptionId}`);

    await subRef.update({ currentPeriodEnd: Timestamp.fromMillis(Date.now() + 3 * DAY) });
    const first = await runSubscriptionMaintenance();
    expect(first.reminded).toBeGreaterThanOrEqual(1);
    expect((await subRef.get()).get("renewalReminderSentAt")).not.toBeNull();
    expect(await notificationTitles(ali.uid)).toContain("Abonnement bientôt terminé");

    // Pas de second rappel pour la même période.
    expect((await runSubscriptionMaintenance()).reminded).toBe(0);

    await subRef.update({ currentPeriodEnd: Timestamp.fromMillis(Date.now() - 60_000) });
    expect((await runSubscriptionMaintenance()).expired).toBeGreaterThanOrEqual(1);
    expect((await subRef.get()).get("status")).toBe("expired");
    expect((await adminDb.doc(`organizations/${orgId}`).get()).get("subscriptionId")).toBeNull();
    expect(await notificationTitles(ali.uid)).toContain("Abonnement terminé");
  });
});

describe("registre des commissions", () => {
  it("l'admin facture puis encaisse ; offrir exige un motif ; payée est définitif", async () => {
    const ids: string[] = [];
    for (const amount of [4500, 3000]) {
      const ref = await adminDb.collection("commissions").add({
        orgId,
        orgName: "Hôtel Splendid",
        source: { type: "bookingRequest", id: `test-${amount}` },
        baseAmount: { amount: amount * 10, currency: "XOF" },
        amount: { amount, currency: "XOF" },
        status: "due",
        createdAt: Timestamp.now(),
      });
      ids.push(ref.id);
    }
    const update = (c: Client, status: string, note?: string, list = ids) =>
      c.call("updateCommissionStatus", { commissionIds: list, status, ...(note ? { note } : {}) });

    expect(await errorCode(update(modo, "paid"))).toBe("functions/permission-denied");
    expect(await errorCode(update(boss, "waived"))).toBe("functions/invalid-argument");
    expect(await update(boss, "invoiced")).toEqual({ updated: 2 });
    await update(boss, "paid", undefined, [ids[0]]);
    await update(boss, "waived", "Geste commercial", [ids[1]]);
    expect(await errorCode(update(boss, "due", undefined, [ids[0]]))).toBe("functions/failed-precondition");

    const paid = await adminDb.doc(`commissions/${ids[0]}`).get();
    expect(paid.get("status")).toBe("paid");
    const waived = await adminDb.doc(`commissions/${ids[1]}`).get();
    expect(waived.get("statusNote")).toBe("Geste commercial");

    // L'hôtel voit ses commissions.
    const mine = await getDocs(query(collection(ali.db, "commissions"), where("orgId", "==", orgId)));
    expect(mine.size).toBe(2);
  });
});
