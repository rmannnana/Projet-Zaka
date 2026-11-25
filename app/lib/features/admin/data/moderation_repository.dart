import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firestore_json.dart';
import '../../account/data/user_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../listings/domain/listing.dart';
import '../../organizations/data/organization_repository.dart';
import 'admin_repository.dart';

/// Adresse du site public, pour ouvrir une annonce depuis le back-office.
const publicSiteUrl = String.fromEnvironment('PUBLIC_SITE_URL', defaultValue: 'https://zaka-dev-01.web.app');

/// Modération des annonces et dossiers de litige (back-office).
class ModerationRepository {
  ModerationRepository(this._db, this._functions, this._storage);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;
  final FirebaseStorage _storage;

  /// Annonces de particuliers en attente de validation, dans l'ordre d'arrivée.
  Stream<List<Property>> watchPendingListings() => _db
      .collection('properties')
      .where('status', isEqualTo: 'pending_review')
      .orderBy('submittedAt')
      .limit(100)
      .snapshots()
      .map((s) => s.docs.map((d) => fromDoc(d, Property.fromJson)).toList());

  Future<void> reviewListing(String id, {required bool publish, String? note}) =>
      _functions.httpsCallable('reviewListing').call<void>({
        'kind': 'property',
        'id': id,
        'decision': publish ? 'publish' : 'reject',
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  Future<void> moderateListing(ListingKind kind, String id, {required bool suspend, String? note}) =>
      _functions.httpsCallable('moderateListing').call<void>({
        'kind': kind.name,
        'id': id,
        'decision': suspend ? 'suspend' : 'reinstate',
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  /// Statut actuel d'une annonce (null si introuvable).
  Future<String?> listingStatus(ListingKind kind, String id) async =>
      (await _db.collection(kind.collection).doc(id).get()).data()?['status'] as String?;

  /// Résumé d'une demande (réservation ou contact) avant export.
  Future<AdminRecord?> request(String collection, String id) async {
    final snap = await _db.collection(collection).doc(id).get();
    return snap.exists ? AdminRecord.fromDoc(snap) : null;
  }

  Future<String> exportDispute({required bool booking, required String id, required String reason}) async {
    final result = await _functions.httpsCallable('exportDisputeFile').call<Map<String, dynamic>>({
      'targetType': booking ? 'bookingRequest' : 'lead',
      'id': id,
      'reason': reason.trim(),
    });
    return result.data['path'] as String;
  }

  Stream<List<AdminRecord>> watchExports() => _db
      .collection('disputeExports')
      .orderBy('at', descending: true)
      .limit(50)
      .snapshots()
      .map((s) => s.docs.map(AdminRecord.fromDoc).toList());

  Future<Uint8List> exportBytes(String path) async {
    final data = await _storage.ref(path).getData(20 * 1024 * 1024);
    if (data == null) throw StateError('Fichier vide : $path');
    return data;
  }

  Future<int> _count(Query<Map<String, dynamic>> q) async => (await q.count().get()).count ?? 0;

  /// Compteurs d'activité du tableau de bord.
  Future<({int pendingListings, int openBookings, int newLeads, int published})> activity() async {
    final r = await Future.wait([
      _count(_db.collection('properties').where('status', isEqualTo: 'pending_review')),
      _count(_db.collection('bookingRequests').where('status', whereIn: ['pending', 'info_requested'])),
      _count(_db.collection('leads').where('status', isEqualTo: 'new')),
      _count(_db.collection('hotels').where('status', isEqualTo: 'published')),
      _count(_db.collection('properties').where('status', isEqualTo: 'published')),
    ]);
    return (pendingListings: r[0], openBookings: r[1], newLeads: r[2], published: r[3] + r[4]);
  }
}

final moderationRepositoryProvider = Provider<ModerationRepository>(
  (ref) => ModerationRepository(
    ref.watch(firestoreProvider),
    ref.watch(functionsProvider),
    ref.watch(storageProvider),
  ),
);

final pendingListingsProvider = StreamProvider.autoDispose<List<Property>>(
  (ref) => ref.watch(moderationRepositoryProvider).watchPendingListings(),
);

final disputeExportsProvider = StreamProvider.autoDispose<List<AdminRecord>>(
  (ref) => ref.watch(moderationRepositoryProvider).watchExports(),
);

final activityCountersProvider = FutureProvider.autoDispose(
  (ref) => ref.watch(moderationRepositoryProvider).activity(),
);
