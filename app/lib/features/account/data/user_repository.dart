import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/firestore_json.dart';
import '../../auth/data/auth_repository.dart';
import '../domain/user_profile.dart';

class UserRepository {
  UserRepository(this._db);

  final FirebaseFirestore _db;

  DocumentReference<Map<String, dynamic>> _doc(String uid) => _db.collection('users').doc(uid);

  /// Le document est créé côté serveur juste après l'inscription :
  /// il peut être absent pendant quelques instants.
  Stream<UserProfile?> watch(String uid) => _doc(uid).snapshots().map(
    (snap) => snap.exists ? fromDoc(snap, UserProfile.fromJson) : null,
  );

  /// Seuls ces champs sont modifiables par l'utilisateur (voir firestore.rules).
  Future<void> updateProfile(String uid, {String? displayName, String? photoUrl, String? country}) =>
      _doc(uid).update({
        'displayName': ?displayName,
        'photoUrl': ?photoUrl,
        'country': ?country,
        'updatedAt': FieldValue.serverTimestamp(),
      });
}

final firestoreProvider = Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => UserRepository(ref.watch(firestoreProvider)),
);

/// Profil de l'utilisateur connecté.
final currentUserProfileProvider = StreamProvider<UserProfile?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(userRepositoryProvider).watch(user.uid);
});
