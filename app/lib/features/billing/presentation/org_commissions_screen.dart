import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
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
      body: Readable(
        maxWidth: 720,
        child: commissions.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.genericError)),
          data: (commissions) {
            final outstanding = totalOf(commissions.where((c) => c.status.isOutstanding));
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BrandCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.commissionsOutstanding, style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                      const SizedBox(height: 4),
                      Text(
                        outstanding.format(),
                        style: TextStyle(
                          color: ZakaPalette.of(context).gold,
                          fontWeight: FontWeight.w800,
                          fontSize: 26,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                PageIntro(text: l10n.commissionsHelp),
                if (commissions.isEmpty)
                  EmptyState(icon: Icons.percent, title: l10n.commissionsEmpty)
                else
                  CardList(
                    indent: 70,
                    children: [
                      for (final c in commissions)
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          leading: IconTile(
                            icon: Icons.percent,
                            background: c.status.color(theme.colorScheme).withValues(alpha: 0.12),
                            foreground: c.status.color(theme.colorScheme),
                            size: 42,
                          ),
                          title: Text(c.amount.format(), style: const TextStyle(fontWeight: FontWeight.w800)),
                          subtitle: Text(
                            [
                              if (c.createdAt != null) billingDate.format(c.createdAt!),
                              l10n.commissionOn(c.baseAmount.format()),
                              if (c.statusNote != null) c.statusNote!,
                            ].join(' · '),
                          ),
                          trailing: StatusChip(c.status.label(l10n), c.status.color(theme.colorScheme)),
                        ),
                    ],
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
