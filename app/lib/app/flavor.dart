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
  /// Pour viser le vrai projet zaka-dev : `--dart-define=USE_EMULATORS=false`.
  bool get useEmulators =>
      this == Flavor.dev &&
      const bool.fromEnvironment('USE_EMULATORS', defaultValue: true);

  /// Hôte des émulateurs. Depuis l'émulateur Android : `--dart-define=EMULATOR_HOST=10.0.2.2`.
  static String get emulatorHost =>
      const String.fromEnvironment('EMULATOR_HOST', defaultValue: 'localhost');
}

/// Cible de l'application : l'app publique (clients + espaces pros)
/// ou le back-office d'administration (web uniquement).
enum AppTarget { public, admin }
