import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../listings/data/listings_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../../requests/data/requests_repository.dart';
import '../data/account_requests_repository.dart';
import '../data/user_repository.dart';

class _VerifiedPill extends StatelessWidget {
  const _VerifiedPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return DecoratedBox(
      decoration: BoxDecoration(color: palette.mint, borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.verified, size: 14, color: palette.onMint),
            const SizedBox(width: 4),
            Flexible(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: palette.onMint, fontSize: 12, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.value, required this.label, required this.onTap});

  final int value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final palette = ZakaPalette.of(context);
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(ZakaRadius.medium),
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(ZakaRadius.medium),
          ),
          child: Column(
            children: [
              Text('$value', style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(label, style: TextStyle(color: palette.muted, fontSize: 12.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(authStateProvider).value;
    final profile = ref.watch(currentUserProfileProvider).value;

    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navAccount)),
        body: Readable(
          maxWidth: 560,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [ZakaColors.brand, Color(0xFF136B55)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(ZakaRadius.card + 4),
                ),
                child: Column(
                  children: [
                    const ZakaLogo(size: 56, color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      l10n.signInWelcome,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.accountSignedOut,
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
                    ),
                    const SizedBox(height: 20),
                    FilledButton(
                      style: FilledButton.styleFrom(backgroundColor: palette.gold, foregroundColor: palette.onGold),
                      onPressed: () => context.push('/connexion'),
                      child: Text(l10n.signIn),
                    ),
                  ],
                ),
              ),
              MenuGroup(
                title: l10n.accountSectionInfo,
                children: [
                  MenuTile(
                    icon: Icons.storefront_outlined,
                    title: l10n.homeProAction,
                    subtitle: l10n.homeProTitle,
                    onTap: () => context.push('/pro'),
                  ),
                  MenuTile(icon: Icons.gavel_outlined, title: l10n.legalTerms, onTap: () => context.push('/cgu')),
                  MenuTile(icon: Icons.privacy_tip_outlined, title: l10n.legalPrivacy, onTap: () => context.push('/confidentialite')),
                ],
              ),
            ],
          ),
        ),
      );
    }

    final name = profile?.displayName ?? user.displayName ?? '';
    final orgCount = ref.watch(myOrganizationsProvider).value?.length ?? 0;
    final unread = ref.watch(unreadNotificationsProvider);
    final favorites = ref.watch(favoriteIdsProvider).length;
    final requests = (ref.watch(myBookingsProvider).value?.length ?? 0) + (ref.watch(myLeadsProvider).value?.length ?? 0);
    final deletionPending = ref.watch(pendingDeletionProvider).value ?? false;
    final initials = name.trim().isEmpty
        ? null
        : name.trim().split(RegExp(r'\s+')).take(2).map((w) => w.characters.first.toUpperCase()).join();

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navAccount)),
      body: Readable(
        maxWidth: 640,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 32),
          children: [
            Card(
              margin: EdgeInsets.zero,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 32,
                          backgroundColor: palette.mint,
                          foregroundColor: palette.onMint,
                          child: initials == null
                              ? const Icon(Icons.person, size: 32)
                              : Text(initials, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(name.isEmpty ? l10n.accountNoName : name, style: theme.textTheme.titleMedium),
                              if (user.email != null)
                                Text(user.email!, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                              const SizedBox(height: 6),
                              if (user.phoneNumber != null)
                                _VerifiedPill(label: '${l10n.accountPhoneVerified} · ${user.phoneNumber}')
                              else
                                InkWell(
                                  onTap: () => context.push('/compte/telephone'),
                                  child: Text(
                                    l10n.accountAddPhone,
                                    style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w700),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        IconButton(
                          tooltip: l10n.accountEditName,
                          icon: const Icon(Icons.edit_outlined),
                          onPressed: () => _editName(context, ref, user.uid, name),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _Stat(value: favorites, label: l10n.favorites, onTap: () => context.push('/favoris')),
                        _Stat(value: requests, label: l10n.navRequests, onTap: () => context.go('/demandes')),
                        _Stat(
                          value: unread,
                          label: l10n.accountStatUnread,
                          onTap: () => context.push('/compte/notifications'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            MenuGroup(
              title: l10n.accountSectionActivity,
              children: [
                MenuTile(
                  icon: Icons.notifications_none_rounded,
                  title: l10n.notifications,
                  badge: unread,
                  onTap: () => context.push('/compte/notifications'),
                ),
                MenuTile(icon: Icons.favorite_border, title: l10n.favorites, onTap: () => context.push('/favoris')),
                MenuTile(icon: Icons.forum_outlined, title: l10n.navRequests, onTap: () => context.go('/demandes')),
              ],
            ),
            MenuGroup(
              title: l10n.accountSectionPro,
              children: [
                MenuTile(
                  icon: Icons.storefront_outlined,
                  title: l10n.proSpaces,
                  subtitle: orgCount == 0 ? l10n.proSpacesEmptyHint : l10n.proSpacesCount(orgCount),
                  onTap: () => context.push(orgCount == 0 ? '/pro/nouveau' : '/pro'),
                ),
              ],
            ),
            MenuGroup(
              title: l10n.accountSectionInfo,
              children: [
                MenuTile(icon: Icons.gavel_outlined, title: l10n.legalTerms, onTap: () => context.push('/cgu')),
                MenuTile(icon: Icons.privacy_tip_outlined, title: l10n.legalPrivacy, onTap: () => context.push('/confidentialite')),
              ],
            ),
            MenuGroup(
              title: l10n.accountSectionAccount,
              children: [
                MenuTile(icon: Icons.logout, title: l10n.signOut, onTap: () => ref.read(authRepositoryProvider).signOut()),
                MenuTile(
                  icon: Icons.delete_outline,
                  title: l10n.deleteAccount,
                  subtitle: deletionPending ? l10n.deleteAccountPending : null,
                  destructive: true,
                  onTap: deletionPending ? null : () => _requestDeletion(context, ref, user.uid),
                ),
              ],
            ),
          ],
        ),
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
