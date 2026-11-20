import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../data/organization_repository.dart';
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/pro/nouveau'),
        icon: const Icon(Icons.add),
        label: Text(l10n.proCreate),
      ),
      body: orgs.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (orgs) => orgs.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(l10n.proEmpty, textAlign: TextAlign.center),
                ),
              )
            : ListView(
                padding: const EdgeInsets.only(bottom: 88),
                children: [
                  for (final org in orgs)
                    ListTile(
                      leading: CircleAvatar(child: Icon(org.type.icon)),
                      title: Text(org.name),
                      subtitle: Text(org.type.label(l10n)),
                      trailing: VerificationStatusChip(org.verification.status),
                      onTap: () => context.push('/pro/${org.id}'),
                    ),
                ],
              ),
      ),
    );
  }
}
