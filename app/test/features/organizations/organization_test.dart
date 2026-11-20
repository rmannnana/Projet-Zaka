import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zaka/features/organizations/domain/organization.dart';

void main() {
  test('lit un particulier propriétaire depuis Firestore', () {
    final org = Organization.fromJson({
      'id': 'org1',
      'type': 'individual_owner',
      'name': 'Awa Ouédraogo',
      'contact': {'phone': '+22670000000', 'city': 'ouagadougou'},
      'verification': {'status': 'verified'},
      'publishingMode': 'review',
      'createdAt': Timestamp.fromDate(DateTime.utc(2026, 11, 20)),
    });

    expect(org.id, 'org1');
    expect(org.type, OrgType.individualOwner);
    expect(org.type.requiresDocuments, isFalse);
    expect(org.isVerified, isTrue);
    expect(org.requiresListingReview, isTrue);
    expect(org.canPublishHotels, isFalse);
    expect(org.contact.country, 'BF');
    expect(org.createdAt?.toUtc(), DateTime.utc(2026, 11, 20));
  });

  test("écrit les énumérations en snake_case et n'écrit pas l'id", () {
    const org = Organization(
      id: 'ignored',
      type: OrgType.hotel,
      name: 'Hôtel Laïco',
      contact: OrgContact(phone: '+22625000000', city: 'ouagadougou'),
    );
    final json = org.toJson();

    expect(json.containsKey('id'), isFalse);
    expect(json['type'], 'hotel');
    expect((json['verification'] as Map)['status'], 'draft');
    expect(json['publishingMode'], 'direct');
  });
}
