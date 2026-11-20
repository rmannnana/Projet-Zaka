import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import 'flavor.dart';

/// Options Firebase par environnement.
///
/// Tant que les projets zaka-dev / zaka-staging / zaka-prod n'existent pas,
/// seul le projet de démonstration local `demo-zaka` est disponible : il
/// fonctionne uniquement avec les émulateurs Firebase et ne nécessite aucun
/// compte Google.
///
/// Quand les projets seront créés, lancer pour chaque environnement :
///   `flutterfire configure --project=zaka-ENV --out=lib/app/firebase_options_ENV.dart`
/// puis brancher les fichiers générés dans [firebaseOptionsFor].
FirebaseOptions firebaseOptionsFor(Flavor flavor) {
  if (flavor.useEmulators) return _demo;
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
