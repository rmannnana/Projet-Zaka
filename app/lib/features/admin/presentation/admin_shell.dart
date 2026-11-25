import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../data/admin_repository.dart';
import '../data/moderation_repository.dart';

/// Entrée du menu du back-office. [adminOnly] : masquée aux modérateurs.
class AdminDestination {
  const AdminDestination(this.path, this.label, this.icon, this.description, {this.adminOnly = false});

  final String path;
  final String label;
  final IconData icon;

  /// Phrase sous le titre de la page.
  final String description;
  final bool adminOnly;
}

const adminDestinations = [
  AdminDestination('/', 'Tableau de bord', Icons.dashboard_outlined, 'Files de travail en attente et chiffres clés.'),
  AdminDestination(
    '/comptes',
    'Comptes pros',
    Icons.verified_user_outlined,
    'Dossiers des professionnels : vérification, refus, suspension.',
  ),
  AdminDestination(
    '/annonces',
    'Annonces à valider',
    Icons.fact_check_outlined,
    'Annonces de particuliers à publier ou à refuser avec un motif.',
  ),
  AdminDestination(
    '/signalements',
    'Signalements',
    Icons.flag_outlined,
    'Signalements des utilisateurs, du plus ancien au plus récent.',
  ),
  AdminDestination(
    '/litiges',
    'Litiges',
    Icons.gavel_outlined,
    "Export tracé du dossier d'une réservation ou d'une demande.",
  ),
  AdminDestination(
    '/suppressions',
    'Suppressions',
    Icons.person_remove_outlined,
    'Demandes d\'effacement des données personnelles (30 jours).',
  ),
  AdminDestination(
    '/equipe',
    'Équipe et rôles',
    Icons.admin_panel_settings_outlined,
    'Administrateurs et modérateurs de ZAKA.',
    adminOnly: true,
  ),
  AdminDestination(
    '/facturation',
    'Facturation',
    Icons.payments_outlined,
    'Plans, commissions, abonnements et paiements.',
    adminOnly: true,
  ),
  AdminDestination(
    '/catalogues',
    'Catalogues',
    Icons.list_alt,
    'Villes, équipements et types de biens proposés dans les formulaires.',
    adminOnly: true,
  ),
  AdminDestination('/journal', "Journal d'activité", Icons.history, 'Les 100 dernières opérations sensibles.'),
];

