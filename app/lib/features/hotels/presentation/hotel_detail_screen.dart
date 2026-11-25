import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../core/catalog.dart';
import '../../../core/links.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/account_requests_repository.dart';
import '../../account/presentation/report_dialog.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/cards.dart';
import '../../listings/presentation/listing_labels.dart';
import '../../realestate/presentation/lead_sheet.dart';
import 'booking_sheet.dart';

/// Fiche d'un hôtel : photos, description, équipements, règles, offres et chambres.
class HotelDetailScreen extends ConsumerStatefulWidget {
  const HotelDetailScreen({super.key, required this.hotelId, this.checkIn, this.checkOut, this.guests});

  final String hotelId;
  final DateTime? checkIn;
  final DateTime? checkOut;
  final int? guests;

  @override
  ConsumerState<HotelDetailScreen> createState() => _HotelDetailScreenState();
}

class _HotelDetailScreenState extends ConsumerState<HotelDetailScreen> {
  final _roomsKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    ref.read(listingsRepositoryProvider).recordView(ListingKind.hotel, widget.hotelId);
  }

  void _scrollToRooms() {
    final target = _roomsKey.currentContext;
    if (target != null) {
      Scrollable.ensureVisible(target, duration: const Duration(milliseconds: 450), curve: Curves.easeOutCubic);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    final hotel = ref.watch(hotelProvider(widget.hotelId));
    final rooms = ref.watch(roomTypesProvider(widget.hotelId)).value ?? const <RoomType>[];
    final offers = ref.watch(offersProvider(widget.hotelId)).value ?? const <HotelOffer>[];
    final amenities = ref.watch(amenitiesProvider).value ?? const <Amenity>[];

    return hotel.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => ListingUnavailable(message: l10n.listingUnavailable),
      data: (h) {
        if (h == null) return ListingUnavailable(message: l10n.listingUnavailable);
        final now = DateTime.now();
        final currentOffers = offers.where((o) => o.isCurrent(now)).toList();
        final activeRooms = rooms.where((r) => r.active).toList();
        final place = placeOf(h.district, h.city);
        final specs = hotelSpecs(l10n, h);

        return Scaffold(
          bottomNavigationBar: BottomActionBar(
            price: h.priceLabel(l10n),
            actions: [
              FilledButton(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 50)),
                onPressed: _scrollToRooms,
                child: Text(l10n.seeRooms),
              ),
            ],
          ),
          body: CustomScrollView(
            slivers: [
              DetailHeader(
                photos: h.photos,
                icon: Icons.hotel,
                actions: [
                  FavoriteButton(
                    onImage: true,
                    targetId: h.id,
                    favorite: Favorite(
                      targetType: ListingKind.hotel,
                      title: h.name,
                      photo: h.cover,
                      city: h.city,
                      price: h.minPricePerNight,
                    ),
                  ),
                  ListingMoreButton(
                    onReport: () => showReportDialog(context, ref, target: ReportTarget.hotel, targetId: h.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Readable(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            TagBadge(label: l10n.badgeHotel),
                            if (h.featured) TagBadge(label: l10n.featured, tone: BadgeTone.gold),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(h.name, style: theme.textTheme.headlineSmall),
                        if (place.isNotEmpty) ...[const SizedBox(height: 4), PlaceLine(place)],
                        if (h.priceLabel(l10n) != null) ...[
                          const SizedBox(height: 10),
                          Text(
                            h.priceLabel(l10n)!,
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                        if (specs.isNotEmpty) ...[const SizedBox(height: 16), SpecsPanel(specs)],
                        for (final o in currentOffers) ...[
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: palette.peach,
                              borderRadius: BorderRadius.circular(ZakaRadius.medium),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.local_offer_outlined, color: palette.onPeach),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${o.title} · −${o.discountPercent} %',
                                        style: const TextStyle(fontWeight: FontWeight.w700),
                                      ),
                                      if (o.description.isNotEmpty) Text(o.description),
                                      if (o.validTo != null)
                                        Text(
                                          l10n.offerUntil(shortDate.format(o.validTo!)),
                                          style: theme.textTheme.bodySmall,
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const SizedBox(height: 14),
                        _ConfirmationNotice(),
                        if (h.description.isNotEmpty) ...[
                          DetailHeading(l10n.description),
                          Text(h.description),
                        ],
                        if (h.amenities.isNotEmpty) ...[
                          DetailHeading(l10n.amenities),
                          FeatureGrid([for (final id in h.amenities) (amenityIcon(id), amenities.label(id))]),
                        ],
                        DetailHeading(l10n.rooms, key: _roomsKey),
                        if (activeRooms.isEmpty) Text(l10n.noRoomAvailable),
                        for (final r in activeRooms)
                          _RoomCard(
                            room: r,
                            offers: offers,
                            checkIn: widget.checkIn,
                            onRequest: () => showBookingSheet(
                              context,
                              ref,
                              hotel: h,
                              room: r,
                              offers: offers,
                              checkIn: widget.checkIn,
                              checkOut: widget.checkOut,
                              guests: widget.guests,
                            ),
                          ),
                        DetailHeading(l10n.hotelRules),
                        if (h.rules.checkIn.isNotEmpty) InfoRow(Icons.login, l10n.checkInFrom(h.rules.checkIn)),
                        if (h.rules.checkOut.isNotEmpty) InfoRow(Icons.logout, l10n.checkOutBefore(h.rules.checkOut)),
                        InfoRow(Icons.pets, h.rules.pets ? l10n.petsAllowed : l10n.petsNotAllowed),
                        if (h.rules.cancellationPolicy.isNotEmpty)
                          InfoRow(Icons.event_busy, l10n.cancellationPolicy(h.rules.cancellationPolicy)),
                        if (h.rules.other.isNotEmpty) InfoRow(Icons.info_outline, h.rules.other),
                        DetailHeading(l10n.location),
                        if (h.address.isNotEmpty || place.isNotEmpty)
                          InfoRow(
                            Icons.map_outlined,
                            [h.address, place].where((s) => s.isNotEmpty).join(', '),
                            onTap: () => openMap([h.name, h.address, place].where((s) => s.isNotEmpty).join(', ')),
                          ),
                        if (h.orgName != null) InfoRow(Icons.storefront_outlined, l10n.publishedBy(h.orgName!)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ConfirmationNotice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final palette = ZakaPalette.of(context);
    return Row(
      children: [
        Icon(Icons.schedule, size: 18, color: palette.muted),
        const SizedBox(width: 8),
        Expanded(child: Text(l10n.bookingConfirmationNotice, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({required this.room, required this.offers, required this.checkIn, required this.onRequest});

  final RoomType room;
  final List<HotelOffer> offers;
  final DateTime? checkIn;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final palette = ZakaPalette.of(context);
    final offer = bestOffer(offers, room.id, checkIn ?? DateTime.now());
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconTile(icon: Icons.king_bed_outlined, background: palette.mint, foreground: palette.onMint, size: 40),
                const SizedBox(width: 12),
                Expanded(child: Text(room.name, style: theme.textTheme.titleMedium)),
              ],
            ),
            const SizedBox(height: 10),
            SpecsRow([
              (Icons.person_outline, l10n.roomCapacity(room.capacityAdults, room.capacityChildren)),
              if (room.beds.isNotEmpty) (Icons.bed_outlined, room.beds),
            ]),
            if (room.description.isNotEmpty) ...[const SizedBox(height: 8), Text(room.description)],
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.pricePerNight(room.pricePerNight.format()),
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if (offer != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: TagBadge(label: '−${offer.discountPercent} % · ${offer.title}', tone: BadgeTone.gold),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                FilledButton(
                  style: FilledButton.styleFrom(minimumSize: const Size(0, 46)),
                  onPressed: onRequest,
                  child: Text(l10n.requestThisRoom),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Lieu d'une annonce, avec l'épingle de la marque.
class PlaceLine extends StatelessWidget {
  const PlaceLine(this.place, {super.key});

  final String place;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(Icons.location_on_outlined, size: 18, color: Theme.of(context).colorScheme.primary),
      const SizedBox(width: 4),
      Expanded(child: Text(place, style: TextStyle(color: ZakaPalette.of(context).muted))),
    ],
  );
}

/// Titre de section dans une fiche.
class DetailHeading extends StatelessWidget {
  const DetailHeading(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 26, bottom: 10),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 18)),
  );
}

/// Menu « … » d'une fiche : signaler l'annonce.
class ListingMoreButton extends StatelessWidget {
  const ListingMoreButton({super.key, required this.onReport});

  final VoidCallback onReport;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return CircleAction(
      icon: Icons.more_horiz,
      tooltip: MaterialLocalizations.of(context).showMenuTooltip,
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        builder: (sheet) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: ListTile(
              leading: const Icon(Icons.flag_outlined),
              title: Text(l10n.reportTitle),
              onTap: () {
                Navigator.pop(sheet);
                onReport();
              },
            ),
          ),
        ),
      ),
    );
  }
}

/// Annonce introuvable ou retirée.
class ListingUnavailable extends StatelessWidget {
  const ListingUnavailable({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: EmptyState(icon: Icons.search_off, title: message),
  );
}

/// Icône d'un équipement du catalogue (voir functions/scripts/seed-catalog.mjs ; repli : coche).
IconData amenityIcon(String id) => switch (id) {
  'wifi' => Icons.wifi,
  'air_conditioning' => Icons.ac_unit,
  'parking' => Icons.local_parking,
  'generator' => Icons.bolt,
  'water_tank' => Icons.water_drop_outlined,
  'security' => Icons.security,
  'pool' => Icons.pool,
  'restaurant' => Icons.restaurant,
  'breakfast' => Icons.free_breakfast_outlined,
  'room_service' => Icons.room_service_outlined,
  'meeting_room' => Icons.meeting_room_outlined,
  'airport_shuttle' => Icons.airport_shuttle,
  'tv' => Icons.tv,
  'furnished' => Icons.chair_outlined,
  'garden' => Icons.park_outlined,
  'terrace' => Icons.deck_outlined,
  'fitted_kitchen' => Icons.kitchen_outlined,
  'boys_quarter' => Icons.cottage_outlined,
  _ => Icons.check_rounded,
};
