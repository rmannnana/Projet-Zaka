import 'package:flutter_test/flutter_test.dart';
import 'package:zaka/core/phone.dart';

void main() {
  final bf = countryByCode('BF');
  final ci = countryByCode('CI');

  test('le Burkina Faso est le pays par défaut', () {
    expect(countryByCode(null).code, 'BF');
    expect(countryByCode('FR').code, 'BF');
    expect(bf.flag, '🇧🇫');
  });

  test('accepte les saisies courantes', () {
    expect(toE164(bf, '70 12 34 56'), '+22670123456');
    expect(toE164(bf, '+226 70-12-34-56'), '+22670123456');
    expect(toE164(bf, '0022670123456'), '+22670123456');
    expect(toE164(ci, '07 01 02 03 04'), '+2250701020304');
  });

  test('refuse un numéro de mauvaise longueur', () {
    expect(toE164(bf, '7012345'), isNull);
    expect(toE164(bf, '701234567'), isNull);
    expect(toE164(ci, '70123456'), isNull);
  });
}
