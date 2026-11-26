import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
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

    final palette = ZakaPalette.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.conversation, style: theme.textTheme.titleMedium?.copyWith(fontSize: 18)),
        const SizedBox(height: 10),
        if (messages.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(l10n.conversationEmpty, style: theme.textTheme.bodySmall),
          ),
        for (final m in messages)
          Builder(
            builder: (context) {
              final mine = m.fromUid == uid;
              return Align(
                alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: (MediaQuery.sizeOf(context).width * 0.78).clamp(0, 480)),
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
                    decoration: BoxDecoration(
                      color: mine ? scheme.primary : scheme.surfaceContainerLow,
                      border: mine ? null : Border.all(color: palette.line),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(18),
                        topRight: const Radius.circular(18),
                        bottomLeft: Radius.circular(mine ? 18 : 4),
                        bottomRight: Radius.circular(mine ? 4 : 18),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: SelectableText(
                            m.text,
                            style: TextStyle(color: mine ? scheme.onPrimary : scheme.onSurface, height: 1.4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m.createdAt == null ? l10n.sending : _time.format(m.createdAt!),
                          style: TextStyle(
                            fontSize: 11,
                            color: mine ? scheme.onPrimary.withValues(alpha: 0.7) : palette.muted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        if (widget.enabled) ...[
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _text,
                  minLines: 1,
                  maxLines: 4,
                  maxLength: 2000,
                  decoration: InputDecoration(
                    hintText: l10n.writeMessage,
                    counterText: '',
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(26), borderSide: BorderSide(color: palette.line)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: BorderSide(color: palette.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(26),
                      borderSide: BorderSide(color: scheme.primary, width: 1.6),
                    ),
                  ),
                  onSubmitted: (_) => _send(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                tooltip: l10n.send,
                onPressed: _sending ? null : _send,
                icon: const Icon(Icons.send_rounded),
                style: IconButton.styleFrom(minimumSize: const Size(50, 50), shape: const CircleBorder()),
              ),
            ],
          ),
        ],
      ],
    );
  }
}
