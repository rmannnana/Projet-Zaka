import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Accès à Firebase Auth. La connexion par téléphone (OTP) viendra en phase 1.
class AuthRepository {
  AuthRepository(this._auth);

  final FirebaseAuth _auth;

  Stream<User?> authStateChanges() => _auth.idTokenChanges();

  User? get currentUser => _auth.currentUser;

  Future<void> signInWithEmail(String email, String password) =>
      _auth.signInWithEmailAndPassword(email: email.trim(), password: password);

  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required String displayName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(displayName.trim());
  }

  Future<void> signOut() => _auth.signOut();

  /// Rôle staff (`admin` ou `moderator`) porté par les custom claims.
  Future<String?> staffRole({bool refresh = false}) async {
    final token = await _auth.currentUser?.getIdTokenResult(refresh);
    return token?.claims?['role'] as String?;
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider)),
);

/// Utilisateur connecté (null si déconnecté).
final authStateProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChanges(),
);

/// Rôle staff de l'utilisateur connecté, relu à chaque changement de jeton.
final staffRoleProvider = FutureProvider<String?>((ref) async {
  final user = await ref.watch(authStateProvider.future);
  if (user == null) return null;
  return ref.read(authRepositoryProvider).staffRole();
});
