import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'firebase_options.dart';
import 'flavor.dart';

/// Région des Cloud Functions (voir docs/PLAN_CONCEPTION.md).
const functionsRegion = 'europe-west1';

/// Point d'entrée commun à l'app publique et au back-office.
Future<void> bootstrap(Widget app) async {
  WidgetsFlutterBinding.ensureInitialized();
  final flavor = Flavor.current;

  await Firebase.initializeApp(options: firebaseOptionsFor(flavor));
  if (flavor.useEmulators) await _connectEmulators();

  await initializeDateFormatting('fr');

  runApp(ProviderScope(child: app));
}

Future<void> _connectEmulators() async {
  final host = Flavor.emulatorHost;
  await FirebaseAuth.instance.useAuthEmulator(host, 9099);
  FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
  await FirebaseStorage.instance.useStorageEmulator(host, 9199);
  FirebaseFunctions.instanceFor(region: functionsRegion).useFunctionsEmulator(host, 5001);
}
