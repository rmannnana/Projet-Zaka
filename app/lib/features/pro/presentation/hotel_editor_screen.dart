import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../core/money.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../organizations/data/organization_repository.dart';
import 'editor_widgets.dart';

/// Gestion d'une fiche hôtel : informations, photos, chambres, offres, disponibilités.
class HotelEditorScreen extends ConsumerWidget {
  const HotelEditorScreen({super.key, required this.orgId, required this.hotelId});

  final String orgId;
  final String hotelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final hotel = ref.watch(hotelProvider(hotelId)).value;
    if (hotel == null) return const Scaffold(body: Center(child: CircularProgressIndicator()));
    final scheme = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text(hotel.name.isEmpty ? l10n.untitledHotel : hotel.name),
          actions: [
            Center(child: StatusPill(hotel.status.label(l10n), hotel.status.color(scheme))),
            const SizedBox(width: 8),
            if (hotel.status.canPublish)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
                  onPressed: () async {
                    try {
                      await ref.read(listingsRepositoryProvider).publish(ListingKind.hotel, hotelId);
                      if (context.mounted) showResult(context, l10n.publishedNow);
                    } catch (e) {
                      if (context.mounted) showResult(context, functionErrorMessage(e), error: true);
                    }
                  },
                  child: Text(l10n.publish),
                ),
              ),
          ],
          bottom: PillTabBar(
            scrollable: true,
            labels: [l10n.tabInfo, l10n.tabPhotos, l10n.rooms, l10n.tabOffers, l10n.tabAvailability],
          ),
        ),
        body: TabBarView(
          children: [
            _HotelInfoTab(hotel: hotel),
            Readable(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: FormSection(
                  title: l10n.tabPhotos,
                  children: [
                    PhotosEditor(
                      orgId: orgId,
                      listingId: hotelId,
                      photos: hotel.photos,
                      onChanged: (photos) =>
                          ref.read(listingsRepositoryProvider).update(ListingKind.hotel, hotelId, {'photos': photos}),
                    ),
                  ],
                ),
              ),
            ),
            _RoomsTab(hotelId: hotelId),
            _OffersTab(hotelId: hotelId),
            _AvailabilityTab(hotelId: hotelId),
          ],
        ),
      ),
    );
  }
}

class _HotelInfoTab extends ConsumerStatefulWidget {
  const _HotelInfoTab({required this.hotel});

  final Hotel hotel;

  @override
  ConsumerState<_HotelInfoTab> createState() => _HotelInfoTabState();
}

