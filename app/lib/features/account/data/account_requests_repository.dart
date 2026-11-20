import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/data/auth_repository.dart';
import 'user_repository.dart';

/// Notification affichée dans l'app (`users/{uid}/notifications`).
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.read,
    this.link,
    this.createdAt,
  });

  factory AppNotification.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data()!;
    return AppNotification(
      id: doc.id,
      title: d['title'] as String? ?? '',
      body: d['body'] as String? ?? '',
      link: d['link'] as String?,
      read: d['read'] as bool? ?? false,
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }

  final String id;
  final String title;
  final String body;
  final String? link;
  final bool read;
  final DateTime? createdAt;
}

/// Motifs proposés pour signaler une annonce ou un compte.
enum ReportReason { fraud, wrongInfo, unavailable, inappropriate, duplicate, other }

enum ReportTarget { hotel, property, project, organization }

class AccountRequestsRepository {
  AccountRequestsRepository(this._db);

  final FirebaseFirestore _db;

  Stream<List<AppNotification>> watchNotifications(String uid) => _db
      .collection('users/$uid/notifications')
      .orderBy('createdAt', descending: true)
      .limit(50)
      .snapshots()
      .map((q) => q.docs.map(AppNotification.fromDoc).toList());

  Future<void> markRead(String uid, String notificationId) =>
      _db.doc('users/$uid/notifications/$notificationId').update({'read': true});

  /// Demande en attente de traitement, s'il y en a une.
  Stream<bool> watchPendingDeletion(String uid) => _db
      .collection('deletionRequests')
      .where('uid', isEqualTo: uid)
      .where('status', isEqualTo: 'pending')
      .limit(1)
      .snapshots()
      .map((q) => q.docs.isNotEmpty);

  /// Demande d'effacement des données personnelles, traitée par un modérateur.
  Future<void> requestDeletion(String uid, {String? reason}) =>
      _db.collection('deletionRequests').add({
        'uid': uid,
        'status': 'pending',
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
        'requestedAt': FieldValue.serverTimestamp(),
      });

  Future<void> report({
    required String reporterUid,
    required ReportTarget target,
    required String targetId,
    required ReportReason reason,
    String? details,
  }) => _db.collection('reports').add({
    'targetType': target.name,
    'targetId': targetId,
    'reporterUid': reporterUid,
    'reason': _snake(reason.name),
    if (details != null && details.trim().isNotEmpty) 'details': details.trim(),
    'status': 'open',
    'createdAt': FieldValue.serverTimestamp(),
  });
}

String _snake(String camel) =>
    camel.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

final accountRequestsRepositoryProvider = Provider<AccountRequestsRepository>(
  (ref) => AccountRequestsRepository(ref.watch(firestoreProvider)),
);

final notificationsProvider = StreamProvider<List<AppNotification>>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(const []);
  return ref.watch(accountRequestsRepositoryProvider).watchNotifications(uid);
});

final unreadNotificationsProvider = Provider<int>(
  (ref) => ref.watch(notificationsProvider).value?.where((n) => !n.read).length ?? 0,
);

final pendingDeletionProvider = StreamProvider<bool>((ref) {
  final uid = ref.watch(authStateProvider).value?.uid;
  if (uid == null) return Stream.value(false);
  return ref.watch(accountRequestsRepositoryProvider).watchPendingDeletion(uid);
});
