import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../data/organization_repository.dart';
import '../domain/organization.dart';
import 'org_labels.dart';

/// Liste des espaces publieurs de l'utilisateur.
class ProHomeScreen extends ConsumerWidget {
  const ProHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final orgs = ref.watch(myOrganizationsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.proSpaces)),
      floatingActionButton: (orgs.value?.isEmpty ?? true)
          ? null
          : FloatingActionButton.extended(
              onPressed: () => context.push('/pro/nouveau'),
              icon: const Icon(Icons.add),
              label: Text(l10n.proCreate),
            ),
      body: orgs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (orgs) => orgs.isEmpty
            ? EmptyState(
                icon: Icons.storefront_outlined,
                title: l10n.proSpacesEmptyHint,
                body: l10n.proEmpty,
                action: FilledButton.icon(
                  onPressed: () => context.push('/pro/nouveau'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.proCreate),
                ),
              )
            : Readable(
                maxWidth: 760,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 96),
                  children: [
                    PageIntro(text: l10n.proSpacesIntro),
                    for (final org in orgs) ...[_OrgCard(org: org), const SizedBox(height: 12)],
                  ],
                ),
              ),
      ),
    );
  }
}

class _OrgCard extends StatelessWidget {
  const _OrgCard({required this.org});

  final Organization org;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    return Card(
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: () => context.push('/pro/${org.id}'),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              ToneIcon(org.type.icon, tone: org.type.tone, size: 52),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      org.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [org.type.label(l10n), if (org.contact.city.isNotEmpty) org.contact.city].join(' · '),
                      style: TextStyle(color: palette.muted, fontSize: 13),
                    ),
                    const SizedBox(height: 8),
                    VerificationStatusChip(org.verification.status),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: palette.muted),
            ],
          ),
        ),
      ),
    );
  }
}
