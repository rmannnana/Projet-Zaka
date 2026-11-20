import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';

/// Entrée du menu du back-office. [adminOnly] : masquée aux modérateurs.
class AdminDestination {
  const AdminDestination(this.path, this.label, this.icon, {this.adminOnly = false});

  final String path;
  final String label;
  final IconData icon;
  final bool adminOnly;
}

const adminDestinations = [
  AdminDestination('/', 'Tableau de bord', Icons.dashboard_outlined),
  AdminDestination('/comptes', 'Comptes pros', Icons.verified_user_outlined),
  AdminDestination('/signalements', 'Signalements', Icons.flag_outlined),
  AdminDestination('/suppressions', 'Suppressions', Icons.person_remove_outlined),
  AdminDestination('/equipe', 'Équipe et rôles', Icons.admin_panel_settings_outlined, adminOnly: true),
  AdminDestination('/catalogues', 'Catalogues', Icons.list_alt, adminOnly: true),
  AdminDestination('/journal', "Journal d'activité", Icons.history),
];

/// Mise en page du back-office : menu latéral sur grand écran, tiroir sinon.
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
    final index = destinations.lastIndexWhere(
      (d) => d.path == '/' ? location == '/' : location.startsWith(d.path),
    );
    final wide = MediaQuery.sizeOf(context).width >= 900;

    final appBar = AppBar(
      title: const Text('ZAKA Administration'),
      actions: [
        if (role != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Chip(label: Text(role == 'admin' ? 'Admin' : 'Modérateur')),
          ),
        IconButton(
          tooltip: 'Se déconnecter',
          icon: const Icon(Icons.logout),
          onPressed: () => ref.read(authRepositoryProvider).signOut(),
        ),
      ],
    );

    if (!wide) {
      return Scaffold(
        appBar: appBar,
        drawer: NavigationDrawer(
          selectedIndex: index < 0 ? null : index,
          onDestinationSelected: (i) {
            Navigator.pop(context);
            context.go(destinations[i].path);
          },
          children: [
            const SizedBox(height: 16),
            for (final d in destinations)
              NavigationDrawerDestination(icon: Icon(d.icon), label: Text(d.label)),
          ],
        ),
        body: child,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          NavigationRail(
            extended: MediaQuery.sizeOf(context).width >= 1200,
            selectedIndex: index < 0 ? null : index,
            labelType: MediaQuery.sizeOf(context).width >= 1200
                ? NavigationRailLabelType.none
                : NavigationRailLabelType.all,
            onDestinationSelected: (i) => context.go(destinations[i].path),
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(icon: Icon(d.icon), label: Text(d.label)),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: child),
        ],
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
