import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../data/organization_repository.dart';
import '../domain/organization.dart';

/// Membres d'un compte pro. Seuls les propriétaires ajoutent ou retirent.
class MembersScreen extends ConsumerWidget {
  const MembersScreen({super.key, required this.orgId});

  final String orgId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final members = ref.watch(orgMembersProvider(orgId));
    final uid = ref.watch(authStateProvider).value?.uid;
    final isOwner = members.value?.any((m) => m.id == uid && m.role == OrgRole.owner) ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.orgMembers)),
      floatingActionButton: isOwner
          ? FloatingActionButton.extended(
              onPressed: () => _add(context, ref),
              icon: const Icon(Icons.person_add_alt),
              label: Text(l10n.memberAdd),
            )
          : null,
      body: members.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (members) => Readable(
          maxWidth: 760,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
            children: [
              CardList(
                indent: 72,
                children: [
                  for (final m in members)
                    ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                      leading: InitialsAvatar(
                        m.displayName?.isNotEmpty == true ? m.displayName! : (m.email ?? '?'),
                        tone: m.role == OrgRole.owner ? Tone.brand : Tone.mint,
                      ),
                      title: Text(
                        m.displayName?.isNotEmpty == true ? m.displayName! : (m.email ?? m.id),
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      subtitle: m.email == null || m.displayName?.isNotEmpty != true ? null : Text(m.email!),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StatusPill(
                            m.role == OrgRole.owner ? l10n.roleOwner : l10n.roleEditor,
                            m.role == OrgRole.owner
                                ? Theme.of(context).colorScheme.primary
                                : ZakaPalette.of(context).muted,
                          ),
                          if (isOwner && m.id != uid)
                            IconButton(
                              tooltip: l10n.memberRemove,
                              icon: const Icon(Icons.person_remove_outlined),
                              onPressed: () => _remove(context, ref, m),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final email = TextEditingController();
    var role = OrgRole.editor;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(l10n.memberAdd),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.memberAddHelp),
              const SizedBox(height: 12),
              TextField(
                controller: email,
                autofocus: true,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: l10n.email),
              ),
              const SizedBox(height: 12),
              SegmentedButton<OrgRole>(
                segments: [
                  ButtonSegment(value: OrgRole.editor, label: Text(l10n.roleEditor)),
                  ButtonSegment(value: OrgRole.owner, label: Text(l10n.roleOwner)),
                ],
                selected: {role},
                onSelectionChanged: (s) => setState(() => role = s.first),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
            FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.memberAdd)),
          ],
        ),
      ),
    );
    final address = email.text;
    email.dispose();
    if (ok != true || !address.contains('@')) return;
    try {
      await ref.read(organizationRepositoryProvider).addMember(orgId, email: address, role: role);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(functionErrorMessage(e))));
    }
  }

  Future<void> _remove(BuildContext context, WidgetRef ref, OrgMember member) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.memberRemove),
        content: Text(l10n.memberRemoveConfirm(member.displayName ?? member.email ?? member.id)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.memberRemove)),
        ],
      ),
    );
    if (ok != true) return;
    try {
      await ref.read(organizationRepositoryProvider).removeMember(orgId, member.id);
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(functionErrorMessage(e))));
    }
  }
}
