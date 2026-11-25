import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import '../../requests/data/requests_repository.dart';
import '../../requests/domain/requests.dart';

/// Demande de contact, de visite ou d'information sur un bien ou un programme.
Future<void> showLeadSheet(
  BuildContext context,
  WidgetRef ref, {
  required String targetType,
  required String targetId,
  required String title,
  required LeadType type,
  String? unitId,
  String? unitLabel,
}) async {
  if (ref.read(authStateProvider).value == null) {
    final back = targetType == 'property' ? '/bien/$targetId' : '/programme/$targetId';
    context.push('/connexion?retour=${Uri.encodeComponent(back)}');
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _LeadSheet(
      targetType: targetType,
      targetId: targetId,
      title: title,
      type: type,
      unitId: unitId,
      unitLabel: unitLabel,
    ),
  );
}

class _LeadSheet extends ConsumerStatefulWidget {
  const _LeadSheet({
    required this.targetType,
    required this.targetId,
    required this.title,
    required this.type,
    this.unitId,
    this.unitLabel,
  });

  final String targetType;
  final String targetId;
  final String title;
  final LeadType type;
  final String? unitId;
  final String? unitLabel;

  @override
  ConsumerState<_LeadSheet> createState() => _LeadSheetState();
}

class _LeadSheetState extends ConsumerState<_LeadSheet> {
  late LeadType _type = widget.type;
  late final _message = TextEditingController();
  final _dates = TextEditingController();
  late final _phone = TextEditingController(text: ref.read(currentUserProfileProvider).value?.phone ?? '');
  bool _sending = false;
  String? _error;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;
    final l10n = AppLocalizations.of(context);
    _message.text = widget.unitLabel != null
        ? l10n.leadTemplateUnit(widget.unitLabel!, widget.title)
        : l10n.leadTemplate(widget.title);
  }

  @override
  void dispose() {
    _message.dispose();
    _dates.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    if (_message.text.trim().isEmpty) {
      setState(() => _error = l10n.leadMessageRequired);
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final id = await ref.read(requestsRepositoryProvider).createLead(
        targetType: widget.targetType,
        targetId: widget.targetId,
        unitId: widget.unitId,
        type: _type,
        message: _message.text,
        preferredDates: _type == LeadType.visit ? _dates.text : '',
        phone: _phone.text,
      );
      if (!mounted) return;
      final router = GoRouter.of(context);
      final messenger = ScaffoldMessenger.of(context);
      Navigator.pop(context);
      messenger.showSnackBar(
        SnackBar(
          content: Text(l10n.leadSent),
          action: SnackBarAction(label: l10n.seeMyRequest, onPressed: () => router.push('/contacts/$id')),
        ),
      );
    } catch (e) {
      if (mounted) setState(() => _error = functionErrorMessage(e));
    } finally {
      if (mounted) setState(() => _sending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
          child: Readable(
            maxWidth: 560,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(widget.title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                SegmentedButton<LeadType>(
                  segments: [
                    for (final t in LeadType.values)
                      ButtonSegment(value: t, icon: Icon(t.icon), label: Text(t.label(l10n))),
                  ],
                  selected: {_type},
                  onSelectionChanged: (s) => setState(() => _type = s.first),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _message,
                  maxLines: 4,
                  maxLength: 2000,
                  decoration: InputDecoration(labelText: l10n.yourMessage),
                ),
                if (_type == LeadType.visit)
                  TextField(
                    controller: _dates,
                    maxLength: 200,
                    decoration: InputDecoration(labelText: l10n.preferredDates, hintText: l10n.preferredDatesHint),
                  ),
                TextField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: l10n.contactPhone, helperText: l10n.contactPhoneHelp),
                ),
                if (_error != null) ...[
                  const SizedBox(height: 8),
                  Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                ],
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _sending ? null : _send,
                  child: _sending
                      ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(l10n.sendRequest),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Barre fixe en bas d'une fiche : prix et action principale.
class BottomActionBar extends StatelessWidget {
  const BottomActionBar({super.key, required this.price, required this.actions});

  final String? price;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      elevation: 8,
      color: theme.colorScheme.surfaceContainer,
      child: SafeArea(
        top: false,
        child: Readable(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(
              children: [
                if (price != null)
                  Expanded(
                    child: Text(
                      price!,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  )
                else
                  const Spacer(),
                for (final a in actions) Padding(padding: const EdgeInsets.only(left: 8), child: a),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Raccourci : date courte d'une visite.
String visitLabel(DateTime date) => dateTimeFormat.format(date);
