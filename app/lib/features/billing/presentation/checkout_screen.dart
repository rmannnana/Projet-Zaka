import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../organizations/data/organization_repository.dart';
import '../data/billing_repository.dart';
import '../domain/billing.dart';
import 'billing_labels.dart';

/// Écran de paiement simulé : aucun argent ne circule, l'utilisateur choisit l'issue.
/// Avec CinetPay (phase 6), il sera remplacé par la page du prestataire.
class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key, required this.orgId, required this.paymentId});

  final String orgId;
  final String paymentId;

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
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
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
                  Card.outlined(
                    child: ListTile(
                      title: Text(payment.description),
                      subtitle: payment.orgName == null ? null : Text(payment.orgName!),
                      trailing: Text(payment.amount.format(), style: Theme.of(context).textTheme.titleLarge),
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (payment.status == PaymentStatus.pending)
                    ..._pendingActions(l10n)
                  else
                    _Result(orgId: widget.orgId, payment: payment),
                ],
              );
            },
          ),
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
      Text(l10n.checkoutTestExplain),
      const SizedBox(height: 16),
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        border: Border.all(color: Colors.amber.shade800),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.science_outlined, color: Colors.amber.shade900),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.checkoutTestBanner,
              style: TextStyle(color: Colors.amber.shade900, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _Result extends ConsumerWidget {
  const _Result({required this.orgId, required this.payment});

  final String orgId;
  final Payment payment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final end = ref.watch(orgSubscriptionProvider(orgId)).value?.currentPeriodEnd;

    final (IconData icon, String title, String? body) = switch (payment.status) {
      PaymentStatus.succeeded => (
        Icons.check_circle,
        l10n.checkoutSucceeded,
        end == null ? null : l10n.checkoutSucceededUntil(billingDate.format(end)),
      ),
      PaymentStatus.failed => (Icons.error, l10n.checkoutFailed, l10n.checkoutFailedBody),
      _ => (Icons.cancel_outlined, l10n.checkoutCancelled, null),
    };

    return Column(
      children: [
        Icon(icon, size: 64, color: payment.status.color(scheme)),
        const SizedBox(height: 12),
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        if (body != null) ...[
          const SizedBox(height: 8),
          Text(body, textAlign: TextAlign.center),
        ],
        const SizedBox(height: 24),
        FilledButton(
          onPressed: () => context.go('/pro/$orgId/abonnement'),
          child: Text(l10n.checkoutBackToSubscription),
        ),
      ],
    );
  }
}
