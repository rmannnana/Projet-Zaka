import { FieldValue, type Transaction } from "firebase-admin/firestore";
import { logger } from "firebase-functions/v2";

import { db } from "../shared/config";
import type { Money } from "../shared/format";
import {
  computeCommission,
  ruleFromData,
  ruleSnapshot,
  selectRule,
  type CommissionRule,
  type CommissionScope,
} from "./commissions";

/** Règles actives d'un type d'opération. */
export async function loadRules(scope: CommissionScope): Promise<CommissionRule[]> {
  const snap = await db
    .collection("commissionRules")
    .where("scope", "==", scope)
    .where("active", "==", true)
    .get();
  return snap.docs.map((d) => ruleFromData(d.id, d.data()));
}

/**
 * Inscrit la commission due au registre, avec une copie de la règle appliquée.
 * Une seule commission par opération (identifiant déterministe). Sans règle
 * en vigueur, aucune commission n'est due.
 */
export function writeCommission(
  tx: Transaction,
  rules: CommissionRule[],
  c: {
    scope: CommissionScope;
    orgId: string;
    orgName: string | null;
    source: { type: string; id: string };
    baseAmount: Money;
    at: Date;
  },
): Money | null {
  const rule = selectRule(rules, { scope: c.scope, orgId: c.orgId, at: c.at });
  if (!rule) {
    logger.warn("Aucune règle de commission en vigueur", { scope: c.scope, orgId: c.orgId });
    return null;
  }
  const amount = computeCommission(rule, c.baseAmount);
  tx.set(db.collection("commissions").doc(`${c.source.type}_${c.source.id}`), {
    orgId: c.orgId,
    orgName: c.orgName,
    source: c.source,
    baseAmount: c.baseAmount,
    amount,
    ruleSnapshot: ruleSnapshot(rule),
    status: "due",
    statusNote: null,
    createdAt: FieldValue.serverTimestamp(),
    updatedAt: FieldValue.serverTimestamp(),
  });
  return amount;
}
