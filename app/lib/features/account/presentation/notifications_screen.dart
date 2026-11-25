import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/links.dart';
import 'package:intl/intl.dart';

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
            ? Center(child: Text(l10n.notificationsEmpty))
            : ListView.separated(
                itemCount: items.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final n = items[i];
                  return ListTile(
                    leading: Icon(
                      n.read ? Icons.notifications_none : Icons.notifications_active,
                      color: n.read ? null : Theme.of(context).colorScheme.primary,
                    ),
                    title: Text(
                      n.title,
                      style: n.read ? null : const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(n.body),
                    trailing: n.createdAt == null ? null : Text(format.format(n.createdAt!)),
                    onTap: () {
                      final uid = ref.read(authStateProvider).value?.uid;
                      if (uid != null && !n.read) {
                        ref.read(accountRequestsRepositoryProvider).markRead(uid, n.id);
                      }
                      if (n.link != null) {
                        n.link!.startsWith('http') ? openExternal(n.link!) : context.push(n.link!);
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
