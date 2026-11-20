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

  @override
  String get proSpaces => 'Espaces pro';

  @override
  String get proSpacesEmptyHint => 'Publiez vos biens ou votre hôtel sur ZAKA';

  @override
  String proSpacesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count espaces',
      one: '1 espace',
    );
    return '$_temp0';
  }

  @override
  String get proCreate => 'Publier sur ZAKA';

  @override
  String get proEmpty =>
      'Vous n\'avez pas encore d\'espace pour publier. Créez-en un pour proposer vos biens ou votre hôtel.';

  @override
  String get proChooseType => 'Vous êtes :';

  @override
  String get proIndividualIntro =>
      'En tant que particulier, vous publiez vos biens sans document officiel. Chaque annonce est vérifiée par ZAKA avant sa mise en ligne.';

  @override
  String get proBusinessIntro =>
      'Créez le profil public de votre entreprise. Vous enverrez ensuite votre dossier de vérification (IFU, RCCM, justificatif de résidence).';

  @override
  String get proCreateSubmit => 'Créer l\'espace';

  @override
  String get orgTypeHotel => 'Hôtel';

  @override
  String get orgTypeAgency => 'Agence immobilière';

  @override
  String get orgTypeDeveloper => 'Promoteur immobilier';

  @override
  String get orgTypeIndividual => 'Particulier';

  @override
  String get orgTypeHotelHelp =>
      'Publiez vos chambres et recevez des demandes de réservation.';

  @override
  String get orgTypeAgencyHelp =>
      'Publiez des biens à louer ou à vendre pour vos clients.';

  @override
  String get orgTypeDeveloperHelp =>
      'Présentez vos programmes immobiliers et leurs lots.';

  @override
  String get orgTypeIndividualHelp =>
      'Louez ou vendez votre propre bien. Numéro de téléphone vérifié requis.';

  @override
  String get orgName => 'Nom de l\'entreprise';

  @override
  String get orgPublicName => 'Nom affiché sur vos annonces';

  @override
  String get orgPublicNameHelp =>
      'Par exemple votre prénom et l\'initiale de votre nom.';

  @override
  String get orgDescription => 'Présentation';

  @override
  String get country => 'Pays';

  @override
  String get city => 'Ville';

  @override
  String get address => 'Adresse ou quartier';

  @override
  String get contactPhone => 'Téléphone de contact';

  @override
  String get contactEmail => 'E-mail de contact (facultatif)';

  @override
  String get orgNotFound => 'Espace introuvable.';

  @override
  String get orgEditProfile => 'Profil public';

  @override
  String get orgMembers => 'Membres';

  @override
  String get orgListings => 'Annonces';

  @override
  String get statusDraft => 'Dossier à compléter';

  @override
  String get statusPending => 'En vérification';

  @override
  String get statusVerified => 'Vérifié';

  @override
  String get statusRejected => 'Dossier refusé';

  @override
  String get statusSuspended => 'Suspendu';

  @override
  String get statusDraftHelp =>
      'Envoyez votre dossier (IFU, RCCM, justificatif de résidence) pour pouvoir publier.';

  @override
  String get statusPendingHelp =>
      'Votre dossier est en cours de vérification par l\'équipe ZAKA.';

  @override
  String statusPendingSince(String date) {
    return 'Dossier envoyé le $date. L\'équipe ZAKA le vérifie.';
  }

  @override
  String get statusVerifiedHelp =>
      'Votre compte est vérifié : vos annonces sont publiées directement.';

  @override
  String get statusVerifiedIndividualHelp =>
      'Vous pouvez publier. Chaque annonce est vérifiée par ZAKA avant sa mise en ligne.';

  @override
  String statusRejectedHelp(String note) {
    return 'Votre dossier n\'a pas été validé. Motif : $note';
  }

  @override
  String statusSuspendedHelp(String note) {
    return 'Ce compte est suspendu. Motif : $note. Contactez ZAKA pour plus d\'informations.';
  }

  @override
  String get verificationFile => 'Dossier de vérification';

  @override
  String get verificationComplete => 'Compléter le dossier';

  @override
  String get verificationFix => 'Corriger le dossier';

  @override
  String get verificationIntro =>
      'Ces informations servent uniquement à vérifier votre entreprise. Elles ne sont pas affichées sur vos annonces.';

  @override
  String get verificationLocked =>
      'Le dossier ne peut plus être modifié à ce stade.';

  @override
  String get verificationSubmit => 'Envoyer le dossier';

  @override
  String get verificationSent =>
      'Dossier envoyé. Vous serez notifié de la décision.';

  @override
  String get verificationPrivacy =>
      'Vos pièces sont stockées dans un espace privé, accessible uniquement à votre équipe et aux modérateurs ZAKA.';

  @override
  String get legalInfo => 'Informations légales';

  @override
  String get ifuNumber => 'Numéro IFU';

  @override
  String get rccmNumber => 'Numéro RCCM';

  @override
  String get representativeName => 'Nom du représentant légal';

  @override
  String get documents => 'Pièces justificatives';

  @override
  String get documentsHelp => 'PDF ou photo lisible, 10 Mo au maximum.';

  @override
  String get documentIfu => 'Attestation IFU';

  @override
  String get documentRccm => 'Extrait RCCM';

  @override
  String get documentProofOfAddress =>
      'Contrat de bail ou justificatif de résidence';

  @override
  String get documentReceived => 'Pièce reçue';

  @override
  String get documentMissing => 'À fournir';

  @override
  String get documentsMissing =>
      'Ajoutez les trois pièces avant d\'envoyer le dossier.';

  @override
  String get documentBadType => 'Format accepté : PDF, JPG, PNG ou WEBP.';

  @override
  String get documentTooLarge => 'Fichier trop lourd (10 Mo au maximum).';

  @override
  String get choose => 'Choisir';

  @override
  String get replace => 'Remplacer';

  @override
  String get memberAdd => 'Ajouter un membre';

  @override
  String get memberAddHelp =>
      'La personne doit déjà avoir un compte ZAKA avec cette adresse e-mail.';

  @override
  String get memberRemove => 'Retirer';

  @override
  String memberRemoveConfirm(String name) {
    return 'Retirer $name de cet espace ?';
  }

  @override
  String get roleOwner => 'Propriétaire';

  @override
  String get roleEditor => 'Éditeur';

  @override
  String get notifications => 'Notifications';

  @override
  String get notificationsEmpty => 'Aucune notification pour le moment.';

  @override
  String get deleteAccount => 'Supprimer mon compte';

  @override
  String get deleteAccountPending => 'Demande en cours de traitement';

  @override
  String get deleteAccountExplain =>
      'Votre profil, vos favoris, vos photos et votre compte seront effacés sous 30 jours. Votre nom sera retiré de vos demandes passées, mais leurs dates et montants restent conservés pour la comptabilité et d\'éventuels litiges. Si vous êtes le seul propriétaire d\'un compte pro, ajoutez d\'abord un autre propriétaire.';

  @override
  String get deleteAccountReason => 'Motif (facultatif)';

  @override
  String get deleteAccountConfirm => 'Demander la suppression';

  @override
  String get deleteAccountSent =>
      'Demande envoyée. Vous serez informé de son traitement.';

  @override
  String get reportTitle => 'Signaler';

  @override
  String get reportFraud => 'Arnaque ou fraude';

  @override
  String get reportWrongInfo => 'Informations fausses ou trompeuses';

  @override
  String get reportUnavailable => 'N\'est plus disponible';

  @override
  String get reportInappropriate => 'Contenu inapproprié';

  @override
  String get reportDuplicate => 'Annonce en double';

  @override
  String get reportOther => 'Autre';

  @override
  String get reportDetails => 'Précisions (facultatif)';

  @override
  String get reportSend => 'Envoyer';

  @override
  String get reportSent => 'Merci, l\'équipe ZAKA va examiner ce signalement.';
}
