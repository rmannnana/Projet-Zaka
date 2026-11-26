/// Environnement d'exécution, choisi au lancement avec
/// `--dart-define=FLAVOR=dev|staging|prod` (et `--flavor` sur Android).
enum Flavor {
  dev,
  staging,
  prod;

  static Flavor get current {
    const value = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    return Flavor.values.firstWhere(
      (f) => f.name == value,
      orElse: () => throw StateError('FLAVOR inconnu : "$value"'),
    );
  }

  /// En dev, l'app parle aux émulateurs Firebase locaux par défaut.
  /// Pour viser le vrai projet zaka-dev-01 : `--dart-define=USE_EMULATORS=false`
  /// (sur le web, avec `--web-port 5000` : la clé d'API n'accepte que ce port en local).
  bool get useEmulators =>
      this == Flavor.dev &&
      const bool.fromEnvironment('USE_EMULATORS', defaultValue: true);

  /// Hôte des émulateurs. Depuis l'émulateur Android : `--dart-define=EMULATOR_HOST=10.0.2.2`.
  static String get emulatorHost =>
      const String.fromEnvironment('EMULATOR_HOST', defaultValue: 'localhost');

  /// Marques d'environnement : bandeau « DEV », nom « ZAKA Dev », version « -dev ».
  /// L'APK à partager les retire avec `--dart-define=ENV_MARKS=false`
  /// (option lue aussi par android/app/build.gradle.kts pour le nom et la version).
  static bool get envMarks => const bool.fromEnvironment('ENV_MARKS', defaultValue: true);

  /// Bandeau en haut à droite : hors production, sauf dans l'APK à partager.
  bool get showsBanner => this != Flavor.prod && envMarks;
}

/// Cible de l'application : l'app publique (clients + espaces pros)
/// ou le back-office d'administration (web uniquement).
enum AppTarget { public, admin }
