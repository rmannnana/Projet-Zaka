import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/money.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../auth/data/auth_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import '../../requests/data/requests_repository.dart';

/// Ouvre le formulaire de demande de réservation (connexion demandée si besoin).
Future<void> showBookingSheet(
  BuildContext context,
  WidgetRef ref, {
  required Hotel hotel,
  required RoomType room,
  required List<HotelOffer> offers,
  DateTime? checkIn,
  DateTime? checkOut,
  int? guests,
}) async {
  if (ref.read(authStateProvider).value == null) {
    context.push('/connexion?retour=${Uri.encodeComponent('/hotel/${hotel.id}')}');
    return;
  }
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _BookingSheet(
      hotel: hotel,
      room: room,
      offers: offers,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
    ),
  );
}

class _BookingSheet extends ConsumerStatefulWidget {
  const _BookingSheet({
    required this.hotel,
    required this.room,
    required this.offers,
    this.checkIn,
    this.checkOut,
    this.guests,
  });

  final Hotel hotel;
  final RoomType room;
  final List<HotelOffer> offers;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;

  @override
  ConsumerState<_BookingSheet> createState() => _BookingSheetState();
}

class _BookingSheetState extends ConsumerState<_BookingSheet> {
  late DateTimeRange? _dates = widget.checkIn != null && widget.checkOut != null
      ? DateTimeRange(start: widget.checkIn!, end: widget.checkOut!)
      : null;
  late int _adults = (widget.guests ?? 1).clamp(1, widget.room.capacityAdults * widget.room.quantity);
  int _children = 0;
  int _rooms = 1;
  final _message = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  int get _nights => _dates == null ? 0 : _dates!.end.difference(_dates!.start).inDays;

  Future<void> _pickDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
      initialDateRange: _dates,
    );
    if (picked != null) setState(() => _dates = picked);
  }

  Future<void> _send() async {
    final l10n = AppLocalizations.of(context);
    if (_dates == null || _nights < 1) {
      setState(() => _error = l10n.chooseYourDates);
      return;
    }
    setState(() {
      _sending = true;
      _error = null;
    });
    try {
      final result = await ref.read(requestsRepositoryProvider).createBooking(
        hotelId: widget.hotel.id,
        roomTypeId: widget.room.id,
        checkIn: _dates!.start,
        checkOut: _dates!.end,
        adults: _adults,
        children: _children,
        rooms: _rooms,
        message: _message.text,
      );
      if (!mounted) return;
      final router = GoRouter.of(context);
      Navigator.pop(context);
      await showDialog<void>(
        context: router.routerDelegate.navigatorKey.currentContext!,
        builder: (context) => AlertDialog(
          icon: Icon(Icons.mark_email_read_outlined, color: Colors.green.shade700, size: 48),
          title: Text(l10n.bookingSentTitle),
          content: Text(l10n.bookingSentBody(widget.hotel.name, dateTimeFormat.format(result.expiresAt))),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.close)),
            FilledButton(
              onPressed: () {
                Navigator.pop(context);
                router.push('/reservations/${result.id}');
              },
              child: Text(l10n.seeMyRequest),
            ),
          ],
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
    final room = widget.room;
    final offer = _dates == null ? null : bestOffer(widget.offers, room.id, _dates!.start);
    final total = _nights < 1
        ? null
        : Money((room.pricePerNight.amount * _nights * _rooms * (1 - (offer?.discountPercent ?? 0) / 100)).round());

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
                Text(l10n.bookingRequestTitle, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
                Text('${widget.hotel.name} · ${room.name}'),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(minimumSize: const Size.fromHeight(52)),
                  onPressed: _pickDates,
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _dates == null
                        ? l10n.chooseDates
                        : '${shortDate.format(_dates!.start)} → ${shortDate.format(_dates!.end)} · ${l10n.nightsCount(_nights)}',
                  ),
                ),
                const SizedBox(height: 12),
                CountStepper(
                  label: l10n.adults,
                  value: _adults,
                  min: 1,
                  max: room.capacityAdults * _rooms,
                  onChanged: (v) => setState(() => _adults = v),
                ),
                CountStepper(
                  label: l10n.children,
                  value: _children,
                  max: room.capacity * _rooms - _adults,
                  onChanged: (v) => setState(() => _children = v),
                ),
                CountStepper(
                  label: l10n.roomsCount,
                  value: _rooms,
                  min: 1,
                  max: room.quantity,
                  onChanged: (v) => setState(() => _rooms = v),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _message,
                  maxLines: 3,
                  maxLength: 1000,
                  decoration: InputDecoration(labelText: l10n.messageToHotel, hintText: l10n.messageToHotelHint),
                ),
                if (total != null)
                  Card.filled(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text(l10n.estimatedTotal),
                      subtitle: Text([
                        l10n.estimateDetail(room.pricePerNight.format(), _nights, _rooms),
                        if (offer != null) '${offer.title} : −${offer.discountPercent} %',
                      ].join('\n')),
                      trailing: Text(
                        total.format(),
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
                Text(l10n.bookingRequestNotice, style: theme.textTheme.bodySmall),
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
