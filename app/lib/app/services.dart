import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/account/data/user_repository.dart';
import '../features/auth/data/auth_repository.dart';
import 'flavor.dart';

/// Clé publique Web Push (console Firebase → Cloud Messaging → Web Push), fournie au build.
const _vapidKey = String.fromEnvironment('FCM_VAPID_KEY');

/// App Check (voir docs/MISE_EN_PLACE.md) : désactivé tant que `--dart-define=APP_CHECK=true`
/// n'est pas passé au build, avec la clé reCAPTCHA Enterprise pour le web.
Future<void> activateAppCheck(Flavor flavor) async {
  const enabled = bool.fromEnvironment('APP_CHECK');
  const webKey = String.fromEnvironment('RECAPTCHA_ENTERPRISE_KEY');
  if (!enabled || flavor.useEmulators || (kIsWeb && webKey.isEmpty)) return;
  await FirebaseAppCheck.instance.activate(
    providerWeb: kIsWeb ? ReCaptchaEnterpriseProvider(webKey) : null,
    providerAndroid: kDebugMode ? const AndroidDebugProvider() : const AndroidPlayIntegrityProvider(),
  );
}

/// Enregistre l'appareil pour les notifications push dès que l'utilisateur est connecté.
final pushRegistrationProvider = Provider<void>((ref) {
  ref.listen(authStateProvider, (previous, next) {
    final uid = next.value?.uid;
    if (uid != null && previous?.value?.uid != uid) _register(ref.read(firestoreProvider), uid);
  }, fireImmediately: true);
});

Future<void> _register(FirebaseFirestore db, String uid) async {
  // Pas de push sur les émulateurs, ni sur le web sans clé Web Push.
  if (Flavor.current.useEmulators || (kIsWeb && _vapidKey.isEmpty)) return;
  try {
    final messaging = FirebaseMessaging.instance;
    final settings = await messaging.requestPermission();
    if (settings.authorizationStatus == AuthorizationStatus.denied) return;
    Future<void> save(String token) =>
        db.doc('users/$uid').update({'fcmTokens': FieldValue.arrayUnion([token])});
    // Jeton d'appareil (et non l'identifiant d'installation de register()) : c'est ce
    // qu'attend sendEachForMulticast dans la fonction onNotificationCreated.
    // ignore: deprecated_member_use
    final token = await messaging.getToken(vapidKey: kIsWeb ? _vapidKey : null);
    if (token != null) await save(token);
    // ignore: deprecated_member_use
    messaging.onTokenRefresh.listen(save);
  } catch (e) {
    // Les notifications restent visibles dans l'app même sans push.
    debugPrint('Notifications push indisponibles : $e');
  }
}
