import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../l10n/app_localizations.dart';
import '../../requests/domain/requests.dart';
import '../domain/listing.dart';

final shortDate = DateFormat('d MMM yyyy', 'fr');
final longDate = DateFormat.yMMMMEEEEd('fr');
final dateTimeFormat = DateFormat("d MMM yyyy 'à' HH:mm", 'fr');

/// « Ouaga 2000, Ouagadougou »
String placeOf(String district, String city) => [district, city].where((s) => s.trim().isNotEmpty).join(', ');

extension ListingStatusLabel on ListingStatus {
  String label(AppLocalizations l10n) => switch (this) {
    ListingStatus.draft => l10n.listingDraft,
    ListingStatus.pendingReview => l10n.listingPendingReview,
    ListingStatus.published => l10n.listingPublished,
    ListingStatus.rejected => l10n.listingRejected,
    ListingStatus.underOffer => l10n.listingUnderOffer,
    ListingStatus.rented => l10n.listingRented,
    ListingStatus.sold => l10n.listingSold,
    ListingStatus.inactive => l10n.listingInactive,
    ListingStatus.inProgress => l10n.listingInProgress,
    ListingStatus.delivered => l10n.listingDelivered,
    ListingStatus.suspended => l10n.listingSuspended,
  };

  Color color(ColorScheme scheme) => switch (this) {
    ListingStatus.published || ListingStatus.inProgress || ListingStatus.delivered => Colors.green.shade700,
    ListingStatus.pendingReview || ListingStatus.underOffer => Colors.orange.shade800,
    ListingStatus.rejected || ListingStatus.suspended => scheme.error,
    _ => scheme.outline,
  };
}

extension BookingStatusLabel on BookingStatus {
  String label(AppLocalizations l10n) => switch (this) {
    BookingStatus.pending => l10n.bookingPending,
    BookingStatus.infoRequested => l10n.bookingInfoRequested,
    BookingStatus.accepted => l10n.bookingAccepted,
    BookingStatus.rejected => l10n.bookingRejected,
    BookingStatus.cancelled => l10n.bookingCancelled,
    BookingStatus.expired => l10n.bookingExpired,
    BookingStatus.completed => l10n.bookingCompleted,
  };

  Color color(ColorScheme scheme) => switch (this) {
    BookingStatus.accepted || BookingStatus.completed => Colors.green.shade700,
    BookingStatus.pending || BookingStatus.infoRequested => Colors.orange.shade800,
    BookingStatus.rejected => scheme.error,
    BookingStatus.cancelled || BookingStatus.expired => scheme.outline,
  };

  IconData get icon => switch (this) {
    BookingStatus.pending => Icons.hourglass_top,
    BookingStatus.infoRequested => Icons.help_outline,
    BookingStatus.accepted => Icons.check_circle_outline,
    BookingStatus.rejected => Icons.block,
    BookingStatus.cancelled => Icons.cancel_outlined,
    BookingStatus.expired => Icons.timer_off_outlined,
    BookingStatus.completed => Icons.verified_outlined,
  };
}

extension LeadStatusLabel on LeadStatus {
  String label(AppLocalizations l10n) => switch (this) {
    LeadStatus.fresh => l10n.leadNew,
    LeadStatus.inProgress => l10n.leadInProgress,
    LeadStatus.visitScheduled => l10n.leadVisitScheduled,
    LeadStatus.closed => l10n.leadClosed,
  };

  Color color(ColorScheme scheme) => switch (this) {
    LeadStatus.fresh => Colors.orange.shade800,
    LeadStatus.inProgress => scheme.primary,
    LeadStatus.visitScheduled => Colors.green.shade700,
    LeadStatus.closed => scheme.outline,
  };
}

extension LeadTypeLabel on LeadType {
  String label(AppLocalizations l10n) => switch (this) {
    LeadType.contact => l10n.leadTypeContact,
    LeadType.visit => l10n.leadTypeVisit,
    LeadType.info => l10n.leadTypeInfo,
  };

  IconData get icon => switch (this) {
    LeadType.contact => Icons.chat_outlined,
    LeadType.visit => Icons.calendar_month_outlined,
    LeadType.info => Icons.info_outline,
  };
}

extension HotelPrice on Hotel {
  /// « À partir de 25 000 FCFA / nuit »
  String? priceLabel(AppLocalizations l10n) =>
      minPricePerNight == null ? null : l10n.priceFromPerNight(minPricePerNight!.format());
}

extension PropertyPrice on Property {
  /// « 150 000 FCFA / mois », « 35 000 000 FCFA »
  String priceLabel(AppLocalizations l10n) {
    final amount = price.format();
    if (transactionType == TransactionType.sale) return amount;
    return rentPeriod == RentPeriod.day ? l10n.pricePerDay(amount) : l10n.pricePerMonth(amount);
  }

  String transactionLabel(AppLocalizations l10n) =>
      transactionType == TransactionType.rent ? l10n.forRent : l10n.forSale;
}

extension ProjectPrice on Project {
  String? priceLabel(AppLocalizations l10n) => priceFrom == null ? null : l10n.priceFrom(priceFrom!.format());
}

extension UnitStatusLabel on UnitStatus {
  String label(AppLocalizations l10n) => switch (this) {
    UnitStatus.available => l10n.unitAvailable,
    UnitStatus.reserved => l10n.unitReserved,
    UnitStatus.sold => l10n.unitSold,
  };

  Color color(ColorScheme scheme) => switch (this) {
    UnitStatus.available => Colors.green.shade700,
    UnitStatus.reserved => Colors.orange.shade800,
    UnitStatus.sold => scheme.outline,
  };
}
