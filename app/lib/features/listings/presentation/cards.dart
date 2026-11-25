import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/listing.dart';
import 'listing_labels.dart';

/// Caractéristiques affichées sous un hôtel.
List<(IconData, String)> hotelSpecs(AppLocalizations l10n, Hotel h) => [
  if (h.stars != null && h.stars! > 0) (Icons.star_rounded, l10n.starsValue(h.stars!)),
  if (h.maxGuests > 0) (Icons.people_outline, l10n.upToGuests(h.maxGuests)),
  if (h.roomTypesCount > 0) (Icons.king_bed_outlined, l10n.roomTypesValue(h.roomTypesCount)),
];

/// Caractéristiques affichées sous un bien.
List<(IconData, String)> propertySpecs(AppLocalizations l10n, Property p) => [
  if (p.bedrooms != null) (Icons.bed_outlined, l10n.bedroomsValue(p.bedrooms!)),
  if (p.bathrooms != null) (Icons.bathtub_outlined, l10n.bathroomsValue(p.bathrooms!)),
  if (p.surface != null) (Icons.square_foot, l10n.surfaceValue(p.surface!)),
  if (p.bedrooms == null && p.rooms != null) (Icons.meeting_room_outlined, l10n.roomsValue(p.rooms!)),
];

/// Caractéristiques affichées sous un programme neuf.
List<(IconData, String)> projectSpecs(AppLocalizations l10n, Project p) => [
  if (p.unitsCount > 0) (Icons.apartment, l10n.unitsLeft(p.unitsAvailable)),
  if (p.deliveryDate.isNotEmpty) (Icons.event_available, l10n.deliveryShort(p.deliveryDate)),
];

/// Carte d'un hôtel dans les résultats et sur l'accueil.
Widget hotelCard(BuildContext context, Hotel hotel, {double? width, String query = '', double imageHeight = 190}) {
  final l10n = AppLocalizations.of(context);
  return ListingCard(
    width: width,
    imageHeight: imageHeight,
    title: hotel.name,
    photo: hotel.cover,
    icon: Icons.hotel,
    location: placeOf(hotel.district, hotel.city),
    price: hotel.priceLabel(l10n),
    specs: hotelSpecs(l10n, hotel),
    badges: [
      TagBadge(label: l10n.badgeHotel),
      if (hotel.featured) TagBadge(label: l10n.featured, tone: BadgeTone.gold),
    ],
    favorite: FavoriteButton(
      onImage: true,
      targetId: hotel.id,
      favorite: Favorite(
        targetType: ListingKind.hotel,
        title: hotel.name,
        photo: hotel.cover,
        city: hotel.city,
        price: hotel.minPricePerNight,
      ),
    ),
    onTap: () => context.push('/hotel/${hotel.id}$query'),
  );
}

/// Carte d'un bien à louer ou à vendre.
Widget propertyCard(BuildContext context, Property p, {double? width, double imageHeight = 190}) {
  final l10n = AppLocalizations.of(context);
  return ListingCard(
    width: width,
    imageHeight: imageHeight,
    title: p.title,
    photo: p.cover,
    icon: Icons.home_work_outlined,
    location: placeOf(p.district, p.city),
    price: p.priceLabel(l10n),
    specs: propertySpecs(l10n, p),
    badges: [
      TagBadge(label: p.transactionLabel(l10n)),
      if (p.featured) TagBadge(label: l10n.featured, tone: BadgeTone.gold),
      if (p.status == ListingStatus.underOffer) TagBadge(label: l10n.listingUnderOffer, tone: BadgeTone.light),
    ],
    favorite: FavoriteButton(
      onImage: true,
      targetId: p.id,
      favorite: Favorite(
        targetType: ListingKind.property,
        title: p.title,
        photo: p.cover,
        city: p.city,
        price: p.price,
      ),
    ),
    onTap: () => context.push('/bien/${p.id}'),
  );
}

/// Carte d'un programme immobilier neuf.
Widget projectCard(BuildContext context, Project p, {double? width, double imageHeight = 190}) {
  final l10n = AppLocalizations.of(context);
  return ListingCard(
    width: width,
    imageHeight: imageHeight,
    title: p.title,
    photo: p.cover,
    icon: Icons.domain,
    location: placeOf(p.district, p.city),
    price: p.priceLabel(l10n),
    specs: projectSpecs(l10n, p),
    badges: [
      TagBadge(label: l10n.newProject),
      if (p.status == ListingStatus.delivered) TagBadge(label: l10n.listingDelivered, tone: BadgeTone.light),
    ],
    favorite: FavoriteButton(
      onImage: true,
      targetId: p.id,
      favorite: Favorite(targetType: ListingKind.project, title: p.title, photo: p.cover, city: p.city, price: p.priceFrom),
    ),
    onTap: () => context.push('/programme/${p.id}'),
  );
}

/// Ouvre l'annonce d'un favori.
void openFavorite(BuildContext context, Favorite f) => context.push(switch (f.targetType) {
  ListingKind.hotel => '/hotel/${f.id}',
  ListingKind.property => '/bien/${f.id}',
  ListingKind.project => '/programme/${f.id}',
});
