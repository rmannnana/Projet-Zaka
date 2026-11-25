import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/account/data/user_repository.dart';

/// Ville du catalogue (`catalog/cities`).
class City {
  const City(this.name, this.country);

  final String name;
  final String country;
}

/// Équipement du catalogue (`catalog/amenities`) : pour les hôtels, les biens ou les deux.
class Amenity {
  const Amenity(this.id, this.label, this.scope);

  final String id;
  final String label;
  final String scope;

  bool get forHotels => scope == 'hotel' || scope == 'both';
  bool get forProperties => scope == 'property' || scope == 'both';
}

/// Type de bien du catalogue (`catalog/propertyTypes`).
class PropertyType {
  const PropertyType(this.id, this.label);

  final String id;
  final String label;
}

Stream<List<Map<String, dynamic>>> _items(Ref ref, String name) => ref
    .watch(firestoreProvider)
    .doc('catalog/$name')
    .snapshots()
    .map((s) => List<Map<String, dynamic>>.from((s.data()?['items'] as List?) ?? const []));

/// Villes, Burkina Faso en tête (ordre du catalogue).
final citiesProvider = StreamProvider<List<City>>(
  (ref) => _items(ref, 'cities').map(
    (items) => [for (final i in items) City('${i['name']}', '${i['country'] ?? 'BF'}')],
  ),
);

final amenitiesProvider = StreamProvider<List<Amenity>>(
  (ref) => _items(ref, 'amenities').map(
    (items) => [for (final i in items) Amenity('${i['id']}', '${i['label']}', '${i['scope'] ?? 'both'}')],
  ),
);

final propertyTypesProvider = StreamProvider<List<PropertyType>>(
  (ref) => _items(ref, 'propertyTypes').map(
    (items) => [for (final i in items) PropertyType('${i['id']}', '${i['label']}')],
  ),
);

/// Libellé d'un équipement ou d'un type de bien à partir de son identifiant.
String labelOf(String id, Iterable<({String id, String label})> entries) =>
    entries.firstWhere((e) => e.id == id, orElse: () => (id: id, label: id)).label;

extension AmenityLabels on List<Amenity> {
  String label(String id) => labelOf(id, map((a) => (id: a.id, label: a.label)));
}

extension PropertyTypeLabels on List<PropertyType> {
  String label(String id) => labelOf(id, map((t) => (id: t.id, label: t.label)));
}
