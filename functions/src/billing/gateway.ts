import type { Money } from "../shared/format";

export type PaymentProvider = "simulation" | "cinetpay";

/** Ce que l'app doit afficher pour faire payer le client. */
export interface Checkout {
  /** "simulation" : écran de paiement factice de l'app ; "redirect" : page du prestataire (phase 6). */
  type: "simulation" | "redirect";
  url?: string;
}

/**
 * Prestataire de paiement. L'app ne connaît que cette interface : passer de la
 * simulation à CinetPay (phase 6) ne change ni l'app ni le reste des fonctions.
 */
export interface PaymentGateway {
  readonly provider: PaymentProvider;
  /** Prépare le paiement chez le prestataire. */
  start(payment: { id: string; amount: Money; description: string }): Promise<Checkout>;
}

/** Aucun argent ne circule : l'utilisateur choisit l'issue dans l'écran de simulation. */
export class SimulatedGateway implements PaymentGateway {
  readonly provider = "simulation" as const;

  async start(): Promise<Checkout> {
    return { type: "simulation" };
  }
}

/**
 * Prestataire actif. Au MVP, toujours la simulation ; en phase 6, le choix
 * sera lu dans Remote Config (`payments_provider`).
 */
export function activeGateway(): PaymentGateway {
  return new SimulatedGateway();
}
