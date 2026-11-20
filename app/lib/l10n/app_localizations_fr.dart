// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'ZAKA';

  @override
  String get adminTitle => 'ZAKA Administration';

  @override
  String get navHome => 'Accueil';

  @override
  String get navHotels => 'Hôtels';

  @override
  String get navRealEstate => 'Immobilier';

  @override
  String get navAccount => 'Compte';

  @override
  String get homeHeadline => 'Trouvez un hôtel ou un bien immobilier';

  @override
  String get homeSubtitle =>
      'Hôtels, locations et ventes au Burkina Faso et dans l\'UEMOA';

  @override
  String get homeSearchHotels => 'Chercher un hôtel';

  @override
  String get homeSearchProperties => 'Chercher un bien';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get comingSoonBody => 'Cette section est en cours de construction.';

  @override
  String get accountSignedOut =>
      'Connectez-vous pour suivre vos demandes et publier vos annonces.';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signUp => 'Créer un compte';

  @override
  String get email => 'Adresse e-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get displayName => 'Nom complet';

  @override
  String get fieldRequired => 'Champ obligatoire';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String get passwordTooShort => 'Au moins 8 caractères';

  @override
  String get noAccountYet => 'Pas encore de compte ? Inscrivez-vous';

  @override
  String get alreadyHaveAccount => 'Déjà un compte ? Connectez-vous';

  @override
  String signedInAs(String name) {
    return 'Connecté en tant que $name';
  }

  @override
  String get adminDashboard => 'Tableau de bord';

  @override
  String get adminForbidden => 'Accès réservé à l\'équipe ZAKA.';

  @override
  String get testModeBanner => 'Mode test : aucun paiement réel';

  @override
  String get genericError => 'Une erreur est survenue. Réessayez.';
}
