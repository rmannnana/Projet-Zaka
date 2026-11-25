import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../data/admin_repository.dart';
import '../data/moderation_repository.dart';

//// Accueil du back-office : files de travail en attente et chiffres clés.
class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(adminCountersProvider);
    final isAdmin = ref.watch(staffRoleProvider).value == 'admin';
    final activity = ref.watch(activityCountersProvider).value;
    final user = ref.watch(authStateProvider).value;
    final firstName = (user?.displayName ?? '').split(' ').first;
    return RefreshIndicator(
      onRefresh: () {
        ref.invalidate(activityCountersProvider);
        return ref.refresh(adminCountersProvider.future);
      },
      child: counters.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Chargement impossible : $e')),
        data: (c) {
          final queues = [c.pendingOrgs, c.openReports, c.pendingDeletions, activity?.pendingListings ?? 0];
          final waiting = queues.fold<int>(0, (a, b) => a + b);
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
            children: [
              BrandCard(
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstName.isEmpty ? 'Bonjour 👋' : 'Bonjour $firstName 👋',
                            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            waiting == 0
                                ? 'Rien en attente : toutes les files sont à jour.'
                                : '$waiting élément${waiting > 1 ? 's' : ''} en attente de traitement.',
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Actualiser',
                      color: Colors.white,
                      style: IconButton.styleFrom(backgroundColor: Colors.white.withValues(alpha: 0.14)),
                      icon: const Icon(Icons.refresh),
                      onPressed: () {
                        ref.invalidate(activityCountersProvider);
                        ref.invalidate(adminCountersProvider);
                      },
                    ),
                  ],
                ),
              ),
              const _Heading('À traiter'),
              StatGrid(
                minWidth: 200,
                children: [
                  _tile(
                    context,
                    'Comptes pros à vérifier',
                    c.pendingOrgs,
                    Icons.verified_user_outlined,
                    '/comptes',
                    Tone.peach,
                  ),
                  _tile(
                    context,
                    'Annonces de particuliers à valider',
                    activity?.pendingListings,
                    Icons.fact_check_outlined,
                    '/annonces',
                    Tone.peach,
                  ),
                  _tile(
                    context,
                    'Signalements ouverts',
                    c.openReports,
                    Icons.flag_outlined,
                    '/signalements',
                    Tone.danger,
                  ),
                  _tile(
                    context,
                    'Demandes de suppression',
                    c.pendingDeletions,
                    Icons.person_remove_outlined,
                    '/suppressions',
                    Tone.lavender,
                  ),
                ],
              ),
              const _Heading('Plateforme'),
              StatGrid(
                minWidth: 200,
                children: [
                  _tile(context, 'Utilisateurs inscrits', c.users, Icons.people_outline, null, Tone.sky),
                  _tile(
                    context,
                    'Comptes pros vérifiés',
                    c.verifiedOrgs,
                    Icons.storefront_outlined,
                    '/comptes',
                    Tone.mint,
                  ),
                  _tile(
                    context,
                    'Annonces en ligne (hôtels et biens)',
                    activity?.published,
                    Icons.public,
                    null,
                    Tone.mint,
                  ),
                  _tile(
                    context,
                    'Réservations en attente de réponse',
                    activity?.openBookings,
                    Icons.hotel_outlined,
                    null,
                    Tone.sage,
                  ),
                  _tile(
                    context,
                    'Nouvelles demandes de contact',
                    activity?.newLeads,
                    Icons.forum_outlined,
                    null,
                    Tone.sage,
                  ),
                  if (isAdmin) ...[
                    _tile(
                      context,
                      'Abonnements payants actifs',
                      c.activeSubscriptions,
                      Icons.workspace_premium_outlined,
                      '/facturation',
                      Tone.peach,
                    ),
                    _tile(context, 'Commissions dues', c.dueCommissions, Icons.percent, '/facturation', Tone.peach),
                  ],
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  /// Chiffre clé ; bordure colorée quand une file de travail n'est pas vide.
  Widget _tile(BuildContext context, String label, int? count, IconData icon, String? path, Tone tone) => StatCard(
    icon: icon,
    value: count?.toString() ?? '-',
    label: label,
    tone: tone,
    highlight: (count ?? 0) > 0 && path != null && tone != Tone.mint,
    onTap: path == null ? null : () => context.go(path),
  );
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(2, 26, 2, 12),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800, fontSize: 18),
    ),
  );
}

class AdminForbiddenScreen extends ConsumerWidget {
  const AdminForbiddenScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: EmptyState(
        icon: Icons.lock_outline,
        title: l10n.adminForbidden,
        action: OutlinedButton.icon(
          onPressed: () => ref.read(authRepositoryProvider).signOut(),
          icon: const Icon(Icons.logout),
          label: Text(l10n.signOut),
        ),
      ),
    );
  }
}