class _HotelInfoTabState extends ConsumerState<_HotelInfoTab> {
  final _form = GlobalKey<FormState>();
  late final h = widget.hotel;
  late final _name = TextEditingController(text: h.name);
  late final _description = TextEditingController(text: h.description);
  late final _district = TextEditingController(text: h.district);
  late final _address = TextEditingController(text: h.address);
  late final _phone = TextEditingController(text: h.phone);
  late final _checkIn = TextEditingController(text: h.rules.checkIn);
  late final _checkOut = TextEditingController(text: h.rules.checkOut);
  late final _cancellation = TextEditingController(text: h.rules.cancellationPolicy);
  late final _other = TextEditingController(text: h.rules.other);
  late String _city = h.city;
  late int? _stars = h.stars;
  late bool _pets = h.rules.pets;
  late Set<String> _amenities = {...h.amenities};
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _description, _district, _address, _phone, _checkIn, _checkOut, _cancellation, _other]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref.read(listingsRepositoryProvider).update(ListingKind.hotel, h.id, {
        'name': _name.text.trim(),
        'description': _description.text.trim(),
        'city': _city,
        'district': _district.text.trim(),
        'address': _address.text.trim(),
        'phone': _phone.text.trim(),
        'stars': _stars,
        'amenities': _amenities.toList(),
        'rules': HotelRules(
          checkIn: _checkIn.text.trim(),
          checkOut: _checkOut.text.trim(),
          pets: _pets,
          cancellationPolicy: _cancellation.text.trim(),
          other: _other.text.trim(),
        ).toJson(),
      });
      if (mounted) showResult(context, l10n.saved);
    } catch (e) {
      if (mounted) showResult(context, functionErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Form(
      key: _form,
      child: Readable(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FormSection(
              title: l10n.hotelIdentity,
              children: [
                TextFormField(
                  controller: _name,
                  maxLength: 120,
                  decoration: InputDecoration(labelText: l10n.hotelName),
                  validator: (v) => (v ?? '').trim().length < 2 ? l10n.requiredField : null,
                ),
                DropdownButtonFormField<int?>(
                  initialValue: _stars,
                  decoration: InputDecoration(labelText: l10n.stars),
                  items: [
                    DropdownMenuItem(value: null, child: Text(l10n.notRated)),
                    for (var i = 1; i <= 5; i++) DropdownMenuItem(value: i, child: Text('★' * i)),
                  ],
                  onChanged: (v) => setState(() => _stars = v),
                ),
                TextFormField(
                  controller: _description,
                  maxLines: 5,
                  maxLength: 5000,
                  decoration: InputDecoration(labelText: l10n.description, alignLabelWithHint: true),
                ),
              ],
            ),
            FormSection(
              title: l10n.location,
              children: [
                FieldRow(
                  children: [
                    CityFormField(value: _city, onChanged: (v) => setState(() => _city = v)),
                    TextFormField(
                      controller: _district,
                      decoration: InputDecoration(labelText: l10n.district),
                    ),
                  ],
                ),
                TextFormField(
                  controller: _address,
                  decoration: InputDecoration(labelText: l10n.address),
                ),
                TextFormField(
                  controller: _phone,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(labelText: l10n.receptionPhone),
                ),
              ],
            ),
            FormSection(
              title: l10n.amenities,
              children: [
                AmenitySelector(
                  selected: _amenities,
                  forHotels: true,
                  onChanged: (v) => setState(() => _amenities = v),
                ),
              ],
            ),
            FormSection(
              title: l10n.hotelRules,
              children: [
                FieldRow(
                  children: [
                    TextFormField(
                      controller: _checkIn,
                      decoration: InputDecoration(labelText: l10n.checkInTime, hintText: '14:00'),
                    ),
                    TextFormField(
                      controller: _checkOut,
                      decoration: InputDecoration(labelText: l10n.checkOutTime, hintText: '12:00'),
                    ),
                  ],
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.petsAllowed),
                  value: _pets,
                  onChanged: (v) => setState(() => _pets = v),
                ),
                TextFormField(
                  controller: _cancellation,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: l10n.cancellationPolicyLabel,
                    hintText: l10n.cancellationPolicyHint,
                  ),
                ),
                TextFormField(
                  controller: _other,
                  maxLines: 2,
                  decoration: InputDecoration(labelText: l10n.otherRules),
                ),
              ],
            ),
            FilledButton(onPressed: _saving ? null : _save, child: Text(l10n.save)),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _RoomsTab extends ConsumerWidget {
  const _RoomsTab({required this.hotelId});

  final String hotelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rooms = ref.watch(roomTypesProvider(hotelId)).value ?? const <RoomType>[];
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'room',
        onPressed: () => _edit(context, ref, null),
        icon: const Icon(Icons.add),
        label: Text(l10n.addRoomType),
      ),
      body: rooms.isEmpty
          ? EmptyState(icon: Icons.bed_outlined, title: l10n.noRoomTypeYet, body: l10n.noRoomTypeYetHint)
          : Readable(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  for (final r in rooms)
                    Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        leading: ToneIcon(
                          r.active ? Icons.bed : Icons.bed_outlined,
                          tone: r.active ? Tone.mint : Tone.neutral,
                        ),
                        title: Text(r.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                        subtitle: Text(
                          [
                            l10n.pricePerNight(r.pricePerNight.format()),
                            l10n.roomCapacity(r.capacityAdults, r.capacityChildren),
                            l10n.roomQuantity(r.quantity),
                            if (!r.active) l10n.inactiveRoom,
                          ].join(' · '),
                        ),
                        trailing: const Icon(Icons.edit_outlined),
                        onTap: () => _edit(context, ref, r),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, RoomType? room) => showDialog<void>(
    context: context,
    builder: (_) => _RoomDialog(hotelId: hotelId, room: room),
  );
}

class _RoomDialog extends ConsumerStatefulWidget {
  const _RoomDialog({required this.hotelId, this.room});

  final String hotelId;
  final RoomType? room;

  @override
  ConsumerState<_RoomDialog> createState() => _RoomDialogState();
}

class _RoomDialogState extends ConsumerState<_RoomDialog> {
  final _form = GlobalKey<FormState>();
  late final r = widget.room ?? const RoomType();
  late final _name = TextEditingController(text: r.name);
  late final _description = TextEditingController(text: r.description);
  late final _beds = TextEditingController(text: r.beds);
  late final _price = TextEditingController(text: r.pricePerNight.amount == 0 ? '' : '${r.pricePerNight.amount}');
  late final _adults = TextEditingController(text: '${r.capacityAdults}');
  late final _children = TextEditingController(text: '${r.capacityChildren}');
  late final _quantity = TextEditingController(text: '${r.quantity}');
  late bool _active = r.active;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _description, _beds, _price, _adults, _children, _quantity]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(listingsRepositoryProvider)
          .saveRoomType(
            widget.hotelId,
            RoomType(
              name: _name.text.trim(),
              description: _description.text.trim(),
              beds: _beds.text.trim(),
              pricePerNight: Money(intOf(_price) ?? 0),
              capacityAdults: intOf(_adults) ?? 1,
              capacityChildren: intOf(_children) ?? 0,
              quantity: intOf(_quantity) ?? 1,
              active: _active,
              photos: r.photos,
              amenities: r.amenities,
            ).toJson(),
            id: widget.room?.id,
          );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) showResult(context, functionErrorMessage(e), error: true);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _delete() async {
    await ref.read(listingsRepositoryProvider).deleteRoomType(widget.hotelId, widget.room!.id);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.room == null ? l10n.addRoomType : l10n.editRoomType),
      content: SizedBox(
        width: 480,
        child: Form(
          key: _form,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: InputDecoration(labelText: l10n.roomTypeName, hintText: l10n.roomTypeNameHint),
                  validator: (v) => (v ?? '').trim().isEmpty ? l10n.requiredField : null,
                ),
                const SizedBox(height: 12),
                IntField(controller: _price, label: l10n.pricePerNightLabel, suffix: 'FCFA', required: true),
                const SizedBox(height: 12),
                FieldRow(
                  children: [
                    IntField(controller: _adults, label: l10n.adults, required: true),
                    IntField(controller: _children, label: l10n.children),
                  ],
                ),
                const SizedBox(height: 12),
                FieldRow(
                  children: [
                    IntField(controller: _quantity, label: l10n.roomsOfThisType, required: true),
                    TextFormField(
                      controller: _beds,
                      decoration: InputDecoration(labelText: l10n.beds, hintText: l10n.bedsHint),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _description,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: l10n.description),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.roomActive),
                  value: _active,
                  onChanged: (v) => setState(() => _active = v),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        if (widget.room != null) TextButton(onPressed: _saving ? null : _delete, child: Text(l10n.delete)),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          onPressed: _saving ? null : _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

class _OffersTab extends ConsumerWidget {
  const _OffersTab({required this.hotelId});

  final String hotelId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final offers = ref.watch(offersProvider(hotelId)).value ?? const <HotelOffer>[];
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'offer',
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => _OfferDialog(hotelId: hotelId),
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.addOffer),
      ),
      body: offers.isEmpty
          ? EmptyState(icon: Icons.local_offer_outlined, title: l10n.noOfferYet, body: l10n.noOfferYetHint)
          : Readable(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
                children: [
                  for (final o in offers)
                    Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                        leading: ToneIcon(Icons.local_offer_outlined, tone: o.active ? Tone.peach : Tone.neutral),
                        title: Text(
                          '${o.title} · −${o.discountPercent} %',
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                        subtitle: Text(
                          [
                            if (o.validFrom != null && o.validTo != null)
                              '${shortDate.format(o.validFrom!)} → ${shortDate.format(o.validTo!.subtract(const Duration(days: 1)))}',
                            if (!o.active) l10n.inactiveOffer,
                          ].join(' · '),
                        ),
                        trailing: const Icon(Icons.edit_outlined),
                        onTap: () => showDialog<void>(
                          context: context,
                          builder: (_) => _OfferDialog(hotelId: hotelId, offer: o),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }
}

class _OfferDialog extends ConsumerStatefulWidget {
  const _OfferDialog({required this.hotelId, this.offer});

  final String hotelId;
  final HotelOffer? offer;

  @override
  ConsumerState<_OfferDialog> createState() => _OfferDialogState();
}

class _OfferDialogState extends ConsumerState<_OfferDialog> {
  late final o = widget.offer ?? const HotelOffer();
  late final _title = TextEditingController(text: o.title);
  late final _description = TextEditingController(text: o.description);
  late final _discount = TextEditingController(text: o.discountPercent == 0 ? '' : '${o.discountPercent}');
  late DateTimeRange? _period = o.validFrom != null && o.validTo != null
      ? DateTimeRange(start: o.validFrom!, end: o.validTo!.subtract(const Duration(days: 1)))
      : null;
  late final Set<String> _rooms = {...o.roomTypeIds};
  late bool _active = o.active;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _discount.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final discount = intOf(_discount) ?? 0;
    if (_title.text.trim().isEmpty || discount <= 0 || discount >= 100 || _period == null) {
      setState(() => _error = l10n.offerIncomplete);
      return;
    }
    DateTime utc(DateTime d) => DateTime.utc(d.year, d.month, d.day);
    await ref
        .read(listingsRepositoryProvider)
        .saveOffer(
          widget.hotelId,
          HotelOffer(
            title: _title.text.trim(),
            description: _description.text.trim(),
            discountPercent: discount,
            roomTypeIds: _rooms.toList(),
            validFrom: utc(_period!.start),
            // Fin exclue : le lendemain du dernier jour choisi.
            validTo: utc(_period!.end).add(const Duration(days: 1)),
            active: _active,
          ).toJson(),
          id: widget.offer?.id,
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rooms = ref.watch(roomTypesProvider(widget.hotelId)).value ?? const <RoomType>[];
    return AlertDialog(
      title: Text(widget.offer == null ? l10n.addOffer : l10n.editOffer),
      content: SizedBox(
        width: 480,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _title,
                decoration: InputDecoration(labelText: l10n.offerTitle, hintText: l10n.offerTitleHint),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _discount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(labelText: l10n.discount, suffixText: '%'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(now.year, now.month, now.day),
                    lastDate: now.add(const Duration(days: 730)),
                    initialDateRange: _period,
                  );
                  if (picked != null) setState(() => _period = picked);
                },
                icon: const Icon(Icons.date_range),
                label: Text(
                  _period == null
                      ? l10n.offerPeriod
                      : '${shortDate.format(_period!.start)} → ${shortDate.format(_period!.end)}',
                ),
              ),
              const SizedBox(height: 12),
              Text(l10n.offerRooms, style: Theme.of(context).textTheme.bodySmall),
              Wrap(
                spacing: 8,
                children: [
                  for (final r in rooms)
                    FilterChip(
                      label: Text(r.name),
                      selected: _rooms.contains(r.id),
                      onSelected: (v) => setState(() => v ? _rooms.add(r.id) : _rooms.remove(r.id)),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _description,
                maxLines: 2,
                decoration: InputDecoration(labelText: l10n.description),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.offerActive),
                value: _active,
                onChanged: (v) => setState(() => _active = v),
              ),
              if (_error != null) Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ],
          ),
        ),
      ),
      actions: [
        if (widget.offer != null)
          TextButton(
            onPressed: () async {
              await ref.read(listingsRepositoryProvider).deleteOffer(widget.hotelId, widget.offer!.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.delete),
          ),
        TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(minimumSize: const Size(0, 40)),
          onPressed: _save,
          child: Text(l10n.save),
        ),
      ],
    );
  }
}

