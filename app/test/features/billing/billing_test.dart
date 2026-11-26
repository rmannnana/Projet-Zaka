import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zaka/core/money.dart';
import 'package:zaka/features/admin/presentation/commissions_admin.dart';
import 'package:zaka/features/billing/domain/billing.dart';
import 'package:zaka/features/billing/presentation/billing_labels.dart';
import 'package:zaka/features/organizations/domain/organization.dart';
import 'package:zaka/l10n/app_localizations.dart';

String normalize(String s) => s.replaceAll(RegExp(r'\s'), ' ');

void main() {
  setUpAll(() => initializeDateFormatting('fr'));
  final l10n = lookupAppLocalizations(const Locale('fr'));

  final hotelPro = SubscriptionPlan.fromJson({
    'id': 'pro',
    'name': 'Hôtel Pro',
    'price': {'amount': 15000, 'currency': 'XOF'},
    'period': 'month',
    'target': 'hotel',
    'features': {'maxListings': 10, 'featuredListings': 1, 'advancedStats': true},
    'active': true,
  });

  test('lit un plan Firestore et décrit son prix et ses avantages', () {
    expect(hotelPro.price, const Money(15000));
    expect(normalize(hotelPro.priceLabel(l10n)), '15 000 FCFA par mois');
    expect(hotelPro.featureLabels(l10n), [
      '10 annonces publiées à la fois',
      '1 annonce mise en avant',
      'Statistiques détaillées',
    ]);
    final unlimited = hotelPro.copyWith(
      price: Money.zero,
      features: const PlanFeatures(maxListings: null, featuredListings: 0),
    );
    expect(unlimited.priceLabel(l10n), 'Gratuit');
    expect(unlimited.featureLabels(l10n), ['Annonces illimitées', 'Pas de mise en avant']);
  });

  test('un plan immobilier ne concerne pas les hôtels', () {
    final immo = SubscriptionPlan.fromJson({'name': 'Immo', 'target': 'real_estate'});
    expect(immo.target, PlanTarget.realEstate);
    expect(immo.target.fits(OrgType.individualOwner), isTrue);
    expect(immo.target.fits(OrgType.hotel), isFalse);
    expect(hotelPro.target.fits(OrgType.agency), isFalse);
  });

  group('plan en vigueur', () {
    final now = DateTime(2026, 12, 1);
    const free = SubscriptionPlan(id: freePlanId, name: 'Gratuit');
    Subscription sub({required DateTime end, String status = 'active'}) => Subscription.fromJson({
      'id': 's1',
      'orgId': 'org1',
      'planId': 'pro',
      'planSnapshot': {...hotelPro.toJson(), 'id': 'pro'},
      'status': status,
      'currentPeriodEnd': Timestamp.fromDate(end),
    });

    test("l'abonnement payé tant qu'il court", () {
      expect(effectivePlan(sub(end: DateTime(2026, 12, 20)), free, now)?.name, 'Hôtel Pro');
    });

    test('le plan Gratuit après l\'échéance, sans abonnement ou si remplacé', () {
      expect(effectivePlan(sub(end: DateTime(2026, 11, 30)), free, now)?.isFree, isTrue);
      expect(effectivePlan(null, free, now)?.isFree, isTrue);
      expect(effectivePlan(sub(end: DateTime(2027), status: 'cancelled'), free, now)?.isFree, isTrue);
    });
  });

  group('règles de commission', () {
    final rule = CommissionRule.fromJson({
      'scope': 'hotel_booking',
      'rateType': 'percent',
      'rate': 7.5,
      'validFrom': Timestamp.fromDate(DateTime.utc(2026, 1, 1)),
      'validTo': Timestamp.fromDate(DateTime.utc(2027, 1, 1)),
      'active': true,
    });

    test('libellé du taux', () {
      expect(rule.scope, CommissionScope.hotelBooking);
      expect(normalize(rule.rateLabel), '7,5 %');
      final fixed = rule.copyWith(rateType: RateType.fixed, fixedAmount: const Money(2000));
      expect(normalize(fixed.rateLabel), '2 000 FCFA');
    });

    test('situation à une date : programmée, en vigueur, terminée, désactivée', () {
      expect(rule.stateAt(DateTime.utc(2025, 12, 31)), RuleState.scheduled);
      expect(rule.stateAt(DateTime.utc(2026, 6, 1)), RuleState.inForce);
      expect(rule.stateAt(DateTime.utc(2027, 1, 1)), RuleState.ended);
      expect(rule.copyWith(active: false).stateAt(DateTime.utc(2026, 6, 1)), RuleState.disabled);
    });

    test('la date de fin enregistrée est exclue : on affiche le dernier jour inclus', () {
      expect(normalize(validityLabel(rule)), 'du 1 janv. 2026 au 31 déc. 2026');
      expect(normalize(validityLabel(rule.copyWith(validTo: null))), 'à partir du 1 janv. 2026');
    });
  });

  test('registre : mêmes transitions que la Cloud Function', () {
    expect(CommissionStatus.due.canMoveTo(CommissionStatus.invoiced), isTrue);
    expect(CommissionStatus.invoiced.canMoveTo(CommissionStatus.due), isTrue);
    expect(CommissionStatus.due.canMoveTo(CommissionStatus.due), isFalse);
    expect(CommissionStatus.paid.canMoveTo(CommissionStatus.due), isFalse);
    expect(CommissionStatus.waived.canMoveTo(CommissionStatus.paid), isFalse);
  });

  test('reste à régler : commissions dues et facturées', () {
    final list = [
      for (final (amount, status) in [(4500, 'due'), (3000, 'invoiced'), (1000, 'paid')])
        Commission.fromJson({
          'orgId': 'h1',
          'amount': {'amount': amount, 'currency': 'XOF'},
          'status': status,
        }),
    ];
    expect(totalOf(list.where((c) => c.status.isOutstanding)), const Money(7500));
  });
}
