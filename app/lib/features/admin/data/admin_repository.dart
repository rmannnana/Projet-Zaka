import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firestore_json.dart';
import '../../account/data/user_repository.dart';
import '../../account/domain/user_profile.dart';
import '../../auth/data/auth_repository.dart';
import '../../organizations/data/organization_repository.dart';
import '../../organizations/domain/organization.dart';

/// Ligne générique d'une file du back-office (signalement, demande, audit).
class AdminRecord {
  const AdminRecord(this.id, this.data);

  factory AdminRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) =>
      AdminRecord(doc.id, doc.data() ?? const {});

  final String id;
  final Map<String, dynamic> data;

  String? str(String key) => data[key] as String?;

  DateTime? date(String key) => (data[key] as Timestamp?)?.toDate();
}

/// Décisions possibles sur un compte (Cloud Function `reviewOrg`).
enum OrgDecision { verify, reject, suspend, reinstate }

/// Compteurs du tableau de bord.
class AdminCounters {
  const AdminCounters({
    required this.pendingOrgs,
    required this.openReports,
    required this.pendingDeletions,
    required this.users,
    required this.verifiedOrgs,
    required this.activeSubscriptions,
    required this.dueCommissions,
  });

  final int pendingOrgs;
  final int openReports;
  final int pendingDeletions;
  final int users;
  final int verifiedOrgs;
  final int activeSubscriptions;
  final int dueCommissions;
}

class AdminRepository {
  AdminRepository(this._db, this._functions, this._storage);

  final FirebaseFirestore _db;
  final FirebaseFunctions _functions;
  final FirebaseStorage _storage;

  Future<int> _count(Query<Map<String, dynamic>> query) async =>
      (await query.count().get()).count ?? 0;

  Future<AdminCounters> counters() async {
    final orgs = _db.collection('organizations');
    final results = await Future.wait([
      _count(orgs.where('verification.status', isEqualTo: 'pending')),
      _count(_db.collection('reports').where('status', isEqualTo: 'open')),
      _count(_db.collection('deletionRequests').where('status', isEqualTo: 'pending')),
      _count(_db.collection('users')),
      _count(orgs.where('verification.status', isEqualTo: 'verified')),
      _count(_db.collection('subscriptions').where('status', isEqualTo: 'active')),
      _count(_db.collection('commissions').where('status', isEqualTo: 'due')),
    ]);
    return AdminCounters(
      pendingOrgs: results[0],
      openReports: results[1],
      pendingDeletions: results[2],
      users: results[3],
      verifiedOrgs: results[4],
      activeSubscriptions: results[5],
      dueCommissions: results[6],
    );
  }

  // ---------- Comptes ----------

  /// Comptes par statut. La file « pending » est servie dans l'ordre d'arrivée.
  Stream<List<Organization>> watchOrgs(VerificationStatus status) {
    final base = _db
        .collection('organizations')
        .where('verification.status', isEqualTo: status.name);
    final query = status == VerificationStatus.pending
        ? base.orderBy('verification.submittedAt')
        : base.orderBy('updatedAt', descending: true);
    return query
        .limit(100)
        .snapshots()
        .map((q) => q.docs.map((d) => fromDoc(d, Organization.fromJson)).toList());
  }

  /// Contenu d'une pièce justificative (lecture réservée au staff par les règles Storage).
  Future<Uint8List> documentBytes(String path) async {
    final data = await _storage.ref(path).getData(maxDocumentBytes);
    if (data == null) throw StateError('Pièce vide : $path');
    return data;
  }

