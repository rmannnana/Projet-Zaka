import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../data/account_requests_repository.dart';
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
    final orgCount = ref.watch(myOrganizationsProvider).value?.length ?? 0;
    final unread = ref.watch(unreadNotificationsProvider);
    final deletionPending = ref.watch(pendingDeletionProvider).value ?? false;
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
          ListTile(
            leading: Badge(
              isLabelVisible: unread > 0,
              label: Text('$unread'),
              child: const Icon(Icons.notifications_outlined),
            ),
            title: Text(l10n.notifications),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/compte/notifications'),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border),
            title: Text(l10n.favorites),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/favoris'),
          ),
          ListTile(
            leading: const Icon(Icons.inbox_outlined),
            title: Text(l10n.navRequests),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.go('/demandes'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.storefront_outlined),
            title: Text(l10n.proSpaces),
            subtitle: Text(orgCount == 0 ? l10n.proSpacesEmptyHint : l10n.proSpacesCount(orgCount)),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push(orgCount == 0 ? '/pro/nouveau' : '/pro'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: Text(l10n.legalTerms),
            onTap: () => context.push('/cgu'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: Text(l10n.legalPrivacy),
            onTap: () => context.push('/confidentialite'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text(l10n.signOut),
            onTap: () => ref.read(authRepositoryProvider).signOut(),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline, color: Theme.of(context).colorScheme.error),
            title: Text(l10n.deleteAccount),
            subtitle: deletionPending ? Text(l10n.deleteAccountPending) : null,
            enabled: !deletionPending,
            onTap: () => _requestDeletion(context, ref, user.uid),
          ),
        ],
      ),
    );
  }

  Future<void> _requestDeletion(BuildContext context, WidgetRef ref, String uid) async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final reason = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.deleteAccountExplain),
            const SizedBox(height: 12),
            TextField(
              controller: reason,
              maxLines: 2,
              decoration: InputDecoration(labelText: l10n.deleteAccountReason),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.cancel)),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Theme.of(context).colorScheme.error),
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.deleteAccountConfirm),
          ),
        ],
      ),
    );
    final text = reason.text;
    reason.dispose();
    if (ok != true) return;
    try {
      await ref.read(accountRequestsRepositoryProvider).requestDeletion(uid, reason: text);
      messenger.showSnackBar(SnackBar(content: Text(l10n.deleteAccountSent)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.genericError)));
    }
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
