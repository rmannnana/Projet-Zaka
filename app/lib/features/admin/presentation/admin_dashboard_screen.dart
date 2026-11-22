import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../data/admin_repository.dart';

/// Accueil du back-office : files de travail en attente et chiffres clés.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(adminCountersProvider);
    return RefreshIndicator(
      onRefresh: () => ref.refresh(adminCountersProvider.future),
      child: counters.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Chargement impossible : $e')),
        data: (c) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text('À traiter', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Tile('Comptes pros à vérifier', c.pendingOrgs, Icons.verified_user_outlined, '/comptes'),
                _Tile('Signalements ouverts', c.openReports, Icons.flag_outlined, '/signalements'),
                _Tile('Demandes de suppression', c.pendingDeletions, Icons.person_remove_outlined, '/suppressions'),
                const _Tile(
                  'Annonces de particuliers à valider',
                  null,
                  Icons.fact_check_outlined,
                  null,
                  note: 'Avec les annonces immobilières (phase 4)',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Plateforme', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _Tile('Utilisateurs inscrits', c.users, Icons.people_outline, null),
                _Tile('Comptes pros vérifiés', c.verifiedOrgs, Icons.storefront_outlined, '/comptes'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile(this.label, this.count, this.icon, this.path, {this.note});

  final String label;
  final int? count;
  final IconData icon;
  final String? path;
  final String? note;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final highlight = (count ?? 0) > 0 && path != null;
    return SizedBox(
      width: 280,
      child: Card.outlined(
        child: InkWell(
          onTap: path == null ? null : () => context.go(path!),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, size: 32, color: highlight ? theme.colorScheme.primary : null),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        count?.toString() ?? '-',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          color: highlight ? theme.colorScheme.primary : null,
                        ),
                      ),
                      Text(label),
                      if (note != null) Text(note!, style: theme.textTheme.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
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