  Future<void> reviewOrg(String orgId, OrgDecision decision, {String? note}) =>
      _functions.httpsCallable('reviewOrg').call<void>({
        'orgId': orgId,
        'decision': decision.name,
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  // ---------- Signalements ----------

  Stream<List<AdminRecord>> watchOpenReports() => _db
      .collection('reports')
      .where('status', isEqualTo: 'open')
      .orderBy('createdAt')
      .limit(100)
      .snapshots()
      .map((q) => q.docs.map(AdminRecord.fromDoc).toList());

  Future<void> closeReport(String reportId, {required bool resolved, required String staffUid, String? resolution}) =>
      _db.doc('reports/$reportId').update({
        'status': resolved ? 'resolved' : 'dismissed',
        'resolution': resolution?.trim() ?? '',
        'handledBy': staffUid,
        'updatedAt': FieldValue.serverTimestamp(),
      });

  // ---------- Suppression des données ----------

  Stream<List<AdminRecord>> watchPendingDeletions() => _db
      .collection('deletionRequests')
      .where('status', isEqualTo: 'pending')
      .orderBy('requestedAt')
      .limit(100)
      .snapshots()
      .map((q) => q.docs.map(AdminRecord.fromDoc).toList());

  Future<void> processDeletion(String requestId, {required bool accept, String? note}) =>
      _functions.httpsCallable('processDataDeletion').call<void>({
        'requestId': requestId,
        'decision': accept ? 'done' : 'refused',
        if (note != null && note.trim().isNotEmpty) 'note': note.trim(),
      });

  // ---------- Utilisateurs et rôles ----------

  Future<UserProfile?> user(String uid) async {
    final snap = await _db.doc('users/$uid').get();
    return snap.exists ? fromDoc(snap, UserProfile.fromJson) : null;
  }

  /// Recherche exacte par e-mail ou par téléphone (format international).
  Future<List<UserProfile>> searchUsers(String text) async {
    final value = text.trim();
    if (value.isEmpty) return const [];
    final field = value.contains('@') ? 'email' : 'phone';
    final q = await _db
        .collection('users')
        .where(field, isEqualTo: field == 'email' ? value.toLowerCase() : value)
        .limit(20)
        .get();
    return q.docs.map((d) => fromDoc(d, UserProfile.fromJson)).toList();
  }

  Stream<List<UserProfile>> watchStaff() => _db
      .collection('users')
      .where('staffRole', whereIn: ['admin', 'moderator'])
      .snapshots()
      .map((q) => q.docs.map((d) => fromDoc(d, UserProfile.fromJson)).toList());

  Future<void> setRole(String uid, String role) =>
      _functions.httpsCallable('setUserRole').call<void>({'uid': uid, 'role': role});

  // ---------- Catalogues ----------

  Stream<List<Map<String, dynamic>>> watchCatalog(String name) => _db
      .doc('catalog/$name')
      .snapshots()
      .map((s) => List<Map<String, dynamic>>.from((s.data()?['items'] as List?) ?? const []));

  Future<void> saveCatalog(String name, List<Map<String, dynamic>> items) => _db.doc('catalog/$name').set({
    'items': items,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  // ---------- Journal d'audit ----------

  Stream<List<AdminRecord>> watchAudit({String? targetRef}) {
    Query<Map<String, dynamic>> q = _db.collection('auditLogs');
    if (targetRef != null) q = q.where('targetRef', isEqualTo: targetRef);
    return q
        .orderBy('at', descending: true)
        .limit(100)
        .snapshots()
        .map((s) => s.docs.map(AdminRecord.fromDoc).toList());
  }
}

final adminRepositoryProvider = Provider<AdminRepository>(
  (ref) => AdminRepository(
    ref.watch(firestoreProvider),
    ref.watch(functionsProvider),
    ref.watch(storageProvider),
  ),
);

final adminCountersProvider = FutureProvider.autoDispose<AdminCounters>(
  (ref) => ref.watch(adminRepositoryProvider).counters(),
);

final adminOrgsProvider = StreamProvider.autoDispose.family<List<Organization>, VerificationStatus>(
  (ref, status) => ref.watch(adminRepositoryProvider).watchOrgs(status),
);

final openReportsProvider = StreamProvider.autoDispose<List<AdminRecord>>(
  (ref) => ref.watch(adminRepositoryProvider).watchOpenReports(),
);

final pendingDeletionsProvider = StreamProvider.autoDispose<List<AdminRecord>>(
  (ref) => ref.watch(adminRepositoryProvider).watchPendingDeletions(),
);

final staffProvider = StreamProvider.autoDispose<List<UserProfile>>(
  (ref) => ref.watch(adminRepositoryProvider).watchStaff(),
);

final catalogProvider = StreamProvider.autoDispose.family<List<Map<String, dynamic>>, String>(
  (ref, name) => ref.watch(adminRepositoryProvider).watchCatalog(name),
);

final auditProvider = StreamProvider.autoDispose.family<List<AdminRecord>, String?>(
  (ref, targetRef) => ref.watch(adminRepositoryProvider).watchAudit(targetRef: targetRef),
);

final adminUserProvider = FutureProvider.autoDispose.family<UserProfile?, String>(
  (ref, uid) => ref.watch(adminRepositoryProvider).user(uid),
);

/// Uid du membre de l'équipe connecté.
final staffUidProvider = Provider<String?>((ref) => ref.watch(authStateProvider).value?.uid);
