import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:zaka/core/money.dart';

void main() {
  setUpAll(() => initializeDateFormatting('fr'));

  test('formate un montant XOF avec séparateur de milliers et FCFA', () {
    final text = const Money(125000).format();
    expect(text.replaceAll(RegExp(r'\s'), ' '), '125 000 FCFA');
  });

  test('sérialise et désérialise au format Firestore', () {
    const m = Money(45000);
    expect(m.toJson(), {'amount': 45000, 'currency': 'XOF'});
    expect(Money.fromJson({'amount': 45000, 'currency': 'XOF'}), m);
    expect(Money.fromJson({'amount': 45000.0}), m);
  });

  test('calcule un pourcentage arrondi au franc', () {
    expect(const Money(33333).percent(7.5), const Money(2500));
  });

  test('refuse les opérations entre devises différentes', () {
    expect(() => const Money(1) + const Money(1, currency: 'EUR'), throwsArgumentError);
  });
}
