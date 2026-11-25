import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/catalog.dart';
import '../../../core/links.dart';
import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../account/data/account_requests_repository.dart';
import '../../account/presentation/report_dialog.dart';
import '../../listings/data/listings_repository.dart';
import '../../listings/domain/listing.dart';
import '../../listings/presentation/listing_labels.dart';
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
  @override
  void initState() {
    super.initState();
    ref.read(listingsRepositoryProvider).recordView(ListingKind.hotel, widget.hotelId);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final hotel = ref.watch(hotelProvider(widget.hotelId));
    final rooms = ref.watch(roomTypesProvider(widget.hotelId)).value ?? const <RoomType>[];
    final offers = ref.watch(offersProvider(widget.hotelId)).value ?? const <HotelOffer>[];
    final amenities = ref.watch(amenitiesProvider).value ?? const <Amenity>[];

    return hotel.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => _Unavailable(message: l10n.listingUnavailable),
      data: (h) {
        if (h == null) return _Unavailable(message: l10n.listingUnavailable);
        final now = DateTime.now();
        final currentOffers = offers.where((o) => o.isCurrent(now)).toList();
        final activeRooms = rooms.where((r) => r.active).toList();
        final place = placeOf(h.district, h.city);

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                expandedHeight: 300,
                flexibleSpace: FlexibleSpaceBar(background: PhotoGallery(photos: h.photos, icon: Icons.hotel)),
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
                  PopupMenuButton<String>(
                    onSelected: (_) => showReportDialog(context, ref, target: ReportTarget.hotel, targetId: h.id),
                    itemBuilder: (_) => [PopupMenuItem(value: 'report', child: Text(l10n.reportTitle))],
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Readable(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(h.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            if (h.stars != null && h.stars! > 0)
                              Text('★' * h.stars!, style: TextStyle(color: Colors.amber.shade700)),
                            if (place.isNotEmpty) Text(place, style: theme.textTheme.bodyMedium),
                          ],
                        ),
                        if (h.priceLabel(l10n) != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            h.priceLabel(l10n)!,
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: theme.colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                        for (final o in currentOffers) ...[
                          const SizedBox(height: 12),
                          Card.filled(
                            color: theme.colorScheme.tertiaryContainer,
                            margin: EdgeInsets.zero,
                            child: ListTile(
                              leading: const Icon(Icons.local_offer_outlined),
                              title: Text('${o.title} · −${o.discountPercent} %'),
                              subtitle: Text([
                                if (o.description.isNotEmpty) o.description,
                                if (o.validTo != null) l10n.offerUntil(shortDate.format(o.validTo!)),
                              ].join('\n')),
                            ),
                          ),
                        ],
                        const SizedBox(height: 16),
                        _ConfirmationNotice(),
                        if (h.description.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text(h.description),
                        ],
                        if (h.amenities.isNotEmpty) ...[
                          _Heading(l10n.amenities),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final id in h.amenities)
                                Chip(avatar: const Icon(Icons.check, size: 16), label: Text(amenities.label(id))),
                            ],
                          ),
                        ],
                        _Heading(l10n.rooms),
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
                        _Heading(l10n.hotelRules),
                        if (h.rules.checkIn.isNotEmpty) InfoRow(Icons.login, l10n.checkInFrom(h.rules.checkIn)),
                        if (h.rules.checkOut.isNotEmpty) InfoRow(Icons.logout, l10n.checkOutBefore(h.rules.checkOut)),
                        InfoRow(Icons.pets, h.rules.pets ? l10n.petsAllowed : l10n.petsNotAllowed),
                        if (h.rules.cancellationPolicy.isNotEmpty)
                          InfoRow(Icons.event_busy, l10n.cancellationPolicy(h.rules.cancellationPolicy)),
                        if (h.rules.other.isNotEmpty) InfoRow(Icons.info_outline, h.rules.other),
                        _Heading(l10n.location),
                        if (h.address.isNotEmpty || place.isNotEmpty)
                          InfoRow(
                            Icons.map_outlined,
                            [h.address, place].where((s) => s.isNotEmpty).join(', '),
                            onTap: () => openMap([h.name, h.address, place].where((s) => s.isNotEmpty).join(', ')),
                          ),
                        if (h.orgName != null) InfoRow(Icons.storefront_outlined, l10n.publishedBy(h.orgName!)),
                        const SizedBox(height: 32),
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
    return Row(
      children: [
        Icon(Icons.schedule, size: 18, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(child: Text(l10n.bookingConfirmationNotice, style: Theme.of(context).textTheme.bodySmall)),
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 24, bottom: 8),
    child: Text(text, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700)),
  );
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
    final offer = bestOffer(offers, room.id, checkIn ?? DateTime.now());
    return Card.outlined(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(room.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.pricePerNight(room.pricePerNight.format()),
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (offer != null)
                      Text('−${offer.discountPercent} % · ${offer.title}', style: TextStyle(color: Colors.green.shade700)),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Wrap(
              spacing: 16,
              runSpacing: 4,
              children: [
                _Fact(Icons.person_outline, l10n.roomCapacity(room.capacityAdults, room.capacityChildren)),
                if (room.beds.isNotEmpty) _Fact(Icons.bed_outlined, room.beds),
              ],
            ),
            if (room.description.isNotEmpty) ...[const SizedBox(height: 8), Text(room.description)],
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.icon(
                style: FilledButton.styleFrom(minimumSize: const Size(0, 44)),
                onPressed: onRequest,
                icon: const Icon(Icons.send_outlined),
                label: Text(l10n.requestThisRoom),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fact extends StatelessWidget {
  const _Fact(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [Icon(icon, size: 18), const SizedBox(width: 4), Text(text)],
  );
}

class _Unavailable extends StatelessWidget {
  const _Unavailable({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(),
    body: EmptyState(icon: Icons.search_off, title: message),
  );
}