/// Mise en page du back-office : menu latéral vert sur grand écran, tiroir sinon.
class AdminShell extends ConsumerWidget {
  const AdminShell({super.key, required this.location, required this.child});

  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final role = ref.watch(staffRoleProvider).value;
    final destinations = [
      for (final d in adminDestinations)
        if (!d.adminOnly || role == 'admin') d,
    ];
    final index = destinations.lastIndexWhere((d) => d.path == '/' ? location == '/' : location.startsWith(d.path));
    final current = index < 0 ? null : destinations[index];
    final wide = MediaQuery.sizeOf(context).width >= 900;
    // Lignes de liste sur fond blanc : elles se détachent du fond gris clair.
    final body = ListTileTheme(
      data: ListTileTheme.of(context).copyWith(tileColor: Theme.of(context).colorScheme.surfaceContainerLow),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 1180), child: child),
      ),
    );

    if (!wide) {
      return Scaffold(
        appBar: AppBar(
          title: Text(current?.label ?? 'Administration'),
          actions: [if (role != null) Padding(padding: const EdgeInsets.only(right: 12), child: _RolePill(role))],
        ),
        drawer: Drawer(
          backgroundColor: ZakaColors.brandDark,
          child: _Sidebar(
            destinations: destinations,
            index: index,
            onSelect: (d) {
              Navigator.pop(context);
              context.go(d.path);
            },
          ),
        ),
        body: body,
      );
    }

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            width: 256,
            child: _Sidebar(destinations: destinations, index: index, onSelect: (d) => context.go(d.path)),
          ),
          Expanded(
            child: Column(
              children: [
                _TopBar(destination: current, role: role),
                Expanded(child: body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Menu vert foncé : logo, rubriques avec compteurs, compte connecté.
class _Sidebar extends ConsumerWidget {
  const _Sidebar({required this.destinations, required this.index, required this.onSelect});

  final List<AdminDestination> destinations;
  final int index;
  final ValueChanged<AdminDestination> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final counters = ref.watch(adminCountersProvider).value;
    final activity = ref.watch(activityCountersProvider).value;
    int? badge(String path) => switch (path) {
      '/comptes' => counters?.pendingOrgs,
      '/annonces' => activity?.pendingListings,
      '/signalements' => counters?.openReports,
      '/suppressions' => counters?.pendingDeletions,
      _ => null,
    };
    final user = ref.watch(authStateProvider).value;
    final role = ref.watch(staffRoleProvider).value;
    final name = (user?.displayName?.isNotEmpty ?? false) ? user!.displayName! : (user?.email ?? '');

    return Material(
      color: ZakaColors.brandDark,
      child: SafeArea(
        right: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 26, 24, 4),
              child: ZakaLogo(size: 30, color: Colors.white, withName: true),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 0, 24, 18),
              child: Text(
                'ADMINISTRATION',
                style: TextStyle(
                  color: ZakaPalette.light.gold,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.6,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: [
                  for (final (i, d) in destinations.indexed)
                    _NavItem(destination: d, selected: i == index, badge: badge(d.path), onTap: () => onSelect(d)),
                ],
              ),
            ),
            Divider(height: 1, color: Colors.white.withValues(alpha: 0.1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: Colors.white.withValues(alpha: 0.14),
                    child: Text(
                      InitialsAvatar.initialsOf(name.isEmpty ? '?' : name),
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                        if (role != null)
                          Text(
                            _roleLabel(role),
                            style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'Se déconnecter',
                    color: Colors.white70,
                    icon: const Icon(Icons.logout),
                    onPressed: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String _roleLabel(String role) => role == 'admin' ? 'Admin' : 'Modérateur';

class _NavItem extends StatelessWidget {
  const _NavItem({required this.destination, required this.selected, required this.onTap, this.badge});

  final AdminDestination destination;
  final bool selected;
  final VoidCallback onTap;
  final int? badge;

  @override
  Widget build(BuildContext context) {
    final gold = ZakaPalette.light.gold;
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: selected ? Colors.white.withValues(alpha: 0.12) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
            child: Row(
              children: [
                Icon(destination.icon, size: 21, color: selected ? gold : Colors.white70),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    destination.label,
                    style: TextStyle(
                      color: selected ? Colors.white : Colors.white.withValues(alpha: 0.82),
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ),
                if ((badge ?? 0) > 0)
                  DecoratedBox(
                    decoration: BoxDecoration(color: gold, borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      child: Text(
                        '$badge',
                        style: TextStyle(color: ZakaPalette.light.onGold, fontWeight: FontWeight.w800, fontSize: 12),
                      ),
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

/// En-tête des pages sur grand écran : titre, explication, rôle.
class _TopBar extends StatelessWidget {
  const _TopBar({required this.destination, required this.role});

  final AdminDestination? destination;
  final String? role;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 18, 24, 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerLow,
        border: Border(bottom: BorderSide(color: palette.line)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  destination?.label ?? 'Administration',
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800, fontSize: 22),
                ),
                if (destination != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(destination!.description, style: TextStyle(color: palette.muted, fontSize: 13.5)),
                  ),
              ],
            ),
          ),
          if (role != null) _RolePill(role!),
        ],
      ),
    );
  }
}

class _RolePill extends StatelessWidget {
  const _RolePill(this.role);

  final String role;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: palette.peach, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.shield_outlined, size: 16, color: palette.onPeach),
            const SizedBox(width: 6),
            Text(
              _roleLabel(role),
              style: TextStyle(color: palette.onPeach, fontWeight: FontWeight.w800, fontSize: 12.5),
            ),
          ],
        ),
      ),
    );
  }
}

/// Champ de saisie d'un motif, obligatoire ou non.
Future<String?> askNote(
  BuildContext context, {
  required String title,
  required String confirmLabel,
  String? help,
  bool required = true,
}) async {
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (help != null) ...[Text(help), const SizedBox(height: 12)],
              TextField(
                controller: controller,
                autofocus: true,
                maxLines: 3,
                maxLength: 1000,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  labelText: required ? 'Motif (communiqué au demandeur)' : 'Commentaire (facultatif)',
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          FilledButton(
            onPressed: required && controller.text.trim().isEmpty
                ? null
                : () => Navigator.pop(context, controller.text.trim()),
            child: Text(confirmLabel),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  return result;
}

/// Affiche le message d'erreur d'une action du back-office.
void showAdminError(BuildContext context, Object error) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error is String ? error : functionErrorMessage(error)),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}
