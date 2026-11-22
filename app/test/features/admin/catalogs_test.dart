import 'package:flutter_test/flutter_test.dart';
import 'package:zaka/features/admin/presentation/catalogs_screen.dart';

void main() {
  test("l'identifiant d'une entrée de catalogue est stable et sans accent", () {
    expect(slug('Groupe électrogène'), 'groupe_electrogene');
    expect(slug('  Chambre-salon '), 'chambre_salon');
    expect(slug("Réserve d'eau"), 'reserve_d_eau');
  });
}
