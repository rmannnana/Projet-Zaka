import { FieldValue, type WriteBatch, type Transaction } from "firebase-admin/firestore";

import { db } from "./config";

export interface AuditEntry {
  actorUid: string;
  action: string;
  /** Chemin du document concerné, ex. "organizations/abc". */
  targetRef: string;
  before?: Record<string, unknown> | null;
  after?: Record<string, unknown> | null;
}

/**
 * Ajoute une ligne au journal d'audit dans la même écriture atomique
 * que l'opération sensible (batch ou transaction).
 */
export function writeAudit(writer: WriteBatch | Transaction, entry: AuditEntry): void {
  const ref = db.collection("auditLogs").doc();
  const data = {
    ...entry,
    before: entry.before ?? null,
    after: entry.after ?? null,
    at: FieldValue.serverTimestamp(),
  };
  // WriteBatch.set et Transaction.set ont la même signature pour ce cas.
  (writer as WriteBatch).set(ref, data);
}
