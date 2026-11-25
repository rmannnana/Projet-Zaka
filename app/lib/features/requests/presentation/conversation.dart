import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../data/requests_repository.dart';

final _time = DateFormat('d MMM, HH:mm', 'fr');

/// Discussion entre le client et le professionnel, dans une réservation ou une demande de contact.
class Conversation extends ConsumerStatefulWidget {
  const Conversation({super.key, required this.thread, required this.id, required this.role, this.enabled = true});

  final Thread thread;
  final String id;

  /// Rôle de l'utilisateur connecté : client, hotel ou pro.
  final String role;
  final bool enabled;

  @override
  ConsumerState<Conversation> createState() => _ConversationState();
}

class _ConversationState extends ConsumerState<Conversation> {
  final _text = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _text.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final uid = ref.read(authStateProvider).value?.uid;
    final text = _text.text.trim();
    if (uid == null || text.isEmpty) return;
    setState(() => _sending = true);
    try {
      await ref.read(requestsRepositoryProvider).sendMessage(widget.thread, widget.id, fromUid: uid, role: widget.role, text: text);
      _text.clear();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(functionErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final uid = ref.watch(authStateProvider).value?.uid;
    final messages = ref.watch(messagesProvider((thread: widget.thread, id: widget.id))).value ?? const [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.conversation, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        if (messages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.conversationEmpty, style: theme.textTheme.bodySmall),
          ),
        for (final m in messages)
          Align(
            alignment: m.fromUid == uid ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 4),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: m.fromUid == uid ? theme.colorScheme.primaryContainer : theme.colorScheme.surfaceContainerHighest,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(m.text),
                    const SizedBox(height: 2),
                    Text(
                      m.createdAt == null ? l10n.sending : _time.format(m.createdAt!),
                      style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.outline),
                    ),
                  ],
                ),
              ),
            ),
          ),
        if (widget.enabled) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _text,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 2000,
                  decoration: InputDecoration(hintText: l10n.writeMessage, counterText: ''),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: l10n.send,
                onPressed: _sending ? null : _send,
                icon: const Icon(Icons.send),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
