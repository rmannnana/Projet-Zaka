import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/bootstrap.dart';

/// Vérification d'un numéro en cours : le code reçu par SMS est à confirmer.
class PhoneVerification {
  PhoneVerification._(this._confirm, {this.autoVerified = false});

  /// Android a lu le SMS tout seul : rien à saisir.
  factory PhoneVerification._done() => PhoneVerification._((_) async {}, autoVerified: true);

  final Future<void> Function(String code) _confirm;
  final bool autoVerified;

  Future<void> confirm(String code) => _confirm(code.trim());
}

/// Accès à Firebase Auth : e-mail, téléphone (SMS) et Google.
class AuthRepository {
  AuthRepository(this._auth, this._functions);

  final FirebaseAuth _auth;
  final FirebaseFunctions _functions;

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

  Future<void> signInWithGoogle() async {
    final provider = GoogleAuthProvider()..setCustomParameters({'prompt': 'select_account'});
    if (kIsWeb) {
      await _auth.signInWithPopup(provider);
    } else {
      await _auth.signInWithProvider(provider);
    }
    await syncProfile();
  }

  /// Envoie un code par SMS au numéro [e164].
  ///
  /// Avec [link], le numéro est ajouté au compte connecté (obligatoire pour
  /// publier en tant que particulier) ; sinon l'utilisateur se connecte avec.
  Future<PhoneVerification> verifyPhone(String e164, {bool link = false}) async {
    Future<void> apply(AuthCredential credential) async {
      if (link) {
        await _auth.currentUser!.linkWithCredential(credential);
      } else {
        await _auth.signInWithCredential(credential);
      }
      await syncProfile();
    }

    if (kIsWeb) {
      // Le SDK web gère lui-même le reCAPTCHA invisible.
      final confirmation = link
          ? await _auth.currentUser!.linkWithPhoneNumber(e164)
          : await _auth.signInWithPhoneNumber(e164);
      return PhoneVerification._((code) async {
        await confirmation.confirm(code);
        await syncProfile();
      });
    }

    final completer = Completer<PhoneVerification>();
    await _auth.verifyPhoneNumber(
      phoneNumber: e164,
      verificationCompleted: (credential) async {
        try {
          await apply(credential);
          if (!completer.isCompleted) completer.complete(PhoneVerification._done());
        } catch (e, s) {
          if (!completer.isCompleted) completer.completeError(e, s);
        }
      },
      verificationFailed: (e) {
        if (!completer.isCompleted) completer.completeError(e);
      },
      codeSent: (verificationId, _) {
        if (completer.isCompleted) return;
        completer.complete(
          PhoneVerification._(
            (code) => apply(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code)),
          ),
        );
      },
      codeAutoRetrievalTimeout: (_) {},
    );
    return completer.future;
  }

  /// Recopie le téléphone et l'e-mail vérifiés dans le profil Firestore, et
  /// rafraîchit le jeton (le claim `phone_number` est exigé par certaines fonctions).
  Future<void> syncProfile() async {
    final user = _auth.currentUser;
    if (user == null) return;
    await user.getIdToken(true);
    try {
      await _functions.httpsCallable('syncProfileFromAuth').call<void>();
    } on FirebaseFunctionsException catch (e) {
      // Sans gravité : la connexion a réussi, la copie sera refaite plus tard.
      debugPrint('syncProfileFromAuth : ${e.code} ${e.message}');
    }
  }

  Future<void> signOut() => _auth.signOut();

  /// Rôle staff (`admin` ou `moderator`) porté par les custom claims.
  Future<String?> staffRole({bool refresh = false}) async {
    final token = await _auth.currentUser?.getIdTokenResult(refresh);
    return token?.claims?['role'] as String?;
  }
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

final functionsProvider = Provider<FirebaseFunctions>(
  (ref) => FirebaseFunctions.instanceFor(region: functionsRegion),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.watch(firebaseAuthProvider), ref.watch(functionsProvider)),
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

/// Message en français pour une erreur Firebase Auth.
String authErrorMessage(Object error) {
  final code = error is FirebaseAuthException ? error.code : null;
  return switch (code) {
    'invalid-credential' || 'wrong-password' || 'user-not-found' => 'E-mail ou mot de passe incorrect.',
    'email-already-in-use' => 'Un compte existe déjà avec cette adresse.',
    'weak-password' => 'Mot de passe trop faible.',
    'invalid-phone-number' => 'Numéro de téléphone invalide.',
    'invalid-verification-code' => 'Code incorrect. Vérifiez le SMS reçu.',
    'session-expired' || 'code-expired' => 'Code expiré. Demandez un nouveau code.',
    'credential-already-in-use' || 'provider-already-linked' =>
      'Ce numéro est déjà utilisé par un autre compte ZAKA.',
    'popup-closed-by-user' || 'web-context-canceled' || 'canceled' => 'Connexion annulée.',
    'account-exists-with-different-credential' =>
      'Un compte existe déjà avec cet e-mail. Connectez-vous avec votre mot de passe.',
    'network-request-failed' => 'Pas de connexion internet.',
    'too-many-requests' => 'Trop de tentatives. Réessayez dans quelques minutes.',
    _ => 'Une erreur est survenue. Réessayez.',
  };
}
