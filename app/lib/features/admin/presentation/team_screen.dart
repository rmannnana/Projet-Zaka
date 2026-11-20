import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../account/domain/user_profile.dart';
import '../data/admin_repository.dart';
import 'admin_shell.dart';

const _roleLabels = {'admin': 'Admin', 'moderator': 'Modérateur', 'none': 'Aucun rôle'};

/// Équipe ZAKA : recherche d'un utilisateur et attribution des rôles (admins uniquement).
class TeamScreen extends ConsumerStatefulWidget {
  const TeamScreen({super.key});

  @override
  ConsumerState<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends ConsumerState<TeamScreen> {
  final _search = TextEditingController();
  List<UserProfile>? _results;
  bool _searching = false;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    setState(() => _searching = true);
    try {
      final results = await ref.read(adminRepositoryProvider).searchUsers(_search.text);
      if (mounted) setState(() => _results = results);
    } catch (e) {
      if (mounted) showAdminError(context, e);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final staff = ref.watch(staffProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('Équipe actuelle', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        staff.when(
          loading: () => const LinearProgressIndicator(),
          error: (e, _) => Text('Chargement impossible : $e'),
          data: (users) => Column(children: [for (final u in users) _UserRoleTile(user: u)]),
        ),
        const SizedBox(height: 24),
        Text('Ajouter un membre', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: _search,
                decoration: const InputDecoration(
                  labelText: 'E-mail ou téléphone (+226…)',
                  helperText: 'La personne doit déjà avoir un compte ZAKA.',
                ),
                onSubmitted: (_) => _run(),
              ),
            ),
            const SizedBox(width: 8),
            FilledButton.icon(
              onPressed: _searching ? null : _run,
              icon: const Icon(Icons.search),
              label: const Text('Chercher'),
            ),
          ],
        ),
        if (_results != null)
          _results!.isEmpty
              ? const Padding(padding: EdgeInsets.all(16), child: Text('Aucun utilisateur trouvé.'))
              : Column(children: [for (final u in _results!) _UserRoleTile(user: u)]),
      ],
    );
  }
}

class _UserRoleTile extends ConsumerStatefulWidget {
  const _UserRoleTile({required this.user});

  final UserProfile user;

  @override
  ConsumerState<_UserRoleTile> createState() => _UserRoleTileState();
}

class _UserRoleTileState extends ConsumerState<_UserRoleTile> {
  late String _role = widget.user.staffRole ?? 'none';
  bool _busy = false;

  Future<void> _change(String role) async {
    if (role == _role) return;
    setState(() => _busy = true);
    try {
      await ref.read(adminRepositoryProvider).setRole(widget.user.id, role);
      if (mounted) {
        setState(() => _role = role);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rôle modifié. La personne doit se reconnecter.')),
        );
      }
    } catch (e) {
      if (mounted) showAdminError(context, e);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final u = widget.user;
    final isMe = u.id == ref.watch(staffUidProvider);
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(u.displayName.isEmpty ? u.id : u.displayName),
      subtitle: Text([u.email, u.phone].whereType<String>().join(' · ')),
      trailing: _busy
          ? const SizedBox.square(dimension: 24, child: CircularProgressIndicator(strokeWidth: 2))
          : DropdownButton<String>(
              value: _role,
              onChanged: isMe ? null : (v) => _change(v!),
              items: [
                for (final e in _roleLabels.entries) DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
            ),
    );
  }
}
