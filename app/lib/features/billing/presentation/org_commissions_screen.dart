import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../data/billing_repository.dart';
import '../domain/billing.dart';
import 'billing_labels.dart';

/// Commissions d'un hôtel : ce qui reste à régler, et l'historique.
class OrgCommissionsScreen extends ConsumerWidget {
  const OrgCommissionsScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final commissions = ref.watch(orgCommissionsProvider(orgId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.commissionsTitle)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: commissions.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text(l10n.genericError)),
            data: (commissions) {
              final outstanding = totalOf(commissions.where((c) => c.status.isOutstanding));
              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(l10n.commissionsHelp),
                  const SizedBox(height: 16),
                  Card.outlined(
                    child: ListTile(
                      title: Text(l10n.commissionsOutstanding),
                      trailing: Text(outstanding.format(), style: theme.textTheme.titleLarge),
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (commissions.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24),
                      child: Text(l10n.commissionsEmpty, textAlign: TextAlign.center),
                    ),
                  for (final c in commissions)
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(c.amount.format()),
                      subtitle: Text([
                        if (c.createdAt != null) billingDate.format(c.createdAt!),
                        l10n.commissionOn(c.baseAmount.format()),
                        if (c.statusNote != null) c.statusNote!,
                      ].join(' · ')),
                      trailing: StatusChip(c.status.label(l10n), c.status.color(theme.colorScheme)),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
