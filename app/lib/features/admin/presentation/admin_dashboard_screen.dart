import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';

/// Accueil du back-office. Les files de travail (vérification des comptes,
/// validation des annonces, signalements, suppressions) arrivent en phase 1.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  static const _queues = [
    (Icons.verified_user_outlined, 'Comptes pros à vérifier'),
    (Icons.fact_check_outlined, 'Annonces de particuliers à valider'),
    (Icons.flag_outlined, 'Signalements'),
    (Icons.person_remove_outlined, 'Demandes de suppression de données'),
    (Icons.percent, 'Commissions et abonnements'),
    (Icons.history, "Journal d'activité"),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final role = ref.watch(staffRoleProvider).value;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminTitle),
        actions: [
          if (role != null) Padding(padding: const EdgeInsets.only(right: 8), child: Chip(label: Text(role))),
          IconButton(
            tooltip: l10n.signOut,
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 320,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: [
          for (final (icon, label) in _queues)
            Card.outlined(
              child: InkWell(
                onTap: () => ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text(l10n.comingSoon))),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(icon, size: 32),
                      const SizedBox(width: 12),
                      Expanded(child: Text(label)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class AdminForbiddenScreen extends ConsumerWidget {
  const AdminForbiddenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline, size: 56),
            const SizedBox(height: 16),
            Text(l10n.adminForbidden),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => ref.read(authRepositoryProvider).signOut(),
              child: Text(l10n.signOut),
            ),
          ],
        ),
      ),
    );
  }
}