/// Calendrier des disponibilités déclarées, par type de chambre et par mois.
class _AvailabilityTab extends ConsumerStatefulWidget {
  const _AvailabilityTab({required this.hotelId});

  final String hotelId;

  @override
  ConsumerState<_AvailabilityTab> createState() => _AvailabilityTabState();
}

class _AvailabilityTabState extends ConsumerState<_AvailabilityTab> {
  String? _roomId;
  late DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  String get _monthKey => '${_month.year}-${_month.month.toString().padLeft(2, '0')}';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final rooms = ref.watch(roomTypesProvider(widget.hotelId)).value ?? const <RoomType>[];
    if (rooms.isEmpty) return EmptyState(icon: Icons.calendar_month, title: l10n.noRoomTypeYet);
    final room = rooms.firstWhere((r) => r.id == _roomId, orElse: () => rooms.first);
    final days =
        ref.watch(availabilityProvider((hotelId: widget.hotelId, roomTypeId: room.id, month: _monthKey))).value ??
        const {};
    final daysInMonth = DateTime(_month.year, _month.month + 1, 0).day;
    final offset = DateTime(_month.year, _month.month).weekday - 1;
    final today = DateTime.now();
    final repo = ref.read(listingsRepositoryProvider);

    Future<void> setDays(Map<String, int> updated) =>
        repo.saveAvailability(widget.hotelId, room.id, _monthKey, updated);

