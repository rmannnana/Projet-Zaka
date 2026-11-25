import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
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
    final isOwner =
        ref.watch(orgMembersProvider(orgId)).value?.any((m) => m.id == uid && m.role == OrgRole.owner) ?? false;

    if (org == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final now = DateTime.now();
    final running = subscription != null && subscription.isRunningAt(now) ? subscription : null;
    final current = effectivePlan(running, freePlan, now);
    final canBuy = org.isVerified && isOwner;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.billingSubscription)),
      body: Readable(
        maxWidth: 720,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            if (current != null)
              _PlanCard(
                plan: current,
                highlighted: true,
                footer: running == null
                    ? l10n.billingFreePlanHelp
                    : l10n.billingActiveUntil(billingDate.format(running.currentPeriodEnd!)),
              ),
            if (!org.isVerified) _Info(l10n.billingNeedsVerification) else if (!isOwner) _Info(l10n.billingOwnerOnly),
            _Heading(l10n.billingAvailablePlans),
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
            _Heading(l10n.billingPaymentHistory),
            _PaymentHistory(orgId: orgId),
          ],
        ),
      ),
    );
  }

  Future<void> _choose(BuildContext context, WidgetRef ref, SubscriptionPlan plan, Subscription? running) async {
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
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.billingContinueToPayment)),
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

  /// Plan en cours : bandeau vert.
  final bool highlighted;
  final String? footer;

  /// Libellé et effet du bouton ; null : pas de bouton.
  final (String, VoidCallback)? action;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);

    if (highlighted) {
      return BrandCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            OnBrandPill(l10n.planInUse, icon: Icons.workspace_premium),
            const SizedBox(height: 12),
            Text(plan.name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 22)),
            const SizedBox(height: 2),
            Text(
              plan.priceLabel(l10n),
              style: TextStyle(color: palette.gold, fontWeight: FontWeight.w800, fontSize: 15),
            ),
            const SizedBox(height: 12),
            for (final feature in plan.featureLabels(l10n))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: palette.gold),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(feature, style: const TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            if (footer != null) ...[
              const SizedBox(height: 10),
              Text(footer!, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12.5)),
            ],
          ],
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const ToneIcon(Icons.workspace_premium_outlined, tone: Tone.peach, size: 42),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(plan.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800)),
                      Text(
                        plan.priceLabel(l10n),
                        style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (plan.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(plan.description, style: theme.textTheme.bodyMedium?.copyWith(color: palette.muted)),
            ],
            const SizedBox(height: 10),
            for (final feature in plan.featureLabels(l10n))
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, size: 18, color: palette.onSage),
                    const SizedBox(width: 8),
                    Expanded(child: Text(feature)),
                  ],
                ),
              ),
            if (footer != null) ...[const SizedBox(height: 8), Text(footer!, style: theme.textTheme.bodySmall)],
            if (action != null) ...[
              const SizedBox(height: 14),
              FilledButton(onPressed: action!.$2, child: Text(action!.$1)),
            ],
          ],
        ),
      ),
    );
  }
}

class _Info extends StatelessWidget {
  const _Info(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 12),
    child: NoticeCard(text: text, tone: Tone.peach),
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
    final palette = ZakaPalette.of(context);
    return ref
        .watch(orgPaymentsProvider(orgId))
        .when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text(l10n.genericError),
          data: (payments) => payments.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(l10n.billingNoPayments, style: TextStyle(color: palette.muted)),
                )
              : CardList(
                  indent: 70,
                  children: [
                    for (final p in payments)
                      ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                        leading: IconTile(
                          icon: Icons.receipt_long_outlined,
                          background: p.status.color(scheme).withValues(alpha: 0.12),
                          foreground: p.status.color(scheme),
                          size: 42,
                        ),
                        title: Text(p.description, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(p.createdAt == null ? '' : _paymentDate.format(p.createdAt!)),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(p.amount.format(), style: const TextStyle(fontWeight: FontWeight.w800)),
                            const SizedBox(height: 2),
                            Text(
                              p.status.label(l10n),
                              style: TextStyle(
                                color: p.status.color(scheme),
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                              ),
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

/// Titre de section de la page Abonnement.
class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(4, 26, 4, 10),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
    ),
  );
}
