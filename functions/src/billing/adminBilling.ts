import { FieldValue, Timestamp } from "firebase-admin/firestore";
import { HttpsError, onCall } from "firebase-functions/v2/https";

import { writeAudit } from "../shared/audit";
import { db } from "../shared/config";
import { money } from "../shared/format";
import { parseInput, requireAdmin, requireStaff } from "../shared/guards";
import {
  CommissionRuleInput,
  PreviewCommissionInput,
  UpdateCommissionStatusInput,
  canMoveCommission,
  computeCommission,
  ruleFromData,
  ruleProblem,
  selectRule,
  type CommissionScope,
} from "./commissions";
import { SubscriptionPlanInput, planProblem } from "./plans";

const iso = (ms: number | null | undefined) => (ms ? new Date(ms).toISOString() : null);

/** Crée ou modifie un plan d'abonnement (admin). Chaque changement est journalisé. */
export const upsertSubscriptionPlan = onCall(async (request) => {
  const adminUid = requireAdmin(request);
  const input = parseInput(SubscriptionPlanInput, request.data);
  const problem = planProblem(input);
  if (problem) throw new HttpsError("invalid-argument", problem);

  const plans = db.collection("subscriptionPlans");
  const ref = input.planId ? plans.doc(input.planId) : plans.doc();
  const { planId: _ignored, ...fields } = input;

  await db.runTransaction(async (tx) => {
    const before = await tx.get(ref);
    tx.set(
      ref,
      {
        ...fields,
        price: money(input.price),
        updatedBy: adminUid,
        updatedAt: FieldValue.serverTimestamp(),
        ...(before.exists ? {} : { createdAt: FieldValue.serverTimestamp() }),
      },
      { merge: true },
    );
    const old = before.data();
    writeAudit(tx, {
      actorUid: adminUid,
      action: before.exists ? "subscriptionPlan.update" : "subscriptionPlan.create",
      targetRef: ref.path,
      before: old
        ? {
            name: old.name,
            price: old.price?.amount ?? null,
            period: old.period,
            target: old.target,
            features: old.features,
            active: old.active,
          }
        : null,
      after: { ...fields, price: input.price },
    });
  });
  return { planId: ref.id };
});

/** Crée ou modifie une règle de commission (admin). Chaque changement est journalisé. */
export const upsertCommissionRule = onCall(async (request) => {
  const adminUid = requireAdmin(request);
  const input = parseInput(CommissionRuleInput, request.data);
  const problem = ruleProblem(input);
  if (problem) throw new HttpsError("invalid-argument", problem);

  let orgName: string | null = null;
  if (input.orgId) {
    const org = await db.collection("organizations").doc(input.orgId).get();
    if (!org.exists) throw new HttpsError("not-found", "Partenaire introuvable.");
    orgName = org.get("name") ?? null;
  }

  const rules = db.collection("commissionRules");
  const ref = input.ruleId ? rules.doc(input.ruleId) : rules.doc();
  const percent = input.rateType === "percent";
  const data = {
    scope: input.scope,
    rateType: input.rateType,
    rate: percent ? input.rate : null,
    fixedAmount: percent ? null : money(input.fixedAmount ?? 0),
    orgId: input.orgId ?? null,
    orgName,
    validFrom: Timestamp.fromMillis(input.validFrom),
    validTo: input.validTo ? Timestamp.fromMillis(input.validTo) : null,
    active: input.active,
    updatedBy: adminUid,
    updatedAt: FieldValue.serverTimestamp(),
  };

  await db.runTransaction(async (tx) => {
    const before = await tx.get(ref);
    if (input.ruleId && !before.exists) throw new HttpsError("not-found", "Règle introuvable.");
    tx.set(ref, before.exists ? data : { ...data, createdAt: FieldValue.serverTimestamp() });
    const old = before.data();
    writeAudit(tx, {
      actorUid: adminUid,
      action: before.exists ? "commissionRule.update" : "commissionRule.create",
      targetRef: ref.path,
      before: old
        ? {
            scope: old.scope,
            rateType: old.rateType,
            rate: old.rate ?? null,
            fixedAmount: old.fixedAmount?.amount ?? null,
            orgId: old.orgId ?? null,
            validFrom: old.validFrom?.toDate().toISOString() ?? null,
            validTo: old.validTo?.toDate().toISOString() ?? null,
            active: old.active,
          }
        : null,
      after: {
        scope: data.scope,
        rateType: data.rateType,
        rate: data.rate ?? null,
        fixedAmount: data.fixedAmount?.amount ?? null,
        orgId: data.orgId,
        validFrom: iso(input.validFrom),
        validTo: iso(input.validTo),
        active: data.active,
      },
    });
  });
  return { ruleId: ref.id };
});

/** Règles actives d'un type d'opération. */
export async function loadRules(scope: CommissionScope) {
  const snap = await db
    .collection("commissionRules")
    .where("scope", "==", scope)
    .where("active", "==", true)
    .get();
  return snap.docs.map((d) => ruleFromData(d.id, d.data()));
}

/**
 * Simulateur du back-office : quelle règle s'appliquerait, et pour quel montant.
 * Utilise exactement le calcul qui servira aux vraies commissions.
 */
export const previewCommission = onCall(async (request) => {
  requireStaff(request);
  const { scope, orgId, amount, at } = parseInput(PreviewCommissionInput, request.data);
  const rule = selectRule(await loadRules(scope), {
    scope,
    orgId: orgId ?? null,
    at: at ? new Date(at) : new Date(),
  });
  if (!rule) return { ruleId: null, commission: null };
  return {
    ruleId: rule.id,
    specific: rule.orgId !== null,
    rateType: rule.rateType,
    rate: rule.rate,
    fixedAmount: rule.fixedAmount,
    commission: computeCommission(rule, money(amount)),
  };
});

const statusLabels: Record<string, string> = {
  due: "due",
  invoiced: "facturée",
  paid: "payée",
  waived: "offerte",
};

/**
 * Registre des commissions : facturer, encaisser ou offrir (admin).
 * « Offerte » exige un motif. Chaque changement est journalisé.
 */
export const updateCommissionStatus = onCall(async (request) => {
  const adminUid = requireAdmin(request);
  const { commissionIds, status, note } = parseInput(UpdateCommissionStatusInput, request.data);
  if (status === "waived" && !note) {
    throw new HttpsError("invalid-argument", "Indiquez pourquoi la commission est offerte.");
  }
  const ids = [...new Set(commissionIds)];

  await db.runTransaction(async (tx) => {
    const refs = ids.map((id) => db.collection("commissions").doc(id));
    const snaps = await tx.getAll(...refs);
    for (const snap of snaps) {
      if (!snap.exists) throw new HttpsError("not-found", `Commission introuvable : ${snap.id}.`);
      const from = snap.get("status");
      if (!canMoveCommission(from, status)) {
        throw new HttpsError(
          "failed-precondition",
          `Une commission ${statusLabels[from] ?? from} ne peut pas passer en « ${statusLabels[status]} ».`,
        );
      }
    }
    for (const snap of snaps) {
      tx.update(snap.ref, {
        status,
        statusNote: note ?? null,
        statusChangedBy: adminUid,
        statusChangedAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
      });
      writeAudit(tx, {
        actorUid: adminUid,
        action: `commission.${status}`,
        targetRef: snap.ref.path,
        before: { status: snap.get("status") },
        after: { status, note: note ?? null },
      });
    }
  });
  return { updated: ids.length };
});
