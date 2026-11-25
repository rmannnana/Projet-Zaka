import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../billing/data/billing_repository.dart';
import '../../billing/presentation/billing_labels.dart';
import 'commissions_admin.dart';
import 'plans_admin.dart';

/// Facturation (admins) : l'équipe pilote les tarifs sans développeur.
class BillingAdminScreen extends StatelessWidget {
  const BillingAdminScreen({super.key});

  @override
  Widget build(BuildContext context) => const DefaultTabController(
    length: 5,
    child: Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: 12),
          child: PillTabBar(
            scrollable: true,
            labels: ["Plans d'abonnement", 'Règles de commission', 'Commissions', 'Abonnements actifs', 'Paiements'],
          ),
        ),
        Expanded(
          child: TabBarView(
            children: [PlansTab(), CommissionRulesTab(), CommissionsRegistryTab(), _SubscriptionsTab(), _PaymentsTab()],
          ),
        ),
      ],
    ),
  );
}

final _date = DateFormat('d MMM yyyy', 'fr');
final _dateTime = DateFormat('d MMM yyyy, HH:mm', 'fr');

class _SubscriptionsTab extends ConsumerWidget {
  const _SubscriptionsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return ref
        .watch(activeSubscriptionsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Chargement impossible : $e')),
          data: (subs) => subs.isEmpty
              ? const Center(child: Text('Aucun abonnement payant en cours : tous les comptes sont au plan Gratuit.'))
              : ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text('${subs.length} abonnement(s), du plus proche de son échéance au plus lointain.'),
                    ),
                    for (final s in subs)
                      ListTile(
                        leading: const Icon(Icons.workspace_premium_outlined),
                        title: Text(s.orgName ?? s.orgId),
                        subtitle: Text(
                          '${s.planSnapshot.name} · jusqu\'au '
                          '${s.currentPeriodEnd == null ? '?' : _date.format(s.currentPeriodEnd!)}',
                        ),
                        trailing: Text(s.planSnapshot.priceLabel(l10n)),
                      ),
                  ],
                ),
        );
  }
}

class _PaymentsTab extends ConsumerWidget {
  const _PaymentsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ref
        .watch(recentPaymentsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Chargement impossible : $e')),
          data: (payments) => payments.isEmpty
              ? const Center(child: Text('Aucun paiement.'))
              : ListView.separated(
                  itemCount: payments.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final p = payments[i];
                    return ListTile(
                      title: Text(p.description),
                      subtitle: Text(
                        [
                          p.orgName ?? p.payerOrgId ?? '',
                          if (p.createdAt != null) _dateTime.format(p.createdAt!),
                          p.isSimulated ? 'Simulation' : p.provider,
                        ].join(' · '),
                      ),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(p.amount.format()),
                          Text(p.status.label(l10n), style: TextStyle(color: p.status.color(scheme), fontSize: 12)),
                        ],
                      ),
                    );
                  },
                ),
        );
  }
}
