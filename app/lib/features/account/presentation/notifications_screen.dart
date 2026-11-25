import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/links.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../data/account_requests_repository.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final notifications = ref.watch(notificationsProvider);
    final format = DateFormat('d MMM, HH:mm', 'fr');

    return Scaffold(
      appBar: AppBar(title: Text(l10n.notifications)),
      body: notifications.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (items) => items.isEmpty
            ? EmptyState(icon: Icons.notifications_none, title: l10n.notificationsEmpty)
            : Readable(
                maxWidth: 760,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                  children: [
                    CardList(
                      indent: 70,
                      children: [
                        for (final n in items)
                          ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            tileColor: n.read
                                ? null
                                : Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.35),
                            leading: ToneIcon(
                              n.read ? Icons.notifications_none : Icons.notifications_active,
                              tone: n.read ? Tone.neutral : Tone.mint,
                              size: 42,
                            ),
                            title: Text(
                              n.title,
                              style: TextStyle(fontWeight: n.read ? FontWeight.w600 : FontWeight.w800),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(n.body),
                                if (n.createdAt != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 4),
                                    child: Text(
                                      format.format(n.createdAt!),
                                      style: TextStyle(color: ZakaPalette.of(context).muted, fontSize: 12),
                                    ),
                                  ),
                              ],
                            ),
                            onTap: () {
                              final uid = ref.read(authStateProvider).value?.uid;
                              if (uid != null && !n.read) {
                                ref.read(accountRequestsRepositoryProvider).markRead(uid, n.id);
                              }
                              if (n.link != null) {
                                n.link!.startsWith('http') ? openExternal(n.link!) : context.push(n.link!);
                              }
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
