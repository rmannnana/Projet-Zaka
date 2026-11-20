import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../data/user_repository.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navAccount)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.account_circle_outlined, size: 64),
                const SizedBox(height: 16),
                Text(l10n.accountSignedOut, textAlign: TextAlign.center),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.push('/connexion'),
                  child: Text(l10n.signIn),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final name = profile?.displayName ?? user.displayName ?? '';
    return Scaffold(
      appBar: AppBar(title: Text(l10n.navAccount)),
      body: ListView(
        children: [
          ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(name.isEmpty ? l10n.accountNoName : name),
            subtitle: user.email == null ? null : Text(user.email!),
            trailing: IconButton(
              tooltip: l10n.accountEditName,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _editName(context, ref, user.uid, name),
            ),
          ),
          if (user.phoneNumber != null)
            ListTile(
              leading: const Icon(Icons.verified_outlined),
              title: Text(user.phoneNumber!),
              subtitle: Text(l10n.accountPhoneVerified),
            )
          else
            ListTile(
              leading: const Icon(Icons.add_call),
              title: Text(l10n.accountAddPhone),
              onTap: () => context.push('/compte/telephone'),
            ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.signOut),
            onTap: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
    );
  }

  Future<void> _editName(BuildContext context, WidgetRef ref, String uid, String current) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController(text: current);
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.accountEditName),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.displayName),
          onSubmitted: (v) => Navigator.pop(context, v),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: Text(l10n.save),
          ),
        ],
      ),
    );
    controller.dispose();
    if (name == null || name.trim().isEmpty || name.trim() == current) return;
    await ref.read(userRepositoryProvider).updateProfile(uid, displayName: name.trim());
    await ref.read(authRepositoryProvider).currentUser?.updateDisplayName(name.trim());
  }
}
