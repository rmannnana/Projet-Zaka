import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/widgets/listing_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/listing.dart';
import 'listing_labels.dart';

/// Carte d'un hôtel dans les résultats et sur l'accueil.
Widget hotelCard(BuildContext context, Hotel hotel, {double? width, String query = ''}) {
  final l10n = AppLocalizations.of(context);
  return ListingCard(
    width: width,
    title: hotel.name,
    photo: hotel.cover,
    icon: Icons.hotel,
    location: placeOf(hotel.district, hotel.city),
    price: hotel.priceLabel(l10n),
    badges: [
      if (hotel.featured) l10n.featured,
      if (hotel.stars != null && hotel.stars! > 0) '${hotel.stars}★',
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
Widget propertyCard(BuildContext context, Property p, {double? width}) {
  final l10n = AppLocalizations.of(context);
  return ListingCard(
    width: width,
    title: p.title,
    photo: p.cover,
    icon: Icons.home_work_outlined,
    location: placeOf(p.district, p.city),
    price: p.priceLabel(l10n),
    badges: [
      if (p.featured) l10n.featured,
      p.transactionLabel(l10n),
      if (p.status == ListingStatus.underOffer) l10n.listingUnderOffer,
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
Widget projectCard(BuildContext context, Project p, {double? width}) {
  final l10n = AppLocalizations.of(context);
  return ListingCard(
    width: width,
    title: p.title,
    photo: p.cover,
    icon: Icons.domain,
    location: placeOf(p.district, p.city),
    price: p.priceLabel(l10n),
    badges: [l10n.newProject, if (p.status == ListingStatus.delivered) l10n.listingDelivered],
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
