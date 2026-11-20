import 'package:flutter_test/flutter_test.dart';
import 'package:zaka/features/organizations/data/organization_repository.dart';
import 'package:zaka/features/organizations/domain/organization.dart';

void main() {
  test('envoie le type attendu par la Cloud Function et omet les champs vides', () {
    const org = NewOrganization(
      type: OrgType.individualOwner,
      name: ' Awa O. ',
      phone: '+22670000000',
      city: 'Ouagadougou',
      email: '  ',
    );
    expect(org.toJson(), {
      'type': 'individual_owner',
      'name': 'Awa O.',
      'description': '',
      'contact': {'phone': '+22670000000', 'city': 'Ouagadougou', 'country': 'BF'},
    });
  });

  test('lit un espace particulier anonymisé après effacement des données', () {
    final org = Organization.fromJson({
      'id': 'org1',
      'type': 'individual_owner',
      'name': 'Particulier supprimé',
      'contact': {'country': 'BF'},
      'verification': {'status': 'suspended'},
      'publishingMode': 'review',
    });
    expect(org.contact.phone, '');
    expect(org.verification.status, VerificationStatus.suspended);
  });

  test('un pro modifie son dossier en brouillon ou après un refus seulement', () {
    Organization pro(VerificationStatus status) => Organization(
      type: OrgType.agency,
      name: 'Faso Immo',
      contact: const OrgContact(phone: '+22670000000', city: 'Ouagadougou'),
      verification: Verification(status: status),
    );
    expect(pro(VerificationStatus.draft).canEditVerification, isTrue);
    expect(pro(VerificationStatus.rejected).canEditVerification, isTrue);
    expect(pro(VerificationStatus.pending).canEditVerification, isFalse);
    expect(pro(VerificationStatus.verified).canEditVerification, isFalse);
  });

  test('type de contenu des pièces', () {
    expect(contentTypeFor('PDF'), 'application/pdf');
    expect(contentTypeFor('jpg'), 'image/jpeg');
    expect(contentTypeFor('png'), 'image/png');
  });
}
