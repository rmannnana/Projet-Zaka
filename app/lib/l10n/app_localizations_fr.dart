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

  @override
  String get or => 'ou';

  @override
  String get save => 'Enregistrer';

  @override
  String get cancel => 'Annuler';

  @override
  String get methodPhone => 'Téléphone';

  @override
  String get methodEmail => 'E-mail';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get phoneNumber => 'Numéro de téléphone';

  @override
  String get phoneSendCode => 'Recevoir le code par SMS';

  @override
  String get phoneSmsNotice =>
      'Un SMS contenant un code à 6 chiffres vous sera envoyé. Numéros de la zone UEMOA uniquement.';

  @override
  String phoneInvalidForCountry(String country) {
    return 'Ce numéro ne correspond pas au pays choisi ($country).';
  }

  @override
  String phoneCodeSentTo(String phone) {
    return 'Code envoyé au $phone.';
  }

  @override
  String get phoneCode => 'Code à 6 chiffres';

  @override
  String get phoneVerify => 'Valider';

  @override
  String get phoneChangeNumber => 'Changer de numéro';

  @override
  String get phoneVerified => 'Numéro vérifié';

  @override
  String get verifyPhoneTitle => 'Vérifier mon numéro';

  @override
  String get verifyPhoneIntro =>
      'Un numéro vérifié est nécessaire pour publier une annonce en tant que particulier. Il permet aussi aux pros et aux clients de vous joindre.';

  @override
  String get accountAddPhone => 'Ajouter un numéro de téléphone';

  @override
  String get accountPhoneVerified => 'Numéro vérifié';

  @override
  String get accountEditName => 'Modifier mon nom';

  @override
  String get accountNoName => 'Ajoutez votre nom';
}