    Future<void> editDay(int day) async {
      final key = day.toString().padLeft(2, '0');
      var value = days[key] ?? room.quantity;
      final result = await showDialog<int?>(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(longDate.format(DateTime(_month.year, _month.month, day))),
            content: CountStepper(
              label: l10n.roomsAvailable,
              value: value,
              max: room.quantity,
              onChanged: (v) => setState(() => value = v),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(context, -1), child: Text(l10n.resetDay)),
              FilledButton(onPressed: () => Navigator.pop(context, value), child: Text(l10n.save)),
            ],
          ),
        ),
      );
      if (result == null) return;
      final updated = {...days};
      if (result == -1 || result == room.quantity) {
        updated.remove(key);
      } else {
        updated[key] = result;
      }
      await setDays(updated);
    }

    return Readable(
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          PageIntro(text: l10n.availabilityHelp, padding: const EdgeInsets.only(bottom: 12)),
          DropdownButtonFormField<String>(
            initialValue: room.id,
            decoration: InputDecoration(labelText: l10n.roomTypeName),
            items: [for (final r in rooms) DropdownMenuItem(value: r.id, child: Text(r.name))],
            onChanged: (v) => setState(() => _roomId = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              IconButton(
                onPressed: _month.isAfter(DateTime(today.year, today.month))
                    ? () => setState(() => _month = DateTime(_month.year, _month.month - 1))
                    : null,
                icon: const Icon(Icons.chevron_left),
              ),
              Expanded(
                child: Text(
                  DateFormat.yMMMM('fr').format(_month),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium,
                ),
              ),
              IconButton(
                onPressed: () => setState(() => _month = DateTime(_month.year, _month.month + 1)),
                icon: const Icon(Icons.chevron_right),
              ),
            ],
          ),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1,
            children: [
              for (final d in const ['L', 'M', 'M', 'J', 'V', 'S', 'D'])
                Center(child: Text(d, style: theme.textTheme.labelMedium)),
              for (var i = 0; i < offset; i++) const SizedBox.shrink(),
              for (var day = 1; day <= daysInMonth; day++)
                Builder(
                  builder: (context) {
                    final date = DateTime(_month.year, _month.month, day);
                    final past = date.isBefore(DateTime(today.year, today.month, today.day));
                    final declared = days[day.toString().padLeft(2, '0')];
                    final free = declared ?? room.quantity;
                    final palette = ZakaPalette.of(context);
                    final color = free == 0
                        ? theme.colorScheme.errorContainer
                        : declared != null
                        ? palette.peach
                        : palette.mint;
                    return Padding(
                      padding: const EdgeInsets.all(2),
                      child: Material(
                        color: past ? theme.colorScheme.surfaceContainerLow : color,
                        borderRadius: BorderRadius.circular(ZakaRadius.small),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(ZakaRadius.small),
                          onTap: past ? null : () => editDay(day),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('$day', style: TextStyle(color: past ? theme.colorScheme.outline : null)),
                              if (!past)
                                Text('$free', style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton(
                onPressed: () => setDays({for (var d = 1; d <= daysInMonth; d++) d.toString().padLeft(2, '0'): 0}),
                child: Text(l10n.closeWholeMonth),
              ),
              OutlinedButton(onPressed: () => setDays({}), child: Text(l10n.openWholeMonth)),
            ],
          ),
        ],
      ),
    );
  }
}
