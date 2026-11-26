import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zaka/core/money.dart';
import 'package:zaka/features/listings/domain/listing.dart';
import 'package:zaka/features/listings/presentation/listing_labels.dart';
import 'package:zaka/features/requests/data/requests_repository.dart';
import 'package:zaka/features/requests/domain/requests.dart';
import 'package:zaka/l10n/app_localizations.dart';

String normalize(String s) => s.replaceAll(RegExp(r'\s'), ' ');

void main() {
  setUpAll(() => initializeDateFormatting('fr'));
  final l10n = lookupAppLocalizations(const Locale('fr'));

  test("lit un hôtel avec ses statistiques et calcule le taux d'acceptation", () {
    final hotel = Hotel.fromJson({
      'orgId': 'org1',
      'name': 'Hôtel Laafi',
      'status': 'published',
      'photos': ['a.jpg', 'b.jpg'],
      'minPricePerNight': {'amount': 25000, 'currency': 'XOF'},
      'stats': {'views': 120, 'requests': 10, 'accepted': 6, 'rejected': 1, 'expired': 1},
    });
    expect(hotel.cover, 'a.jpg');
    expect(hotel.acceptanceRate, 0.75);
    expect(normalize(hotel.priceLabel(l10n)!), 'À partir de 25 000 FCFA / nuit');
    // Les champs calculés par les Cloud Functions ne sont jamais renvoyés par l'app.
    expect(hotel.toJson().keys, isNot(contains('minPricePerNight')));
    expect(hotel.toJson().keys, isNot(contains('stats')));
  });

  test("la remise appliquée suit la même règle que le serveur (fin exclue, chambre concernée)", () {
    final offers = [
      HotelOffer(
        title: 'Noël',
        discountPercent: 15,
        validFrom: DateTime.utc(2026, 12, 20),
        validTo: DateTime.utc(2026, 12, 27),
      ),
      HotelOffer(title: 'Suite', discountPercent: 25, roomTypeIds: const ['suite'], validFrom: DateTime.utc(2026, 12, 1)),
    ];
    expect(bestOffer(offers, 'double', DateTime.utc(2026, 12, 24))?.title, 'Noël');
    expect(bestOffer(offers, 'suite', DateTime.utc(2026, 12, 24))?.title, 'Suite');
    expect(bestOffer(offers, 'double', DateTime.utc(2026, 12, 27)), isNull);
  });

  test('statuts des annonces : valeurs Firestore et actions possibles', () {
    final p = Property.fromJson({'orgId': 'o', 'status': 'pending_review', 'transactionType': 'sale', 'price': {'amount': 35000000}});
    expect(p.status, ListingStatus.pendingReview);
    expect(ListingStatus.pendingReview.key, 'pending_review');
    expect(ListingStatus.underOffer.isPublic, isTrue);
    expect(ListingStatus.rented.canPublish, isTrue);
    expect(ListingStatus.published.canPublish, isFalse);
    expect(normalize(p.priceLabel(l10n)), '35 000 000 FCFA');
    final rent = p.copyWith(transactionType: TransactionType.rent, price: const Money(150000));
    expect(normalize(rent.priceLabel(l10n)), '150 000 FCFA / mois');
  });

  test('réservation : statuts, paiement et début du séjour', () {
    final b = BookingRequest.fromJson({
      'hotelId': 'h',
      'orgId': 'o',
      'clientUid': 'c',
      'status': 'info_requested',
      'paymentStatus': 'unpaid',
      'estimatedTotal': {'amount': 50000, 'currency': 'XOF'},
      'checkIn': Timestamp.fromDate(DateTime.utc(2026, 12, 24)),
      'statusHistory': [
        {'status': 'pending', 'by': 'c', 'at': Timestamp.fromDate(DateTime.utc(2026, 12, 1))},
      ],
    });
    expect(b.status.isOpen, isTrue);
    expect(b.statusHistory.single.status, 'pending');
    expect(b.canPay, isFalse);
    final accepted = b.copyWith(status: BookingStatus.accepted);
    expect(accepted.canPay, isTrue);
    expect(accepted.copyWith(paymentStatus: BookingPayment.paidSimulated).isPaid, isTrue);
    expect(accepted.hasStarted(DateTime.utc(2026, 12, 23)), isFalse);
    expect(accepted.hasStarted(DateTime.utc(2026, 12, 24, 15)), isTrue);
    expect(BookingAction.requestInfo.key, 'request_info');
  });

  test('demande de contact : statut « new » et clé envoyée à Firestore', () {
    final lead = Lead.fromJson({'targetId': 't', 'orgId': 'o', 'clientUid': 'c', 'status': 'new', 'type': 'visit'});
    expect(lead.status, LeadStatus.fresh);
    expect(LeadStatus.fresh.key, 'new');
    expect(LeadStatus.visitScheduled.key, 'visit_scheduled');
    expect(lead.type.label(l10n), 'Visite');
  });

  test('jour calendaire envoyé à createBookingRequest', () {
    expect(dayKey(DateTime(2026, 3, 7)), '2026-03-07');
  });
}
