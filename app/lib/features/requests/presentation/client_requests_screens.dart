import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import '../data/requests_repository.dart';
import '../domain/requests.dart';
import 'conversation.dart';

/// « Mes demandes » : réservations d'hôtel et demandes de contact du client.
class MyRequestsScreen extends ConsumerWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navRequests),
          bottom: PillTabBar(labels: [l10n.bookings, l10n.contactRequests]),
        ),
        body: const TabBarView(children: [_MyBookings(), _MyLeads()]),
      ),
    );
  }
}

class _MyBookings extends ConsumerWidget {
  const _MyBookings();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ref
        .watch(myBookingsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.genericError)),
          data: (items) => items.isEmpty
              ? EmptyState(
                  icon: Icons.hotel_outlined,
                  title: l10n.noBookingYet,
                  body: l10n.noBookingYetHint,
                  action: FilledButton.tonal(onPressed: () => context.go('/hotels'), child: Text(l10n.findHotel)),
                )
              : Readable(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      CardList(
                        indent: 86,
                        children: [
                          for (final b in items)
                            RequestRow(
                              leading: _Thumb(b.hotelPhoto, Icons.hotel),
                              icon: Icons.hotel,
                              color: b.status.color(scheme),
                              title: b.hotelName,
                              status: b.status.label(l10n),
                              lines: [
                                b.roomTypeName,
                                if (b.checkIn != null && b.checkOut != null)
                                  '${shortDate.format(b.checkIn!)} → ${shortDate.format(b.checkOut!)}',
                              ],
                              onTap: () => context.push('/reservations/${b.id}'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
  }
}

class _MyLeads extends ConsumerWidget {
  const _MyLeads();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return ref
        .watch(myLeadsProvider)
        .when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text(l10n.genericError)),
          data: (items) => items.isEmpty
              ? EmptyState(
                  icon: Icons.home_work_outlined,
                  title: l10n.noLeadYet,
                  body: l10n.noLeadYetHint,
                  action: FilledButton.tonal(
                    onPressed: () => context.go('/immobilier'),
                    child: Text(l10n.findProperty),
                  ),
                )
              : Readable(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                    children: [
                      CardList(
                        indent: 86,
                        children: [
                          for (final lead in items)
                            RequestRow(
                              leading: _Thumb(lead.targetPhoto, Icons.home_work_outlined),
                              icon: Icons.home_work_outlined,
                              color: lead.status.color(scheme),
                              title: lead.targetTitle,
                              status: lead.status.label(l10n),
                              lines: [
                                [lead.type.label(l10n), if (lead.orgName != null) lead.orgName!].join(' · '),
                              ],
                              onTap: () => context.push('/contacts/${lead.id}'),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
        );
  }
}

/// Explication du statut d'une réservation, côté client.
String bookingStatusHelp(AppLocalizations l10n, BookingRequest b) => switch (b.status) {
  BookingStatus.pending => l10n.bookingPendingHelp(b.expiresAt == null ? '' : dateTimeFormat.format(b.expiresAt!)),
  BookingStatus.infoRequested => l10n.bookingInfoRequestedHelp,
  BookingStatus.accepted => b.isPaid ? l10n.bookingPaidHelp : l10n.bookingAcceptedHelp,
  BookingStatus.rejected => l10n.bookingRejectedHelp,
  BookingStatus.cancelled => l10n.bookingCancelledHelp,
  BookingStatus.expired => l10n.bookingExpiredHelp,
  BookingStatus.completed => l10n.bookingCompletedHelp,
};

/// Détail d'une réservation pour le client : statut, récapitulatif, paiement, discussion.
class BookingDetailScreen extends ConsumerStatefulWidget {
  const BookingDetailScreen({super.key, required this.bookingId});

  final String bookingId;

  @override
  ConsumerState<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends ConsumerState<BookingDetailScreen> {
  bool _busy = false;

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(functionErrorMessage(e))));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _cancel() async {
    final l10n = AppLocalizations.of(context);
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.cancelBookingTitle),
        content: Text(l10n.cancelBookingBody),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.keepBooking)),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l10n.cancelBooking)),
        ],
      ),
    );
    if (ok == true) {
      await _run(() => ref.read(requestsRepositoryProvider).updateBooking(widget.bookingId, BookingAction.cancel));
    }
  }

  Future<void> _pay() => _run(() async {
    final paymentId = await ref.read(requestsRepositoryProvider).startBookingPayment(widget.bookingId);
    if (mounted) {
      context.push('/paiement/$paymentId?retour=${Uri.encodeComponent('/reservations/${widget.bookingId}')}');
    }
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final booking = ref.watch(bookingProvider(widget.bookingId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bookingRequest)),
      body: booking.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(l10n.genericError)),
        data: (b) {
          if (b == null) return EmptyState(icon: Icons.search_off, title: l10n.requestNotFound);
          final canCancel = b.status.isOpen || b.status == BookingStatus.accepted;
          return Readable(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                BookingStatusCard(status: b.status, help: bookingStatusHelp(l10n, b)),
                const SizedBox(height: 12),
                BookingSummaryCard(booking: b, onOpenHotel: () => context.push('/hotel/${b.hotelId}')),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (b.canPay)
                      FilledButton.icon(
                        style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                        onPressed: _busy ? null : _pay,
                        icon: const Icon(Icons.payment),
                        label: Text(l10n.payOnline),
                      ),
                    if (canCancel)
                      OutlinedButton.icon(
                        onPressed: _busy ? null : _cancel,
                        icon: const Icon(Icons.close),
                        label: Text(l10n.cancelBooking),
                      ),
                  ],
                ),
                if (b.canPay) ...[
                  const SizedBox(height: 4),
                  Text(l10n.payAtHotelNotice, style: theme.textTheme.bodySmall),
                ],
                const SizedBox(height: 24),
                Conversation(
                  thread: Thread.booking,
                  id: b.id,
                  role: 'client',
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

/// Bandeau de statut d'une réservation.
class BookingStatusCard extends StatelessWidget {
  const BookingStatusCard({super.key, required this.status, required this.help});

  final BookingStatus status;
  final String help;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final color = status.color(Theme.of(context).colorScheme);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(ZakaRadius.card),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTile(icon: status.icon, background: color.withValues(alpha: 0.14), foreground: color, size: 44),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  status.label(l10n),
                  style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 16),
                ),
                const SizedBox(height: 2),
                Text(help, style: const TextStyle(height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Récapitulatif d'une réservation (client et hôtel).
class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({super.key, required this.booking, this.onOpenHotel});

  final BookingRequest booking;
  final VoidCallback? onOpenHotel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final b = booking;
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            leading: _Thumb(b.hotelPhoto, Icons.hotel),
            title: Text(b.hotelName, style: const TextStyle(fontWeight: FontWeight.w800)),
            subtitle: Text([b.roomTypeName, if (b.hotelCity != null) b.hotelCity!].join(' · ')),
            trailing: onOpenHotel == null ? null : const Icon(Icons.chevron_right),
            onTap: onOpenHotel,
          ),
          Divider(height: 1, color: ZakaPalette.of(context).line),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (b.checkIn != null && b.checkOut != null)
                  InfoRow(
                    Icons.date_range,
                    '${longDate.format(b.checkIn!)} → ${longDate.format(b.checkOut!)} · ${l10n.nightsCount(b.nights)}',
                  ),
                InfoRow(Icons.people_outline, l10n.guestsSummary(b.adults, b.children, b.rooms)),
                if (b.message.isNotEmpty) InfoRow(Icons.notes, b.message),
                if (b.offerTitle != null)
                  InfoRow(Icons.local_offer_outlined, '${b.offerTitle} : −${b.discountPercent} %'),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: Text(l10n.estimatedTotal)),
                    Text(
                      b.estimatedTotal.format(),
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                if (b.isPaid)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(l10n.paidSimulated, style: TextStyle(color: ZakaColors.success)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Détail d'une demande de contact ou de visite pour le client.
class LeadDetailScreen extends ConsumerWidget {
  const LeadDetailScreen({super.key, required this.leadId});

  final String leadId;

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
          return Readable(
            maxWidth: 760,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAlias,
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    leading: _Thumb(lead.targetPhoto, Icons.home_work_outlined),
                    title: Text(lead.targetTitle, style: const TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: Text(
                      [
                        lead.type.label(l10n),
                        if (lead.unitLabel != null) l10n.unitLabel(lead.unitLabel!),
                        lead.orgName ?? '',
                      ].join(' · '),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(
                      lead.targetType == 'project' ? '/programme/${lead.targetId}' : '/bien/${lead.targetId}',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SectionCard(
                  margin: EdgeInsets.zero,
                  children: [
                    Row(children: [StatusPill(lead.status.label(l10n), lead.status.color(scheme))]),
                    const SizedBox(height: 6),
                    if (lead.visitAt != null)
                      InfoRow(Icons.event, l10n.visitPlanned(dateTimeFormat.format(lead.visitAt!))),
                    InfoRow(Icons.notes, lead.message),
                    if (lead.preferredDates.isNotEmpty) InfoRow(Icons.schedule, lead.preferredDates),
                  ],
                ),
                const SizedBox(height: 24),
                Conversation(
                  thread: Thread.lead,
                  id: lead.id,
                  role: 'client',
                  enabled: lead.status != LeadStatus.closed,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Petite photo arrondie d'un hôtel ou d'un bien.
class _Thumb extends StatelessWidget {
  const _Thumb(this.url, this.icon);

  final String? url;
  final IconData icon;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(ZakaRadius.small + 2),
    child: SizedBox(width: 60, height: 60, child: NetImage(url, icon: icon)),
  );
}
