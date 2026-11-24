import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../../organizations/domain/organization.dart';
import '../data/billing_repository.dart';
import '../domain/billing.dart';
import 'billing_labels.dart';

/// Abonnement d'un espace pro : plan en vigueur, plans proposés et historique des paiements.
class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final org = ref.watch(organizationProvider(orgId)).value;
    final subscription = ref.watch(orgSubscriptionProvider(orgId)).value;
    final freePlan = ref.watch(freePlanProvider).value;
    final plans = ref.watch(activePlansProvider);
    final uid = ref.watch(authStateProvider).value?.uid;
    final isOwner = ref
            .watch(orgMembersProvider(orgId))
            .value
            ?.any((m) => m.id == uid && m.role == OrgRole.owner) ??
        false;

    if (org == null) {
      return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));
    }
    final now = DateTime.now();
    final running = subscription != null && subscription.isRunningAt(now) ? subscription : null;
    final current = effectivePlan(running, freePlan, now);
    final canBuy = org.isVerified && isOwner;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.billingSubscription)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(l10n.billingCurrentPlan, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              if (current != null)
                _PlanCard(
                  plan: current,
                  highlighted: true,
                  footer: running == null
                      ? l10n.billingFreePlanHelp
                      : l10n.billingActiveUntil(billingDate.format(running.currentPeriodEnd!)),
                ),
              if (!org.isVerified)
                _Info(l10n.billingNeedsVerification)
              else if (!isOwner)
                _Info(l10n.billingOwnerOnly),
              const SizedBox(height: 24),
              Text(l10n.billingAvailablePlans, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              plans.when(
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text(l10n.genericError),
                data: (plans) {
                  final offered = plans.where((p) => !p.isFree && p.target.fits(org.type)).toList();
                  if (offered.isEmpty) return Text(l10n.billingNoPlans);
                  return Column(
                    children: [
                      for (final plan in offered)
                        _PlanCard(
                          plan: plan,
                          action: !canBuy
                              ? null
                              : (
                                  running?.planId == plan.id ? l10n.billingRenew : l10n.billingChoose,
                                  () => _choose(context, ref, plan, running),
                                ),
                        ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Text(l10n.billingPaymentHistory, style: Theme.of(context).textTheme.titleMedium),
              _PaymentHistory(orgId: orgId),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _choose(
    BuildContext context,
    WidgetRef ref,
    SubscriptionPlan plan,
    Subscription? running,
  ) async {
    final l10n = AppLocalizations.of(context);
    final price = plan.price.format();
    final renew = running?.planId == plan.id;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.billingConfirmTitle(plan.name)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(plan.period == PlanPeriod.year ? l10n.billingConfirmYear(price) : l10n.billingConfirmMonth(price)),
            if (running != null) ...[
              const SizedBox(height: 12),
              Text(
                renew
                    ? l10n.billingRenewInfo(billingDate.format(running.currentPeriodEnd!))
                    : l10n.billingReplaceWarning(running.planSnapshot.name),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.billingContinueToPayment),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    try {
      final checkout = await ref.read(billingRepositoryProvider).startSubscriptionPayment(orgId, plan.id);
      if (context.mounted) context.push('/pro/$orgId/paiement/${checkout.paymentId}');
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(functionErrorMessage(e))));
      }
    }
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({required this.plan, this.highlighted = false, this.footer, this.action});

  final SubscriptionPlan plan;
  final bool highlighted;
  final String? footer;

  /// Libellé et effet du bouton ; null : pas de bouton.
  final (String, VoidCallback)? action;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final content = Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text(plan.name, style: theme.textTheme.titleLarge)),
              Text(plan.priceLabel(l10n), style: theme.textTheme.titleMedium),
            ],
          ),
          if (plan.description.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(plan.description, style: theme.textTheme.bodyMedium),
          ],
          const SizedBox(height: 8),
          for (final feature in plan.featureLabels(l10n))
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Icon(Icons.check, size: 18, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(feature)),
                ],
              ),
            ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Text(footer!, style: theme.textTheme.bodySmall),
          ],
          if (action != null) ...[
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(onPressed: action!.$2, child: Text(action!.$1)),
            ),
          ],
        ],
      ),
    );
    return highlighted
        ? Card(color: theme.colorScheme.primaryContainer.withValues(alpha: 0.4), child: content)
        : Card.outlined(child: content);
  }
}

class _Info extends StatelessWidget {
  const _Info(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Row(
      children: [
        const Icon(Icons.info_outline, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    ),
  );
}

final _paymentDate = DateFormat('d MMM yyyy, HH:mm', 'fr');

class _PaymentHistory extends ConsumerWidget {
  const _PaymentHistory({required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ref.watch(orgPaymentsProvider(orgId)).when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text(l10n.genericError),
      data: (payments) => payments.isEmpty
          ? Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text(l10n.billingNoPayments))
          : Column(
              children: [
                for (final p in payments)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(p.description),
                    subtitle: Text(p.createdAt == null ? '' : _paymentDate.format(p.createdAt!)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(p.amount.format()),
                        Text(
                          p.status.label(l10n),
                          style: TextStyle(color: p.status.color(scheme), fontSize: 12),
                        ),
                      ],
                    ),
                    onTap: p.status == PaymentStatus.pending && p.isSimulated
                        ? () => context.push('/pro/$orgId/paiement/${p.id}')
                        : null,
                  ),
              ],
            ),
    );
  }
}
