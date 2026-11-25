import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../organizations/data/organization_repository.dart';
import '../data/billing_repository.dart';
import '../domain/billing.dart';
import 'billing_labels.dart';

/// Écran de paiement simulé : aucun argent ne circule, l'utilisateur choisit l'issue.
/// Avec CinetPay (phase 6), il sera remplacé par la page du prestataire.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key, this.orgId, required this.paymentId, this.backLocation});

  /// Compte pro qui paie un abonnement (null pour une réservation payée par un client).
  final String? orgId;
  final String paymentId;

  /// Page où revenir après le paiement.
  final String? backLocation;

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  SimulatedOutcome? _sending;

  Future<void> _confirm(SimulatedOutcome outcome) async {
    setState(() => _sending = outcome);
    try {
      await ref.read(billingRepositoryProvider).confirmSimulatedPayment(widget.paymentId, outcome);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(functionErrorMessage(e))));
      }
    } finally {
      if (mounted) setState(() => _sending = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final payment = ref.watch(paymentProvider(widget.paymentId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.checkoutTitle)),
      body: Readable(
        maxWidth: 560,
        child: payment.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.genericError)),
          data: (payment) {
            if (payment == null) return Center(child: Text(l10n.checkoutNotFound));
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (payment.isSimulated) const _TestBanner(),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const ToneIcon(Icons.receipt_long_outlined, size: 46),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(payment.description, style: const TextStyle(fontWeight: FontWeight.w800)),
                              if (payment.orgName != null)
                                Text(
                                  payment.orgName!,
                                  style: TextStyle(color: ZakaPalette.of(context).muted, fontSize: 13),
                                ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          payment.amount.format(),
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (payment.status == PaymentStatus.pending)
                  ..._pendingActions(l10n)
                else
                  _Result(
                    orgId: widget.orgId,
                    payment: payment,
                    backLocation: widget.backLocation ?? '/pro/${widget.orgId}/abonnement',
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  List<Widget> _pendingActions(AppLocalizations l10n) {
    final busy = _sending != null;
    Widget progressOr(SimulatedOutcome outcome, String label) => _sending == outcome
        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
        : Text(label);
    return [
      PageIntro(text: l10n.checkoutTestExplain),
      FilledButton.icon(
        onPressed: busy ? null : () => _confirm(SimulatedOutcome.success),
        icon: const Icon(Icons.check_circle_outline),
        label: progressOr(SimulatedOutcome.success, l10n.checkoutSimulateSuccess),
      ),
      const SizedBox(height: 8),
      OutlinedButton.icon(
        onPressed: busy ? null : () => _confirm(SimulatedOutcome.failure),
        icon: const Icon(Icons.error_outline),
        label: progressOr(SimulatedOutcome.failure, l10n.checkoutSimulateFailure),
      ),
      const SizedBox(height: 8),
      TextButton(
        onPressed: busy ? null : () => _confirm(SimulatedOutcome.cancelled),
        child: progressOr(SimulatedOutcome.cancelled, l10n.checkoutCancel),
      ),
    ];
  }
}

/// Bandeau imposé par le plan de conception tant que les paiements sont simulés.
class _TestBanner extends StatelessWidget {
  const _TestBanner();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return NoticeCard(text: l10n.checkoutTestBanner, icon: Icons.science_outlined, tone: Tone.peach);
  }
}

class _Result extends ConsumerWidget {
  const _Result({required this.orgId, required this.payment, required this.backLocation});

  final String? orgId;
  final Payment payment;
  final String backLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final end = orgId == null ? null : ref.watch(orgSubscriptionProvider(orgId!)).value?.currentPeriodEnd;
    final booking = payment.purpose.type == 'booking';

    final (IconData icon, String title, String? body) = switch (payment.status) {
      PaymentStatus.succeeded => (
        Icons.check_circle,
        l10n.checkoutSucceeded,
        booking
            ? l10n.checkoutBookingPaid
            : (end == null ? null : l10n.checkoutSucceededUntil(billingDate.format(end))),
      ),
      PaymentStatus.failed => (Icons.error, l10n.checkoutFailed, l10n.checkoutFailedBody),
      _ => (Icons.cancel_outlined, l10n.checkoutCancelled, null),
    };

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 92,
          height: 92,
          decoration: BoxDecoration(
            color: payment.status.color(scheme).withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 48, color: payment.status.color(scheme)),
        ),
        const SizedBox(height: 16),
        Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
        if (body != null) ...[const SizedBox(height: 8), Text(body, textAlign: TextAlign.center)],
        const SizedBox(height: 24),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(double.infinity, 52)),
          onPressed: () => context.go(backLocation),
          child: Text(booking ? l10n.checkoutBackToBooking : l10n.checkoutBackToSubscription),
        ),
      ],
    );
  }
}
