import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/links.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import '../../requests/data/requests_repository.dart';
import '../../requests/domain/requests.dart';
import '../../requests/presentation/client_requests_screens.dart';
import '../../requests/presentation/conversation.dart';
import 'editor_widgets.dart';

enum _BookingFilter { toHandle, accepted, done, all }

/// Demandes de réservation reçues par un hôtel.
class ProBookingsScreen extends ConsumerStatefulWidget {
  const ProBookingsScreen({super.key, required this.orgId});

  final String orgId;

  @override
  ConsumerState<ProBookingsScreen> createState() => _ProBookingsScreenState();
}

class _ProBookingsScreenState extends ConsumerState<ProBookingsScreen> {
  _BookingFilter _filter = _BookingFilter.toHandle;

  bool _keep(BookingRequest b) => switch (_filter) {
    _BookingFilter.toHandle => b.status.isOpen,
    _BookingFilter.accepted => b.status == BookingStatus.accepted,
    _BookingFilter.done => !b.status.isOpen && b.status != BookingStatus.accepted,
    _BookingFilter.all => true,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final all = ref.watch(orgBookingsProvider(widget.orgId));
    final open = all.value?.where((b) => b.status.isOpen).length ?? 0;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.receivedBookings)),
      body: Readable(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilterChipsBar<_BookingFilter>(
              values: _BookingFilter.values,
              selected: _filter,
              label: (f) => switch (f) {
                _BookingFilter.toHandle => l10n.toHandle(open),
                _BookingFilter.accepted => l10n.bookingAccepted,
                _BookingFilter.done => l10n.closedRequests,
                _BookingFilter.all => l10n.all,
              },
              onSelected: (f) => setState(() => _filter = f),
            ),
            Expanded(
              child: all.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l10n.genericError)),
                data: (items) {
                  final shown = items.where(_keep).toList();
                  if (shown.isEmpty) return EmptyState(icon: Icons.inbox_outlined, title: l10n.noRequestHere);
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      CardList(
                        indent: 72,
                        children: [
                          for (final b in shown)
                            RequestRow(
                              icon: b.status.icon,
                              color: b.status.color(scheme),
                              title: '${b.clientSnapshot.name} · ${b.roomTypeName}',
                              status: b.status.label(l10n),
                              lines: [
                                if (b.checkIn != null && b.checkOut != null)
                                  '${shortDate.format(b.checkIn!)} → ${shortDate.format(b.checkOut!)} · '
                                      '${l10n.guestsSummary(b.adults, b.children, b.rooms)}',
                                if (b.status.isOpen && b.expiresAt != null)
                                  l10n.answerBefore(dateTimeFormat.format(b.expiresAt!)),
                              ],
                              onTap: () => context.push('/pro/${widget.orgId}/reservations/${b.id}'),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Une demande de réservation, côté hôtel : décision et discussion avec le client.
class ProBookingDetailScreen extends ConsumerStatefulWidget {
  const ProBookingDetailScreen({super.key, required this.orgId, required this.bookingId});

  final String orgId;
  final String bookingId;

  @override
  ConsumerState<ProBookingDetailScreen> createState() => _ProBookingDetailScreenState();
}

class _ProBookingDetailScreenState extends ConsumerState<ProBookingDetailScreen> {
  bool _busy = false;

  Future<void> _act(BookingAction action, {bool askNote = false, bool noteRequired = false}) async {
    final l10n = AppLocalizations.of(context);
    String? note;
    if (askNote) {
      note = await _askMessage(
        context,
        title: switch (action) {
          BookingAction.reject => l10n.rejectBookingTitle,
          BookingAction.requestInfo => l10n.askInfoTitle,
          BookingAction.cancel => l10n.cancelAcceptedTitle,
          _ => '',
        },
        required: noteRequired,
      );
      if (note == null) return;
    }
    setState(() => _busy = true);
    try {
      await ref.read(requestsRepositoryProvider).updateBooking(widget.bookingId, action, note: note);
    } catch (e) {
      if (mounted) showResult(context, functionErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booking = ref.watch(bookingProvider(widget.bookingId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookingRequest)),
      body: booking.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (b) {
          if (b == null) return EmptyState(icon: Icons.search_off, title: l10n.requestNotFound);
          final now = DateTime.now();
          final help = switch (b.status) {
            BookingStatus.pending => l10n.hotelPendingHelp(
              b.expiresAt == null ? '' : dateTimeFormat.format(b.expiresAt!),
            ),
            BookingStatus.infoRequested => l10n.hotelInfoRequestedHelp,
            BookingStatus.accepted => b.isPaid ? l10n.hotelPaidHelp : l10n.hotelAcceptedHelp,
            _ => bookingStatusHelp(l10n, b),
          };
          return Readable(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BookingStatusCard(status: b.status, help: help),
                const SizedBox(height: 12),
                ClientCard(
                  name: b.clientSnapshot.name,
                  subtitle: [
                    if (b.clientSnapshot.phone != null) b.clientSnapshot.phone!,
                    if (b.clientSnapshot.email != null) b.clientSnapshot.email!,
                  ].join(' · '),
                  actions: [
                    if (b.clientSnapshot.phone != null) ...[
                      OutlinedButton.icon(
                        onPressed: () => callPhone(b.clientSnapshot.phone!),
                        icon: const Icon(Icons.call_outlined),
                        label: Text(l10n.call),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => openWhatsApp(b.clientSnapshot.phone!),
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text('WhatsApp'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                BookingSummaryCard(booking: b),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (b.status.isOpen) ...[
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          minimumSize: const Size(0, 46),
                          backgroundColor: ZakaColors.success,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: _busy ? null : () => _act(BookingAction.accept),
                        icon: const Icon(Icons.check),
                        label: Text(l10n.accept),
                      ),
                      OutlinedButton.icon(
                        onPressed: _busy ? null : () => _act(BookingAction.reject, askNote: true),
                        icon: const Icon(Icons.close),
                        label: Text(l10n.reject),
                      ),
                    ],
                    if (b.status == BookingStatus.pending)
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () => _act(BookingAction.requestInfo, askNote: true, noteRequired: true),
                        icon: const Icon(Icons.help_outline),
                        label: Text(l10n.askInfo),
                      ),
                    if (b.status == BookingStatus.accepted && b.hasStarted(now))
                      FilledButton.icon(
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                        onPressed: _busy ? null : () => _act(BookingAction.complete),
                        icon: const Icon(Icons.verified_outlined),
                        label: Text(l10n.stayCompleted),
                      ),
                    if (b.status == BookingStatus.accepted)
                      OutlinedButton.icon(
                        onPressed: _busy ? null : () => _act(BookingAction.cancel, askNote: true, noteRequired: true),
                        icon: const Icon(Icons.event_busy),
                        label: Text(l10n.cancelBooking),
                      ),
                  ],
                ),
                if (b.commissionAmount != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    l10n.commissionDueFor(b.commissionAmount!.format()),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
                const SizedBox(height: 24),
                Conversation(
                  thread: Thread.booking,
                  id: b.id,
                  role: 'hotel',
                  enabled: b.status != BookingStatus.expired,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Saisie d'un message pour le client (motif, question).
Future<String?> _askMessage(BuildContext context, {required String title, required bool required}) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController();
  final result = await showDialog<String>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: Text(title),
        content: SizedBox(
          width: 420,
          child: TextField(
            controller: controller,
            autofocus: true,
            maxLines: 3,
            maxLength: 1000,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(labelText: required ? l10n.messageForClient : l10n.messageForClientOptional),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
          FilledButton(
            onPressed: required && controller.text.trim().isEmpty
                ? null
                : () => Navigator.pop(context, controller.text.trim()),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    ),
  );
  controller.dispose();
  return result;
}

/// Demandes de contact et de visite reçues (immobilier).
class ProLeadsScreen extends ConsumerStatefulWidget {
  const ProLeadsScreen({super.key, required this.orgId});

  final String orgId;

  @override
  ConsumerState<ProLeadsScreen> createState() => _ProLeadsScreenState();
}

class _ProLeadsScreenState extends ConsumerState<ProLeadsScreen> {
  LeadStatus? _status = LeadStatus.fresh;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final leads = ref.watch(orgLeadsProvider(widget.orgId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.receivedLeads)),
      body: Readable(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            FilterChipsBar<LeadStatus?>(
              values: [...LeadStatus.values, null],
              selected: _status,
              label: (s) => s == null ? l10n.all : s.label(l10n),
              onSelected: (s) => setState(() => _status = s),
            ),
            Expanded(
              child: leads.when(
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text(l10n.genericError)),
                data: (items) {
                  final shown = items.where((l) => _status == null || l.status == _status).toList();
                  if (shown.isEmpty) return EmptyState(icon: Icons.inbox_outlined, title: l10n.noRequestHere);
                  return ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      CardList(
                        indent: 72,
                        children: [
                          for (final lead in shown)
                            RequestRow(
                              icon: lead.type.icon,
                              color: lead.status.color(scheme),
                              title: '${lead.clientSnapshot.name} · ${lead.type.label(l10n)}',
                              status: lead.status.label(l10n),
                              lines: [
                                '${lead.targetTitle}${lead.unitLabel == null ? '' : ' · ${l10n.unitLabel(lead.unitLabel!)}'}',
                                if (lead.createdAt != null) dateTimeFormat.format(lead.createdAt!),
                              ],
                              onTap: () => context.push('/pro/${widget.orgId}/contacts/${lead.id}'),
                            ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Une demande de contact ou de visite, côté pro : suivi et discussion.
class ProLeadDetailScreen extends ConsumerWidget {
  const ProLeadDetailScreen({super.key, required this.orgId, required this.leadId});

  final String orgId;
  final String leadId;

  Future<void> _setStatus(BuildContext context, WidgetRef ref, LeadStatus status) async {
    DateTime? visitAt;
    if (status == LeadStatus.visitScheduled) {
      final now = DateTime.now();
      final day = await showDatePicker(context: context, firstDate: now, lastDate: now.add(const Duration(days: 180)));
      if (day == null || !context.mounted) return;
      final time = await showTimePicker(context: context, initialTime: const TimeOfDay(hour: 10, minute: 0));
      if (time == null) return;
      visitAt = DateTime(day.year, day.month, day.day, time.hour, time.minute);
    }
    try {
      await ref.read(requestsRepositoryProvider).updateLead(leadId, status, visitAt: visitAt);
    } catch (e) {
      if (context.mounted) showResult(context, functionErrorMessage(e), error: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final lead = ref.watch(leadProvider(leadId));
    return Scaffold(
      appBar: AppBar(title: Text(l10n.contactRequest)),
      body: lead.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (lead) {
          if (lead == null) return EmptyState(icon: Icons.search_off, title: l10n.requestNotFound);
          final phone = lead.clientSnapshot.phone;
          return Readable(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                ClientCard(
                  name: lead.clientSnapshot.name,
                  subtitle: [
                    lead.type.label(l10n),
                    if (lead.clientSnapshot.email != null) lead.clientSnapshot.email!,
                  ].join(' · '),
                  trailing: StatusPill(lead.status.label(l10n), lead.status.color(scheme)),
                  actions: [
                    if (phone != null) ...[
                      OutlinedButton.icon(
                        onPressed: () => callPhone(phone),
                        icon: const Icon(Icons.call_outlined),
                        label: Text(l10n.call),
                      ),
                      OutlinedButton.icon(
                        onPressed: () => openWhatsApp(phone, text: l10n.whatsappLeadText(lead.targetTitle)),
                        icon: const Icon(Icons.chat_outlined),
                        label: const Text('WhatsApp'),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 12),
                SectionCard(
                  margin: EdgeInsets.zero,
                  children: [
                    InfoRow(
                      Icons.home_work_outlined,
                      [lead.targetTitle, if (lead.unitLabel != null) l10n.unitLabel(lead.unitLabel!)].join(' · '),
                    ),
                    InfoRow(Icons.notes, lead.message),
                    if (lead.preferredDates.isNotEmpty)
                      InfoRow(Icons.schedule, l10n.preferredDatesValue(lead.preferredDates)),
                    if (lead.visitAt != null)
                      InfoRow(Icons.event, l10n.visitPlanned(dateTimeFormat.format(lead.visitAt!))),
                    if (phone != null) InfoRow(Icons.call_outlined, phone, onTap: () => callPhone(phone)),
                  ],
                ),
                const SizedBox(height: 14),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (lead.status == LeadStatus.fresh)
                      FilledButton(
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                        onPressed: () => _setStatus(context, ref, LeadStatus.inProgress),
                        child: Text(l10n.takeCharge),
                      ),
                    if (lead.status != LeadStatus.closed)
                      OutlinedButton.icon(
                        onPressed: () => _setStatus(context, ref, LeadStatus.visitScheduled),
                        icon: const Icon(Icons.event_available),
                        label: Text(lead.visitAt == null ? l10n.scheduleVisit : l10n.changeVisit),
                      ),
                    if (lead.status != LeadStatus.closed)
                      OutlinedButton(
                        onPressed: () => _setStatus(context, ref, LeadStatus.closed),
                        child: Text(l10n.closeRequest),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                Conversation(thread: Thread.lead, id: lead.id, role: 'pro', enabled: lead.status != LeadStatus.closed),
              ],
            ),
          );
        },
      ),
    );
  }
}
