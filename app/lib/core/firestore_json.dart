import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';

/// Convertit les `Timestamp` Firestore en `DateTime` (et inversement).
/// Les dates sont toujours nullables côté client : un `serverTimestamp()`
/// vaut `null` tant que l'écriture n'est pas confirmée par le serveur.
class TimestampConverter implements JsonConverter<DateTime?, Object?> {
  const TimestampConverter();

  @override
  DateTime? fromJson(Object? json) => switch (json) {
    null => null,
    Timestamp t => t.toDate(),
    DateTime d => d,
    String s => DateTime.parse(s),
    int ms => DateTime.fromMillisecondsSinceEpoch(ms),
    _ => throw ArgumentError('Date illisible : $json'),
  };

  @override
  Object? toJson(DateTime? date) => date == null ? null : Timestamp.fromDate(date);
}

/// Lit un document Firestore en ajoutant son identifiant au JSON.
T fromDoc<T>(
  DocumentSnapshot<Map<String, dynamic>> doc,
  T Function(Map<String, dynamic> json) fromJson,
) {
  final data = doc.data();
  if (data == null) throw StateError('Document introuvable : ${doc.reference.path}');
  return fromJson({...data, 'id': doc.id});
}
