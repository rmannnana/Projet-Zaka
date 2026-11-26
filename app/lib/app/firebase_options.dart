import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'firebase_options_dev.dart' as dev;
import 'flavor.dart';

/// Options Firebase par environnement.
///
/// - dev avec émulateurs (par défaut) : projet local `demo-zaka`, sans compte Google ;
/// - dev sur le vrai projet (`--dart-define=USE_EMULATORS=false`) : `zaka-dev-01` ;
/// - staging (`zaka-staging`) et prod (`zaka-prod-8c5c8`) : pas encore configurés.
///
/// Pour configurer un environnement, lancer depuis `app/` :
///   `flutterfire configure --project=ID --platforms=android,web
///    --android-package-name=com.zaka.app[.ENV] --out=lib/app/firebase_options_ENV.dart
///    --android-out=android/app/src/ENV/google-services.json`
/// puis brancher le fichier généré ci-dessous.
FirebaseOptions firebaseOptionsFor(Flavor flavor) {
  if (flavor.useEmulators) return _demo;
  if (flavor == Flavor.dev) return dev.DefaultFirebaseOptions.currentPlatform;
  throw UnsupportedError(
    'Projet Firebase "${flavor.name}" non configuré. '
    'Voir lib/app/firebase_options.dart.',
  );
}

/// Valeurs factices acceptées par les émulateurs (projet "demo-*").
FirebaseOptions get _demo => FirebaseOptions(
  apiKey: 'demo-api-key',
  appId: kIsWeb ? '1:000000000000:web:0000000000000000' : '1:000000000000:android:0000000000000000',
  messagingSenderId: '000000000000',
  projectId: 'demo-zaka',
  storageBucket: 'demo-zaka.appspot.com',
);
