import { db } from "../shared/config";
import { FREE_PLAN_ID, isRunning } from "./plans";

export interface PlanLimits {
  maxListings: number | null;
  featuredListings: number;
}

/**
 * Avantages en vigueur d'un compte : ceux de l'abonnement payé tant qu'il court,
 * sinon ceux du plan Gratuit (illimité si le plan Gratuit n'existe pas encore).
 */
export async function effectiveLimits(org: FirebaseFirestore.DocumentData): Promise<PlanLimits> {
  const subscriptionId = org.subscriptionId as string | undefined;
  if (subscriptionId) {
    const sub = await db.collection("subscriptions").doc(subscriptionId).get();
    const running =
      sub.exists &&
      isRunning(
        {
          planId: sub.get("planId"),
          status: sub.get("status"),
          currentPeriodEnd: sub.get("currentPeriodEnd").toDate(),
        },
        new Date(),
      );
    if (running) return toLimits(sub.get("planSnapshot.features"));
  }
  const free = await db.collection("subscriptionPlans").doc(FREE_PLAN_ID).get();
  return free.exists ? toLimits(free.get("features")) : { maxListings: null, featuredListings: 0 };
}

function toLimits(features: Record<string, unknown> | undefined): PlanLimits {
  const max = features?.maxListings;
  const featured = features?.featuredListings;
  return {
    maxListings: typeof max === "number" ? max : null,
    featuredListings: typeof featured === "number" ? featured : 0,
  };
}
