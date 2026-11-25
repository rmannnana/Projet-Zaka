import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @appTitle.
  ///
  /// In fr, this message translates to:
  /// **'ZAKA'**
  String get appTitle;

  /// No description provided for @adminTitle.
  ///
  /// In fr, this message translates to:
  /// **'ZAKA Administration'**
  String get adminTitle;

  /// No description provided for @navHome.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// No description provided for @navHotels.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels'**
  String get navHotels;

  /// No description provided for @navRealEstate.
  ///
  /// In fr, this message translates to:
  /// **'Immobilier'**
  String get navRealEstate;

  /// No description provided for @navAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get navAccount;

  /// No description provided for @homeHeadline.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez un hôtel ou un bien immobilier'**
  String get homeHeadline;

  /// No description provided for @homeSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels, locations et ventes au Burkina Faso et dans l\'UEMOA'**
  String get homeSubtitle;

  /// No description provided for @homeSearchHotels.
  ///
  /// In fr, this message translates to:
  /// **'Chercher un hôtel'**
  String get homeSearchHotels;

  /// No description provided for @homeSearchProperties.
  ///
  /// In fr, this message translates to:
  /// **'Chercher un bien'**
  String get homeSearchProperties;

  /// No description provided for @comingSoon.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get comingSoon;

  /// No description provided for @comingSoonBody.
  ///
  /// In fr, this message translates to:
  /// **'Cette section est en cours de construction.'**
  String get comingSoonBody;

  /// No description provided for @accountSignedOut.
  ///
  /// In fr, this message translates to:
  /// **'Connectez-vous pour suivre vos demandes et publier vos annonces.'**
  String get accountSignedOut;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @signOut.
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// No description provided for @signUp.
  ///
  /// In fr, this message translates to:
  /// **'Créer un compte'**
  String get signUp;

  /// No description provided for @email.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail'**
  String get email;

  /// No description provided for @password.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get password;

  /// No description provided for @displayName.
  ///
  /// In fr, this message translates to:
  /// **'Nom complet'**
  String get displayName;

  /// No description provided for @fieldRequired.
  ///
  /// In fr, this message translates to:
  /// **'Champ obligatoire'**
  String get fieldRequired;

  /// No description provided for @invalidEmail.
  ///
  /// In fr, this message translates to:
  /// **'Adresse e-mail invalide'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 caractères'**
  String get passwordTooShort;

  /// No description provided for @noAccountYet.
  ///
  /// In fr, this message translates to:
  /// **'Pas encore de compte ? Inscrivez-vous'**
  String get noAccountYet;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In fr, this message translates to:
  /// **'Déjà un compte ? Connectez-vous'**
  String get alreadyHaveAccount;

  /// No description provided for @signedInAs.
  ///
  /// In fr, this message translates to:
  /// **'Connecté en tant que {name}'**
  String signedInAs(String name);

  /// No description provided for @adminDashboard.
  ///
  /// In fr, this message translates to:
  /// **'Tableau de bord'**
  String get adminDashboard;

  /// No description provided for @adminForbidden.
  ///
  /// In fr, this message translates to:
  /// **'Accès réservé à l\'équipe ZAKA.'**
  String get adminForbidden;

  /// No description provided for @testModeBanner.
  ///
  /// In fr, this message translates to:
  /// **'Mode test : aucun paiement réel'**
  String get testModeBanner;

  /// No description provided for @genericError.
  ///
  /// In fr, this message translates to:
  /// **'Une erreur est survenue. Réessayez.'**
  String get genericError;

  /// No description provided for @or.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get or;

  /// No description provided for @save.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// No description provided for @methodPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone'**
  String get methodPhone;

  /// No description provided for @methodEmail.
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get methodEmail;

  /// No description provided for @continueWithGoogle.
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get continueWithGoogle;

  /// No description provided for @phoneNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro de téléphone'**
  String get phoneNumber;

  /// No description provided for @phoneSendCode.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir le code par SMS'**
  String get phoneSendCode;

  /// No description provided for @phoneSmsNotice.
  ///
  /// In fr, this message translates to:
  /// **'Un SMS contenant un code à 6 chiffres vous sera envoyé. Numéros de la zone UEMOA uniquement.'**
  String get phoneSmsNotice;

  /// No description provided for @phoneInvalidForCountry.
  ///
  /// In fr, this message translates to:
  /// **'Ce numéro ne correspond pas au pays choisi ({country}).'**
  String phoneInvalidForCountry(String country);

  /// No description provided for @phoneCodeSentTo.
  ///
  /// In fr, this message translates to:
  /// **'Code envoyé au {phone}.'**
  String phoneCodeSentTo(String phone);

  /// No description provided for @phoneCode.
  ///
  /// In fr, this message translates to:
  /// **'Code à 6 chiffres'**
  String get phoneCode;

  /// No description provided for @phoneVerify.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get phoneVerify;

  /// No description provided for @phoneChangeNumber.
  ///
  /// In fr, this message translates to:
  /// **'Changer de numéro'**
  String get phoneChangeNumber;

  /// No description provided for @phoneVerified.
  ///
  /// In fr, this message translates to:
  /// **'Numéro vérifié'**
  String get phoneVerified;

  /// No description provided for @verifyPhoneTitle.
  ///
  /// In fr, this message translates to:
  /// **'Vérifier mon numéro'**
  String get verifyPhoneTitle;

  /// No description provided for @verifyPhoneIntro.
  ///
  /// In fr, this message translates to:
  /// **'Un numéro vérifié est nécessaire pour publier une annonce en tant que particulier. Il permet aussi aux pros et aux clients de vous joindre.'**
  String get verifyPhoneIntro;

  /// No description provided for @accountAddPhone.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un numéro de téléphone'**
  String get accountAddPhone;

  /// No description provided for @accountPhoneVerified.
  ///
  /// In fr, this message translates to:
  /// **'Numéro vérifié'**
  String get accountPhoneVerified;

  /// No description provided for @accountEditName.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mon nom'**
  String get accountEditName;

  /// No description provided for @accountNoName.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez votre nom'**
  String get accountNoName;

  /// No description provided for @proSpaces.
  ///
  /// In fr, this message translates to:
  /// **'Espaces pro'**
  String get proSpaces;

  /// No description provided for @proSpacesEmptyHint.
  ///
  /// In fr, this message translates to:
  /// **'Publiez vos biens ou votre hôtel sur ZAKA'**
  String get proSpacesEmptyHint;

  /// No description provided for @proSpacesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 espace} other{{count} espaces}}'**
  String proSpacesCount(int count);

  /// No description provided for @proCreate.
  ///
  /// In fr, this message translates to:
  /// **'Publier sur ZAKA'**
  String get proCreate;

  /// No description provided for @proEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Vous n\'avez pas encore d\'espace pour publier. Créez-en un pour proposer vos biens ou votre hôtel.'**
  String get proEmpty;

  /// No description provided for @proChooseType.
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes :'**
  String get proChooseType;

  /// No description provided for @proIndividualIntro.
  ///
  /// In fr, this message translates to:
  /// **'En tant que particulier, vous publiez vos biens sans document officiel. Chaque annonce est vérifiée par ZAKA avant sa mise en ligne.'**
  String get proIndividualIntro;

  /// No description provided for @proBusinessIntro.
  ///
  /// In fr, this message translates to:
  /// **'Créez le profil public de votre entreprise. Vous enverrez ensuite votre dossier de vérification (IFU, RCCM, justificatif de résidence).'**
  String get proBusinessIntro;

  /// No description provided for @proCreateSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Créer l\'espace'**
  String get proCreateSubmit;

  /// No description provided for @orgTypeHotel.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel'**
  String get orgTypeHotel;

  /// No description provided for @orgTypeAgency.
  ///
  /// In fr, this message translates to:
  /// **'Agence immobilière'**
  String get orgTypeAgency;

  /// No description provided for @orgTypeDeveloper.
  ///
  /// In fr, this message translates to:
  /// **'Promoteur immobilier'**
  String get orgTypeDeveloper;

  /// No description provided for @orgTypeIndividual.
  ///
  /// In fr, this message translates to:
  /// **'Particulier'**
  String get orgTypeIndividual;

  /// No description provided for @orgTypeHotelHelp.
  ///
  /// In fr, this message translates to:
  /// **'Publiez vos chambres et recevez des demandes de réservation.'**
  String get orgTypeHotelHelp;

  /// No description provided for @orgTypeAgencyHelp.
  ///
  /// In fr, this message translates to:
  /// **'Publiez des biens à louer ou à vendre pour vos clients.'**
  String get orgTypeAgencyHelp;

  /// No description provided for @orgTypeDeveloperHelp.
  ///
  /// In fr, this message translates to:
  /// **'Présentez vos programmes immobiliers et leurs lots.'**
  String get orgTypeDeveloperHelp;

  /// No description provided for @orgTypeIndividualHelp.
  ///
  /// In fr, this message translates to:
  /// **'Louez ou vendez votre propre bien. Numéro de téléphone vérifié requis.'**
  String get orgTypeIndividualHelp;

  /// No description provided for @orgName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'entreprise'**
  String get orgName;

  /// No description provided for @orgPublicName.
  ///
  /// In fr, this message translates to:
  /// **'Nom affiché sur vos annonces'**
  String get orgPublicName;

  /// No description provided for @orgPublicNameHelp.
  ///
  /// In fr, this message translates to:
  /// **'Par exemple votre prénom et l\'initiale de votre nom.'**
  String get orgPublicNameHelp;

  /// No description provided for @orgDescription.
  ///
  /// In fr, this message translates to:
  /// **'Présentation'**
  String get orgDescription;

  /// No description provided for @country.
  ///
  /// In fr, this message translates to:
  /// **'Pays'**
  String get country;

  /// No description provided for @city.
  ///
  /// In fr, this message translates to:
  /// **'Ville'**
  String get city;

  /// No description provided for @address.
  ///
  /// In fr, this message translates to:
  /// **'Adresse ou quartier'**
  String get address;

  /// No description provided for @contactPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone de contact'**
  String get contactPhone;

  /// No description provided for @contactEmail.
  ///
  /// In fr, this message translates to:
  /// **'E-mail de contact (facultatif)'**
  String get contactEmail;

  /// No description provided for @orgNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Espace introuvable.'**
  String get orgNotFound;

  /// No description provided for @orgEditProfile.
  ///
  /// In fr, this message translates to:
  /// **'Profil public'**
  String get orgEditProfile;

  /// No description provided for @orgMembers.
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get orgMembers;

  /// No description provided for @orgListings.
  ///
  /// In fr, this message translates to:
  /// **'Annonces'**
  String get orgListings;

  /// No description provided for @statusDraft.
  ///
  /// In fr, this message translates to:
  /// **'Dossier à compléter'**
  String get statusDraft;

  /// No description provided for @statusPending.
  ///
  /// In fr, this message translates to:
  /// **'En vérification'**
  String get statusPending;

  /// No description provided for @statusVerified.
  ///
  /// In fr, this message translates to:
  /// **'Vérifié'**
  String get statusVerified;

  /// No description provided for @statusRejected.
  ///
  /// In fr, this message translates to:
  /// **'Dossier refusé'**
  String get statusRejected;

  /// No description provided for @statusSuspended.
  ///
  /// In fr, this message translates to:
  /// **'Suspendu'**
  String get statusSuspended;

  /// No description provided for @statusDraftHelp.
  ///
  /// In fr, this message translates to:
  /// **'Envoyez votre dossier (IFU, RCCM, justificatif de résidence) pour pouvoir publier.'**
  String get statusDraftHelp;

  /// No description provided for @statusPendingHelp.
  ///
  /// In fr, this message translates to:
  /// **'Votre dossier est en cours de vérification par l\'équipe ZAKA.'**
  String get statusPendingHelp;

  /// No description provided for @statusPendingSince.
  ///
  /// In fr, this message translates to:
  /// **'Dossier envoyé le {date}. L\'équipe ZAKA le vérifie.'**
  String statusPendingSince(String date);

  /// No description provided for @statusVerifiedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Votre compte est vérifié : vos annonces sont publiées directement.'**
  String get statusVerifiedHelp;

  /// No description provided for @statusVerifiedIndividualHelp.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez publier. Chaque annonce est vérifiée par ZAKA avant sa mise en ligne.'**
  String get statusVerifiedIndividualHelp;

  /// No description provided for @statusRejectedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Votre dossier n\'a pas été validé. Motif : {note}'**
  String statusRejectedHelp(String note);

  /// No description provided for @statusSuspendedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ce compte est suspendu. Motif : {note}. Contactez ZAKA pour plus d\'informations.'**
  String statusSuspendedHelp(String note);

  /// No description provided for @verificationFile.
  ///
  /// In fr, this message translates to:
  /// **'Dossier de vérification'**
  String get verificationFile;

  /// No description provided for @verificationComplete.
  ///
  /// In fr, this message translates to:
  /// **'Compléter le dossier'**
  String get verificationComplete;

  /// No description provided for @verificationFix.
  ///
  /// In fr, this message translates to:
  /// **'Corriger le dossier'**
  String get verificationFix;

  /// No description provided for @verificationIntro.
  ///
  /// In fr, this message translates to:
  /// **'Ces informations servent uniquement à vérifier votre entreprise. Elles ne sont pas affichées sur vos annonces.'**
  String get verificationIntro;

  /// No description provided for @verificationLocked.
  ///
  /// In fr, this message translates to:
  /// **'Le dossier ne peut plus être modifié à ce stade.'**
  String get verificationLocked;

  /// No description provided for @verificationSubmit.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le dossier'**
  String get verificationSubmit;

  /// No description provided for @verificationSent.
  ///
  /// In fr, this message translates to:
  /// **'Dossier envoyé. Vous serez notifié de la décision.'**
  String get verificationSent;

  /// No description provided for @verificationPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Vos pièces sont stockées dans un espace privé, accessible uniquement à votre équipe et aux modérateurs ZAKA.'**
  String get verificationPrivacy;

  /// No description provided for @legalInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations légales'**
  String get legalInfo;

  /// No description provided for @ifuNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro IFU'**
  String get ifuNumber;

  /// No description provided for @rccmNumber.
  ///
  /// In fr, this message translates to:
  /// **'Numéro RCCM'**
  String get rccmNumber;

  /// No description provided for @representativeName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du représentant légal'**
  String get representativeName;

  /// No description provided for @documents.
  ///
  /// In fr, this message translates to:
  /// **'Pièces justificatives'**
  String get documents;

  /// No description provided for @documentsHelp.
  ///
  /// In fr, this message translates to:
  /// **'PDF ou photo lisible, 10 Mo au maximum.'**
  String get documentsHelp;

  /// No description provided for @documentIfu.
  ///
  /// In fr, this message translates to:
  /// **'Attestation IFU'**
  String get documentIfu;

  /// No description provided for @documentRccm.
  ///
  /// In fr, this message translates to:
  /// **'Extrait RCCM'**
  String get documentRccm;

  /// No description provided for @documentProofOfAddress.
  ///
  /// In fr, this message translates to:
  /// **'Contrat de bail ou justificatif de résidence'**
  String get documentProofOfAddress;

  /// No description provided for @documentReceived.
  ///
  /// In fr, this message translates to:
  /// **'Pièce reçue'**
  String get documentReceived;

  /// No description provided for @documentMissing.
  ///
  /// In fr, this message translates to:
  /// **'À fournir'**
  String get documentMissing;

  /// No description provided for @documentsMissing.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez les trois pièces avant d\'envoyer le dossier.'**
  String get documentsMissing;

  /// No description provided for @documentBadType.
  ///
  /// In fr, this message translates to:
  /// **'Format accepté : PDF, JPG, PNG ou WEBP.'**
  String get documentBadType;

  /// No description provided for @documentTooLarge.
  ///
  /// In fr, this message translates to:
  /// **'Fichier trop lourd (10 Mo au maximum).'**
  String get documentTooLarge;

  /// No description provided for @choose.
  ///
  /// In fr, this message translates to:
  /// **'Choisir'**
  String get choose;

  /// No description provided for @replace.
  ///
  /// In fr, this message translates to:
  /// **'Remplacer'**
  String get replace;

  /// No description provided for @memberAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un membre'**
  String get memberAdd;

  /// No description provided for @memberAddHelp.
  ///
  /// In fr, this message translates to:
  /// **'La personne doit déjà avoir un compte ZAKA avec cette adresse e-mail.'**
  String get memberAddHelp;

  /// No description provided for @memberRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get memberRemove;

  /// No description provided for @memberRemoveConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Retirer {name} de cet espace ?'**
  String memberRemoveConfirm(String name);

  /// No description provided for @roleOwner.
  ///
  /// In fr, this message translates to:
  /// **'Propriétaire'**
  String get roleOwner;

  /// No description provided for @roleEditor.
  ///
  /// In fr, this message translates to:
  /// **'Éditeur'**
  String get roleEditor;

  /// No description provided for @notifications.
  ///
  /// In fr, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @notificationsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune notification pour le moment.'**
  String get notificationsEmpty;

  /// No description provided for @deleteAccount.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer mon compte'**
  String get deleteAccount;

  /// No description provided for @deleteAccountPending.
  ///
  /// In fr, this message translates to:
  /// **'Demande en cours de traitement'**
  String get deleteAccountPending;

  /// No description provided for @deleteAccountExplain.
  ///
  /// In fr, this message translates to:
  /// **'Votre profil, vos favoris, vos photos et votre compte seront effacés sous 30 jours. Votre nom sera retiré de vos demandes passées, mais leurs dates et montants restent conservés pour la comptabilité et d\'éventuels litiges. Si vous êtes le seul propriétaire d\'un compte pro, ajoutez d\'abord un autre propriétaire.'**
  String get deleteAccountExplain;

  /// No description provided for @deleteAccountReason.
  ///
  /// In fr, this message translates to:
  /// **'Motif (facultatif)'**
  String get deleteAccountReason;

  /// No description provided for @deleteAccountConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Demander la suppression'**
  String get deleteAccountConfirm;

  /// No description provided for @deleteAccountSent.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée. Vous serez informé de son traitement.'**
  String get deleteAccountSent;

  /// No description provided for @reportTitle.
  ///
  /// In fr, this message translates to:
  /// **'Signaler'**
  String get reportTitle;

  /// No description provided for @reportFraud.
  ///
  /// In fr, this message translates to:
  /// **'Arnaque ou fraude'**
  String get reportFraud;

  /// No description provided for @reportWrongInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations fausses ou trompeuses'**
  String get reportWrongInfo;

  /// No description provided for @reportUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'N\'est plus disponible'**
  String get reportUnavailable;

  /// No description provided for @reportInappropriate.
  ///
  /// In fr, this message translates to:
  /// **'Contenu inapproprié'**
  String get reportInappropriate;

  /// No description provided for @reportDuplicate.
  ///
  /// In fr, this message translates to:
  /// **'Annonce en double'**
  String get reportDuplicate;

  /// No description provided for @reportOther.
  ///
  /// In fr, this message translates to:
  /// **'Autre'**
  String get reportOther;

  /// No description provided for @reportDetails.
  ///
  /// In fr, this message translates to:
  /// **'Précisions (facultatif)'**
  String get reportDetails;

  /// No description provided for @reportSend.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get reportSend;

  /// No description provided for @reportSent.
  ///
  /// In fr, this message translates to:
  /// **'Merci, l\'équipe ZAKA va examiner ce signalement.'**
  String get reportSent;

  /// No description provided for @billingSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Abonnement'**
  String get billingSubscription;

  /// No description provided for @billingCurrentPlan.
  ///
  /// In fr, this message translates to:
  /// **'Plan actuel'**
  String get billingCurrentPlan;

  /// No description provided for @billingFreePlanHelp.
  ///
  /// In fr, this message translates to:
  /// **'Le plan Gratuit s\'applique tant qu\'aucun abonnement payant n\'est en cours.'**
  String get billingFreePlanHelp;

  /// No description provided for @billingActiveUntil.
  ///
  /// In fr, this message translates to:
  /// **'Actif jusqu\'au {date}'**
  String billingActiveUntil(String date);

  /// No description provided for @billingPlanUntil.
  ///
  /// In fr, this message translates to:
  /// **'{plan} · jusqu\'au {date}'**
  String billingPlanUntil(String plan, String date);

  /// No description provided for @billingAvailablePlans.
  ///
  /// In fr, this message translates to:
  /// **'Plans disponibles'**
  String get billingAvailablePlans;

  /// No description provided for @billingNoPlans.
  ///
  /// In fr, this message translates to:
  /// **'Aucun plan payant n\'est proposé pour le moment.'**
  String get billingNoPlans;

  /// No description provided for @billingFree.
  ///
  /// In fr, this message translates to:
  /// **'Gratuit'**
  String get billingFree;

  /// No description provided for @billingPricePerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{price} par mois'**
  String billingPricePerMonth(String price);

  /// No description provided for @billingPricePerYear.
  ///
  /// In fr, this message translates to:
  /// **'{price} par an'**
  String billingPricePerYear(String price);

  /// No description provided for @billingMaxListings.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 annonce publiée à la fois} other{{count} annonces publiées à la fois}}'**
  String billingMaxListings(int count);

  /// No description provided for @billingUnlimitedListings.
  ///
  /// In fr, this message translates to:
  /// **'Annonces illimitées'**
  String get billingUnlimitedListings;

  /// No description provided for @billingFeaturedListings.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Pas de mise en avant} =1{1 annonce mise en avant} other{{count} annonces mises en avant}}'**
  String billingFeaturedListings(int count);

  /// No description provided for @billingAdvancedStats.
  ///
  /// In fr, this message translates to:
  /// **'Statistiques détaillées'**
  String get billingAdvancedStats;

  /// No description provided for @billingChoose.
  ///
  /// In fr, this message translates to:
  /// **'Choisir'**
  String get billingChoose;

  /// No description provided for @billingRenew.
  ///
  /// In fr, this message translates to:
  /// **'Renouveler'**
  String get billingRenew;

  /// No description provided for @billingOwnerOnly.
  ///
  /// In fr, this message translates to:
  /// **'Seul un propriétaire du compte peut changer d\'abonnement.'**
  String get billingOwnerOnly;

  /// No description provided for @billingNeedsVerification.
  ///
  /// In fr, this message translates to:
  /// **'Les abonnements sont disponibles une fois votre compte vérifié.'**
  String get billingNeedsVerification;

  /// No description provided for @billingConfirmTitle.
  ///
  /// In fr, this message translates to:
  /// **'Plan {plan}'**
  String billingConfirmTitle(String plan);

  /// No description provided for @billingConfirmMonth.
  ///
  /// In fr, this message translates to:
  /// **'{price} pour 1 mois.'**
  String billingConfirmMonth(String price);

  /// No description provided for @billingConfirmYear.
  ///
  /// In fr, this message translates to:
  /// **'{price} pour 1 an.'**
  String billingConfirmYear(String price);

  /// No description provided for @billingRenewInfo.
  ///
  /// In fr, this message translates to:
  /// **'La nouvelle période s\'ajoutera à la période en cours, qui se termine le {date}.'**
  String billingRenewInfo(String date);

  /// No description provided for @billingReplaceWarning.
  ///
  /// In fr, this message translates to:
  /// **'Votre abonnement {plan} sera remplacé dès le paiement, sans remboursement de la période restante.'**
  String billingReplaceWarning(String plan);

  /// No description provided for @billingContinueToPayment.
  ///
  /// In fr, this message translates to:
  /// **'Continuer vers le paiement'**
  String get billingContinueToPayment;

  /// No description provided for @billingPaymentHistory.
  ///
  /// In fr, this message translates to:
  /// **'Historique des paiements'**
  String get billingPaymentHistory;

  /// No description provided for @billingNoPayments.
  ///
  /// In fr, this message translates to:
  /// **'Aucun paiement pour le moment.'**
  String get billingNoPayments;

  /// No description provided for @paymentStatusPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get paymentStatusPending;

  /// No description provided for @paymentStatusSucceeded.
  ///
  /// In fr, this message translates to:
  /// **'Réussi'**
  String get paymentStatusSucceeded;

  /// No description provided for @paymentStatusFailed.
  ///
  /// In fr, this message translates to:
  /// **'Échoué'**
  String get paymentStatusFailed;

  /// No description provided for @paymentStatusCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulé'**
  String get paymentStatusCancelled;

  /// No description provided for @checkoutTitle.
  ///
  /// In fr, this message translates to:
  /// **'Paiement'**
  String get checkoutTitle;

  /// No description provided for @checkoutTestBanner.
  ///
  /// In fr, this message translates to:
  /// **'Mode test : aucun paiement réel'**
  String get checkoutTestBanner;

  /// No description provided for @checkoutTestExplain.
  ///
  /// In fr, this message translates to:
  /// **'Le paiement par Mobile Money ou carte arrivera plus tard. Pour l\'instant, choisissez l\'issue à simuler : aucun argent ne circule.'**
  String get checkoutTestExplain;

  /// No description provided for @checkoutSimulateSuccess.
  ///
  /// In fr, this message translates to:
  /// **'Simuler un paiement réussi'**
  String get checkoutSimulateSuccess;

  /// No description provided for @checkoutSimulateFailure.
  ///
  /// In fr, this message translates to:
  /// **'Simuler un échec'**
  String get checkoutSimulateFailure;

  /// No description provided for @checkoutCancel.
  ///
  /// In fr, this message translates to:
  /// **'Annuler le paiement'**
  String get checkoutCancel;

  /// No description provided for @checkoutSucceeded.
  ///
  /// In fr, this message translates to:
  /// **'Paiement accepté'**
  String get checkoutSucceeded;

  /// No description provided for @checkoutSucceededUntil.
  ///
  /// In fr, this message translates to:
  /// **'Votre abonnement est actif jusqu\'au {date}.'**
  String checkoutSucceededUntil(String date);

  /// No description provided for @checkoutFailed.
  ///
  /// In fr, this message translates to:
  /// **'Paiement refusé'**
  String get checkoutFailed;

  /// No description provided for @checkoutFailedBody.
  ///
  /// In fr, this message translates to:
  /// **'Aucun montant n\'a été débité. Vous pouvez réessayer depuis la page Abonnement.'**
  String get checkoutFailedBody;

  /// No description provided for @checkoutCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Paiement annulé'**
  String get checkoutCancelled;

  /// No description provided for @checkoutBackToSubscription.
  ///
  /// In fr, this message translates to:
  /// **'Retour à l\'abonnement'**
  String get checkoutBackToSubscription;

  /// No description provided for @checkoutNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Paiement introuvable.'**
  String get checkoutNotFound;

  /// No description provided for @commissionsTitle.
  ///
  /// In fr, this message translates to:
  /// **'Commissions'**
  String get commissionsTitle;

  /// No description provided for @commissionsHelp.
  ///
  /// In fr, this message translates to:
  /// **'ZAKA perçoit une commission sur chaque séjour terminé, réservé via ZAKA. Elle est calculée avec le taux en vigueur à la fin du séjour.'**
  String get commissionsHelp;

  /// No description provided for @commissionsOutstanding.
  ///
  /// In fr, this message translates to:
  /// **'Reste à régler'**
  String get commissionsOutstanding;

  /// No description provided for @commissionsEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucune commission pour le moment.'**
  String get commissionsEmpty;

  /// No description provided for @commissionOn.
  ///
  /// In fr, this message translates to:
  /// **'Sur {amount}'**
  String commissionOn(String amount);

  /// No description provided for @commissionStatusDue.
  ///
  /// In fr, this message translates to:
  /// **'Due'**
  String get commissionStatusDue;

  /// No description provided for @commissionStatusInvoiced.
  ///
  /// In fr, this message translates to:
  /// **'Facturée'**
  String get commissionStatusInvoiced;

  /// No description provided for @commissionStatusPaid.
  ///
  /// In fr, this message translates to:
  /// **'Payée'**
  String get commissionStatusPaid;

  /// No description provided for @commissionStatusWaived.
  ///
  /// In fr, this message translates to:
  /// **'Offerte'**
  String get commissionStatusWaived;

  /// No description provided for @accept.
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get accept;

  /// No description provided for @reject.
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get reject;

  /// No description provided for @all.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
  String get all;

  /// No description provided for @any.
  ///
  /// In fr, this message translates to:
  /// **'Peu importe'**
  String get any;

  /// No description provided for @apply.
  ///
  /// In fr, this message translates to:
  /// **'Appliquer'**
  String get apply;

  /// No description provided for @close.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @delete.
  ///
  /// In fr, this message translates to:
  /// **'Supprimer'**
  String get delete;

  /// No description provided for @description.
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @send.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer'**
  String get send;

  /// No description provided for @sending.
  ///
  /// In fr, this message translates to:
  /// **'Envoi…'**
  String get sending;

  /// No description provided for @saved.
  ///
  /// In fr, this message translates to:
  /// **'Modifications enregistrées.'**
  String get saved;

  /// No description provided for @search.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher'**
  String get search;

  /// No description provided for @seeAll.
  ///
  /// In fr, this message translates to:
  /// **'Tout voir'**
  String get seeAll;

  /// No description provided for @explore.
  ///
  /// In fr, this message translates to:
  /// **'Explorer'**
  String get explore;

  /// No description provided for @requiredField.
  ///
  /// In fr, this message translates to:
  /// **'Champ obligatoire'**
  String get requiredField;

  /// No description provided for @call.
  ///
  /// In fr, this message translates to:
  /// **'Appeler'**
  String get call;

  /// No description provided for @location.
  ///
  /// In fr, this message translates to:
  /// **'Emplacement'**
  String get location;

  /// No description provided for @district.
  ///
  /// In fr, this message translates to:
  /// **'Quartier'**
  String get district;

  /// No description provided for @allCities.
  ///
  /// In fr, this message translates to:
  /// **'Toutes les villes'**
  String get allCities;

  /// No description provided for @price.
  ///
  /// In fr, this message translates to:
  /// **'Prix'**
  String get price;

  /// No description provided for @priceSection.
  ///
  /// In fr, this message translates to:
  /// **'Prix et conditions'**
  String get priceSection;

  /// No description provided for @legalTerms.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'utilisation'**
  String get legalTerms;

  /// No description provided for @legalPrivacy.
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get legalPrivacy;

  /// No description provided for @navRequests.
  ///
  /// In fr, this message translates to:
  /// **'Demandes'**
  String get navRequests;

  /// No description provided for @favorites.
  ///
  /// In fr, this message translates to:
  /// **'Favoris'**
  String get favorites;

  /// No description provided for @favoriteAdd.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter aux favoris'**
  String get favoriteAdd;

  /// No description provided for @favoriteRemove.
  ///
  /// In fr, this message translates to:
  /// **'Retirer des favoris'**
  String get favoriteRemove;

  /// No description provided for @noFavorite.
  ///
  /// In fr, this message translates to:
  /// **'Aucun favori pour le moment'**
  String get noFavorite;

  /// No description provided for @noFavoriteHint.
  ///
  /// In fr, this message translates to:
  /// **'Touchez le cœur d\'une annonce pour la retrouver ici.'**
  String get noFavoriteHint;

  /// No description provided for @featured.
  ///
  /// In fr, this message translates to:
  /// **'À la une'**
  String get featured;

  /// No description provided for @publishedBy.
  ///
  /// In fr, this message translates to:
  /// **'Publié par {name}'**
  String publishedBy(String name);

  /// No description provided for @listingUnavailable.
  ///
  /// In fr, this message translates to:
  /// **'Cette annonce n\'est pas disponible.'**
  String get listingUnavailable;

  /// No description provided for @requestNotFound.
  ///
  /// In fr, this message translates to:
  /// **'Demande introuvable.'**
  String get requestNotFound;

  /// No description provided for @homeFeaturedHotels.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels à la une'**
  String get homeFeaturedHotels;

  /// No description provided for @homeFeaturedProperties.
  ///
  /// In fr, this message translates to:
  /// **'Biens à la une'**
  String get homeFeaturedProperties;

  /// No description provided for @homeNoHotelsYet.
  ///
  /// In fr, this message translates to:
  /// **'Les premiers hôtels arrivent bientôt sur ZAKA.'**
  String get homeNoHotelsYet;

  /// No description provided for @homeNoPropertiesYet.
  ///
  /// In fr, this message translates to:
  /// **'Les premières annonces arrivent bientôt sur ZAKA.'**
  String get homeNoPropertiesYet;

  /// No description provided for @homeProTitle.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel, agence, promoteur ou propriétaire ?'**
  String get homeProTitle;

  /// No description provided for @homeProBody.
  ///
  /// In fr, this message translates to:
  /// **'Publiez vos chambres et vos biens sur ZAKA et recevez des demandes de clients vérifiés.'**
  String get homeProBody;

  /// No description provided for @homeProAction.
  ///
  /// In fr, this message translates to:
  /// **'Publier sur ZAKA'**
  String get homeProAction;

  /// No description provided for @rent.
  ///
  /// In fr, this message translates to:
  /// **'Louer'**
  String get rent;

  /// No description provided for @buy.
  ///
  /// In fr, this message translates to:
  /// **'Acheter'**
  String get buy;

  /// No description provided for @forRent.
  ///
  /// In fr, this message translates to:
  /// **'À louer'**
  String get forRent;

  /// No description provided for @forSale.
  ///
  /// In fr, this message translates to:
  /// **'À vendre'**
  String get forSale;

  /// No description provided for @newProjects.
  ///
  /// In fr, this message translates to:
  /// **'Programmes neufs'**
  String get newProjects;

  /// No description provided for @newProject.
  ///
  /// In fr, this message translates to:
  /// **'Programme neuf'**
  String get newProject;

  /// No description provided for @chooseDates.
  ///
  /// In fr, this message translates to:
  /// **'Choisir les dates'**
  String get chooseDates;

  /// No description provided for @chooseYourDates.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez vos dates d\'arrivée et de départ.'**
  String get chooseYourDates;

  /// No description provided for @guests.
  ///
  /// In fr, this message translates to:
  /// **'Voyageurs'**
  String get guests;

  /// No description provided for @guestsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 voyageur} other{{count} voyageurs}}'**
  String guestsCount(int count);

  /// No description provided for @filters.
  ///
  /// In fr, this message translates to:
  /// **'Filtres'**
  String get filters;

  /// No description provided for @filtersCount.
  ///
  /// In fr, this message translates to:
  /// **'Filtres ({count})'**
  String filtersCount(int count);

  /// No description provided for @maxPricePerNight.
  ///
  /// In fr, this message translates to:
  /// **'Budget maximum par nuit'**
  String get maxPricePerNight;

  /// No description provided for @maxBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget maximum'**
  String get maxBudget;

  /// No description provided for @anyBudget.
  ///
  /// In fr, this message translates to:
  /// **'Tous budgets'**
  String get anyBudget;

  /// No description provided for @amenities.
  ///
  /// In fr, this message translates to:
  /// **'Équipements'**
  String get amenities;

  /// No description provided for @showResults.
  ///
  /// In fr, this message translates to:
  /// **'Voir les résultats'**
  String get showResults;

  /// No description provided for @hotelsFound.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 hôtel trouvé} other{{count} hôtels trouvés}}'**
  String hotelsFound(int count);

  /// No description provided for @noHotelFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun hôtel ne correspond à votre recherche'**
  String get noHotelFound;

  /// No description provided for @noHotelFoundHint.
  ///
  /// In fr, this message translates to:
  /// **'Essayez une autre ville ou retirez des filtres.'**
  String get noHotelFoundHint;

  /// No description provided for @propertyType.
  ///
  /// In fr, this message translates to:
  /// **'Type de bien'**
  String get propertyType;

  /// No description provided for @allTypes.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get allTypes;

  /// No description provided for @minRooms.
  ///
  /// In fr, this message translates to:
  /// **'Pièces au minimum'**
  String get minRooms;

  /// No description provided for @furnishedOnly.
  ///
  /// In fr, this message translates to:
  /// **'Meublé uniquement'**
  String get furnishedOnly;

  /// No description provided for @noPropertyFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun bien ne correspond à votre recherche'**
  String get noPropertyFound;

  /// No description provided for @noPropertyFoundHint.
  ///
  /// In fr, this message translates to:
  /// **'Élargissez la recherche à une autre ville ou un autre budget.'**
  String get noPropertyFoundHint;

  /// No description provided for @noProjectFound.
  ///
  /// In fr, this message translates to:
  /// **'Aucun programme neuf pour le moment'**
  String get noProjectFound;

  /// No description provided for @priceFromPerNight.
  ///
  /// In fr, this message translates to:
  /// **'À partir de {price} / nuit'**
  String priceFromPerNight(String price);

  /// No description provided for @pricePerNight.
  ///
  /// In fr, this message translates to:
  /// **'{price} / nuit'**
  String pricePerNight(String price);

  /// No description provided for @pricePerMonth.
  ///
  /// In fr, this message translates to:
  /// **'{price} / mois'**
  String pricePerMonth(String price);

  /// No description provided for @pricePerDay.
  ///
  /// In fr, this message translates to:
  /// **'{price} / jour'**
  String pricePerDay(String price);

  /// No description provided for @priceFrom.
  ///
  /// In fr, this message translates to:
  /// **'À partir de {price}'**
  String priceFrom(String price);

  /// No description provided for @rooms.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get rooms;

  /// No description provided for @noRoomAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Aucune chambre proposée pour le moment.'**
  String get noRoomAvailable;

  /// No description provided for @roomCapacity.
  ///
  /// In fr, this message translates to:
  /// **'{adults, plural, =1{1 adulte} other{{adults} adultes}}{children, plural, =0{} =1{ + 1 enfant} other{ + {children} enfants}}'**
  String roomCapacity(int adults, int children);

  /// No description provided for @requestThisRoom.
  ///
  /// In fr, this message translates to:
  /// **'Demander'**
  String get requestThisRoom;

  /// No description provided for @hotelRules.
  ///
  /// In fr, this message translates to:
  /// **'Règles de l\'hôtel'**
  String get hotelRules;

  /// No description provided for @checkInFrom.
  ///
  /// In fr, this message translates to:
  /// **'Arrivée à partir de {time}'**
  String checkInFrom(String time);

  /// No description provided for @checkOutBefore.
  ///
  /// In fr, this message translates to:
  /// **'Départ avant {time}'**
  String checkOutBefore(String time);

  /// No description provided for @petsAllowed.
  ///
  /// In fr, this message translates to:
  /// **'Animaux acceptés'**
  String get petsAllowed;

  /// No description provided for @petsNotAllowed.
  ///
  /// In fr, this message translates to:
  /// **'Animaux non acceptés'**
  String get petsNotAllowed;

  /// No description provided for @cancellationPolicy.
  ///
  /// In fr, this message translates to:
  /// **'Annulation : {policy}'**
  String cancellationPolicy(String policy);

  /// No description provided for @offerUntil.
  ///
  /// In fr, this message translates to:
  /// **'Jusqu\'au {date}'**
  String offerUntil(String date);

  /// No description provided for @bookingConfirmationNotice.
  ///
  /// In fr, this message translates to:
  /// **'Chaque demande est confirmée par l\'hôtel, qui répond sous 48 h.'**
  String get bookingConfirmationNotice;

  /// No description provided for @bookingRequestTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande de réservation'**
  String get bookingRequestTitle;

  /// No description provided for @adults.
  ///
  /// In fr, this message translates to:
  /// **'Adultes'**
  String get adults;

  /// No description provided for @children.
  ///
  /// In fr, this message translates to:
  /// **'Enfants'**
  String get children;

  /// No description provided for @roomsCount.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get roomsCount;

  /// No description provided for @messageToHotel.
  ///
  /// In fr, this message translates to:
  /// **'Message à l\'hôtel (facultatif)'**
  String get messageToHotel;

  /// No description provided for @messageToHotelHint.
  ///
  /// In fr, this message translates to:
  /// **'Heure d\'arrivée, demande particulière…'**
  String get messageToHotelHint;

  /// No description provided for @estimatedTotal.
  ///
  /// In fr, this message translates to:
  /// **'Total estimé'**
  String get estimatedTotal;

  /// No description provided for @estimateDetail.
  ///
  /// In fr, this message translates to:
  /// **'{price} × {nights, plural, =1{1 nuit} other{{nights} nuits}} × {rooms, plural, =1{1 chambre} other{{rooms} chambres}}'**
  String estimateDetail(String price, int nights, int rooms);

  /// No description provided for @nightsCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 nuit} other{{count} nuits}}'**
  String nightsCount(int count);

  /// No description provided for @bookingRequestNotice.
  ///
  /// In fr, this message translates to:
  /// **'Ceci est une demande : l\'hôtel confirme la disponibilité et le prix. Vous ne payez rien pour l\'instant.'**
  String get bookingRequestNotice;

  /// No description provided for @sendRequest.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer la demande'**
  String get sendRequest;

  /// No description provided for @bookingSentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée'**
  String get bookingSentTitle;

  /// No description provided for @bookingSentBody.
  ///
  /// In fr, this message translates to:
  /// **'{hotel} a jusqu\'au {deadline} pour vous répondre. Vous serez prévenu dès sa réponse.'**
  String bookingSentBody(String hotel, String deadline);

  /// No description provided for @seeMyRequest.
  ///
  /// In fr, this message translates to:
  /// **'Voir ma demande'**
  String get seeMyRequest;

  /// No description provided for @askVisit.
  ///
  /// In fr, this message translates to:
  /// **'Demander une visite'**
  String get askVisit;

  /// No description provided for @askInformation.
  ///
  /// In fr, this message translates to:
  /// **'Demander des informations'**
  String get askInformation;

  /// No description provided for @surfaceValue.
  ///
  /// In fr, this message translates to:
  /// **'{value} m²'**
  String surfaceValue(int value);

  /// No description provided for @roomsValue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 pièce} other{{count} pièces}}'**
  String roomsValue(int count);

  /// No description provided for @bedroomsValue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 chambre} other{{count} chambres}}'**
  String bedroomsValue(int count);

  /// No description provided for @bathroomsValue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 salle d\'eau} other{{count} salles d\'eau}}'**
  String bathroomsValue(int count);

  /// No description provided for @features.
  ///
  /// In fr, this message translates to:
  /// **'Atouts'**
  String get features;

  /// No description provided for @rentConditions.
  ///
  /// In fr, this message translates to:
  /// **'Conditions de location'**
  String get rentConditions;

  /// No description provided for @depositValue.
  ///
  /// In fr, this message translates to:
  /// **'Caution : {value}'**
  String depositValue(String value);

  /// No description provided for @advanceValue.
  ///
  /// In fr, this message translates to:
  /// **'Avance : {value}'**
  String advanceValue(String value);

  /// No description provided for @agencyFeesValue.
  ///
  /// In fr, this message translates to:
  /// **'Frais d\'agence : {value}'**
  String agencyFeesValue(String value);

  /// No description provided for @publisher.
  ///
  /// In fr, this message translates to:
  /// **'Annonceur'**
  String get publisher;

  /// No description provided for @verifiedProfessional.
  ///
  /// In fr, this message translates to:
  /// **'Professionnel vérifié par ZAKA'**
  String get verifiedProfessional;

  /// No description provided for @realEstateDisclaimer.
  ///
  /// In fr, this message translates to:
  /// **'ZAKA met en relation les particuliers et les professionnels. Ne versez jamais d\'argent avant d\'avoir visité le bien et vérifié les documents.'**
  String get realEstateDisclaimer;

  /// No description provided for @deliveryValue.
  ///
  /// In fr, this message translates to:
  /// **'Livraison prévue : {date}'**
  String deliveryValue(String date);

  /// No description provided for @budgetValue.
  ///
  /// In fr, this message translates to:
  /// **'Budget estimé : {amount}'**
  String budgetValue(String amount);

  /// No description provided for @unitsAvailableValue.
  ///
  /// In fr, this message translates to:
  /// **'{available, plural, =0{Aucun lot disponible} =1{1 lot disponible} other{{available} lots disponibles}} sur {total}'**
  String unitsAvailableValue(int available, int total);

  /// No description provided for @units.
  ///
  /// In fr, this message translates to:
  /// **'Lots'**
  String get units;

  /// No description provided for @noUnitYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun lot renseigné pour le moment.'**
  String get noUnitYet;

  /// No description provided for @interested.
  ///
  /// In fr, this message translates to:
  /// **'Ça m\'intéresse'**
  String get interested;

  /// No description provided for @unitAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Disponible'**
  String get unitAvailable;

  /// No description provided for @unitReserved.
  ///
  /// In fr, this message translates to:
  /// **'Réservé'**
  String get unitReserved;

  /// No description provided for @unitSold.
  ///
  /// In fr, this message translates to:
  /// **'Vendu'**
  String get unitSold;

  /// No description provided for @leadTypeContact.
  ///
  /// In fr, this message translates to:
  /// **'Contacter'**
  String get leadTypeContact;

  /// No description provided for @leadTypeVisit.
  ///
  /// In fr, this message translates to:
  /// **'Visite'**
  String get leadTypeVisit;

  /// No description provided for @leadTypeInfo.
  ///
  /// In fr, this message translates to:
  /// **'Information'**
  String get leadTypeInfo;

  /// No description provided for @leadTemplate.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, votre annonce « {title} » m\'intéresse. Est-elle toujours disponible ?'**
  String leadTemplate(String title);

  /// No description provided for @leadTemplateUnit.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, le lot {unit} du programme « {title} » m\'intéresse. Pouvez-vous m\'en dire plus ?'**
  String leadTemplateUnit(String unit, String title);

  /// No description provided for @yourMessage.
  ///
  /// In fr, this message translates to:
  /// **'Votre message'**
  String get yourMessage;

  /// No description provided for @preferredDates.
  ///
  /// In fr, this message translates to:
  /// **'Vos disponibilités'**
  String get preferredDates;

  /// No description provided for @preferredDatesHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. samedi matin, en semaine après 17 h'**
  String get preferredDatesHint;

  /// No description provided for @preferredDatesValue.
  ///
  /// In fr, this message translates to:
  /// **'Disponibilités : {value}'**
  String preferredDatesValue(String value);

  /// No description provided for @contactPhoneHelp.
  ///
  /// In fr, this message translates to:
  /// **'L\'annonceur pourra vous rappeler à ce numéro.'**
  String get contactPhoneHelp;

  /// No description provided for @leadMessageRequired.
  ///
  /// In fr, this message translates to:
  /// **'Écrivez un message à l\'annonceur.'**
  String get leadMessageRequired;

  /// No description provided for @leadSent.
  ///
  /// In fr, this message translates to:
  /// **'Demande envoyée. L\'annonceur vous répondra dans votre espace Demandes.'**
  String get leadSent;

  /// No description provided for @leadNew.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle'**
  String get leadNew;

  /// No description provided for @leadInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Prise en charge'**
  String get leadInProgress;

  /// No description provided for @leadVisitScheduled.
  ///
  /// In fr, this message translates to:
  /// **'Visite programmée'**
  String get leadVisitScheduled;

  /// No description provided for @leadClosed.
  ///
  /// In fr, this message translates to:
  /// **'Close'**
  String get leadClosed;

  /// No description provided for @visitPlanned.
  ///
  /// In fr, this message translates to:
  /// **'Visite prévue le {date}'**
  String visitPlanned(String date);

  /// No description provided for @unitLabel.
  ///
  /// In fr, this message translates to:
  /// **'Lot {label}'**
  String unitLabel(String label);

  /// No description provided for @bookings.
  ///
  /// In fr, this message translates to:
  /// **'Réservations'**
  String get bookings;

  /// No description provided for @contactRequests.
  ///
  /// In fr, this message translates to:
  /// **'Contacts'**
  String get contactRequests;

  /// No description provided for @bookingRequest.
  ///
  /// In fr, this message translates to:
  /// **'Demande de réservation'**
  String get bookingRequest;

  /// No description provided for @contactRequest.
  ///
  /// In fr, this message translates to:
  /// **'Demande de contact'**
  String get contactRequest;

  /// No description provided for @noBookingYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune réservation pour le moment'**
  String get noBookingYet;

  /// No description provided for @noBookingYetHint.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez un hôtel et envoyez une demande : il vous répond sous 48 h.'**
  String get noBookingYetHint;

  /// No description provided for @findHotel.
  ///
  /// In fr, this message translates to:
  /// **'Trouver un hôtel'**
  String get findHotel;

  /// No description provided for @noLeadYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande de contact'**
  String get noLeadYet;

  /// No description provided for @noLeadYetHint.
  ///
  /// In fr, this message translates to:
  /// **'Contactez un annonceur ou demandez une visite depuis une annonce.'**
  String get noLeadYetHint;

  /// No description provided for @findProperty.
  ///
  /// In fr, this message translates to:
  /// **'Voir les annonces'**
  String get findProperty;

  /// No description provided for @bookingPending.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get bookingPending;

  /// No description provided for @bookingInfoRequested.
  ///
  /// In fr, this message translates to:
  /// **'Précisions demandées'**
  String get bookingInfoRequested;

  /// No description provided for @bookingAccepted.
  ///
  /// In fr, this message translates to:
  /// **'Acceptée'**
  String get bookingAccepted;

  /// No description provided for @bookingRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusée'**
  String get bookingRejected;

  /// No description provided for @bookingCancelled.
  ///
  /// In fr, this message translates to:
  /// **'Annulée'**
  String get bookingCancelled;

  /// No description provided for @bookingExpired.
  ///
  /// In fr, this message translates to:
  /// **'Expirée'**
  String get bookingExpired;

  /// No description provided for @bookingCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Séjour terminé'**
  String get bookingCompleted;

  /// No description provided for @bookingPendingHelp.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôtel doit vous répondre avant le {deadline}.'**
  String bookingPendingHelp(String deadline);

  /// No description provided for @bookingInfoRequestedHelp.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôtel vous pose une question : répondez dans la discussion ci-dessous.'**
  String get bookingInfoRequestedHelp;

  /// No description provided for @bookingAcceptedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Votre réservation est confirmée. Vous pouvez payer en ligne ou à l\'hôtel.'**
  String get bookingAcceptedHelp;

  /// No description provided for @bookingPaidHelp.
  ///
  /// In fr, this message translates to:
  /// **'Votre réservation est confirmée et payée. Bon séjour !'**
  String get bookingPaidHelp;

  /// No description provided for @bookingRejectedHelp.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôtel ne peut pas vous accueillir à ces dates. Essayez d\'autres dates ou un autre hôtel.'**
  String get bookingRejectedHelp;

  /// No description provided for @bookingCancelledHelp.
  ///
  /// In fr, this message translates to:
  /// **'Cette réservation a été annulée.'**
  String get bookingCancelledHelp;

  /// No description provided for @bookingExpiredHelp.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôtel n\'a pas répondu à temps. Votre demande est close, sans frais.'**
  String get bookingExpiredHelp;

  /// No description provided for @bookingCompletedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Merci d\'avoir séjourné avec ZAKA !'**
  String get bookingCompletedHelp;

  /// No description provided for @guestsSummary.
  ///
  /// In fr, this message translates to:
  /// **'{adults, plural, =1{1 adulte} other{{adults} adultes}}{children, plural, =0{} =1{, 1 enfant} other{, {children} enfants}} · {rooms, plural, =1{1 chambre} other{{rooms} chambres}}'**
  String guestsSummary(int adults, int children, int rooms);

  /// No description provided for @payOnline.
  ///
  /// In fr, this message translates to:
  /// **'Payer en ligne'**
  String get payOnline;

  /// No description provided for @payAtHotelNotice.
  ///
  /// In fr, this message translates to:
  /// **'Vous pouvez aussi payer directement à l\'hôtel.'**
  String get payAtHotelNotice;

  /// No description provided for @paidSimulated.
  ///
  /// In fr, this message translates to:
  /// **'Payée en ligne (mode test)'**
  String get paidSimulated;

  /// No description provided for @cancelBooking.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelBooking;

  /// No description provided for @keepBooking.
  ///
  /// In fr, this message translates to:
  /// **'Garder'**
  String get keepBooking;

  /// No description provided for @cancelBookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler cette demande ?'**
  String get cancelBookingTitle;

  /// No description provided for @cancelBookingBody.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôtel sera prévenu. Les conditions d\'annulation de l\'hôtel s\'appliquent.'**
  String get cancelBookingBody;

  /// No description provided for @conversation.
  ///
  /// In fr, this message translates to:
  /// **'Discussion'**
  String get conversation;

  /// No description provided for @conversationEmpty.
  ///
  /// In fr, this message translates to:
  /// **'Aucun message. Posez vos questions ici.'**
  String get conversationEmpty;

  /// No description provided for @writeMessage.
  ///
  /// In fr, this message translates to:
  /// **'Écrire un message…'**
  String get writeMessage;

  /// No description provided for @checkoutBookingPaid.
  ///
  /// In fr, this message translates to:
  /// **'Votre réservation est payée. L\'hôtel est prévenu.'**
  String get checkoutBookingPaid;

  /// No description provided for @checkoutBackToBooking.
  ///
  /// In fr, this message translates to:
  /// **'Retour à la réservation'**
  String get checkoutBackToBooking;

  /// No description provided for @myListings.
  ///
  /// In fr, this message translates to:
  /// **'Mes annonces'**
  String get myListings;

  /// No description provided for @myListingsHint.
  ///
  /// In fr, this message translates to:
  /// **'Créer, publier, mettre en avant'**
  String get myListingsHint;

  /// No description provided for @newListing.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle annonce'**
  String get newListing;

  /// No description provided for @newProperty.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau bien'**
  String get newProperty;

  /// No description provided for @newProjectListing.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau programme'**
  String get newProjectListing;

  /// No description provided for @noListingYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune annonce pour le moment'**
  String get noListingYet;

  /// No description provided for @noListingYetHint.
  ///
  /// In fr, this message translates to:
  /// **'Créez votre première annonce : elle reste en brouillon jusqu\'à sa publication.'**
  String get noListingYetHint;

  /// No description provided for @listingsNeedVerification.
  ///
  /// In fr, this message translates to:
  /// **'Vous pourrez publier dès que votre compte sera vérifié.'**
  String get listingsNeedVerification;

  /// No description provided for @listingsReviewedByZaka.
  ///
  /// In fr, this message translates to:
  /// **'Vos annonces sont vérifiées par ZAKA avant d\'être publiées, généralement sous 24 h.'**
  String get listingsReviewedByZaka;

  /// No description provided for @listingsOnline.
  ///
  /// In fr, this message translates to:
  /// **'{online} / {max} annonces en ligne'**
  String listingsOnline(int online, int max);

  /// No description provided for @listingsOnlineUnlimited.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 annonce en ligne} other{{count} annonces en ligne}}'**
  String listingsOnlineUnlimited(int count);

  /// No description provided for @planLabel.
  ///
  /// In fr, this message translates to:
  /// **'Plan {name}'**
  String planLabel(String name);

  /// No description provided for @changePlan.
  ///
  /// In fr, this message translates to:
  /// **'Changer'**
  String get changePlan;

  /// No description provided for @untitledHotel.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel sans nom'**
  String get untitledHotel;

  /// No description provided for @untitledListing.
  ///
  /// In fr, this message translates to:
  /// **'Annonce sans titre'**
  String get untitledListing;

  /// No description provided for @untitledProject.
  ///
  /// In fr, this message translates to:
  /// **'Programme sans nom'**
  String get untitledProject;

  /// No description provided for @roomTypesCount.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Aucun type de chambre} =1{1 type de chambre} other{{count} types de chambres}}'**
  String roomTypesCount(int count);

  /// No description provided for @acceptanceRate.
  ///
  /// In fr, this message translates to:
  /// **'{rate} % de demandes acceptées'**
  String acceptanceRate(int rate);

  /// No description provided for @statsHotel.
  ///
  /// In fr, this message translates to:
  /// **'{views} vues · {requests} demandes'**
  String statsHotel(int views, int requests);

  /// No description provided for @statsListing.
  ///
  /// In fr, this message translates to:
  /// **'{views} vues · {leads} contacts'**
  String statsListing(int views, int leads);

  /// No description provided for @moderationReason.
  ///
  /// In fr, this message translates to:
  /// **'Motif : {reason}'**
  String moderationReason(String reason);

  /// No description provided for @publish.
  ///
  /// In fr, this message translates to:
  /// **'Publier'**
  String get publish;

  /// No description provided for @sendForReview.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer à la validation'**
  String get sendForReview;

  /// No description provided for @publishedNow.
  ///
  /// In fr, this message translates to:
  /// **'Annonce en ligne.'**
  String get publishedNow;

  /// No description provided for @sentForReview.
  ///
  /// In fr, this message translates to:
  /// **'Annonce envoyée à ZAKA pour validation.'**
  String get sentForReview;

  /// No description provided for @takeOffline.
  ///
  /// In fr, this message translates to:
  /// **'Retirer de la ligne'**
  String get takeOffline;

  /// No description provided for @takenOffline.
  ///
  /// In fr, this message translates to:
  /// **'Annonce retirée.'**
  String get takenOffline;

  /// No description provided for @feature.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à la une'**
  String get feature;

  /// No description provided for @unfeature.
  ///
  /// In fr, this message translates to:
  /// **'Retirer de la une'**
  String get unfeature;

  /// No description provided for @featuredNow.
  ///
  /// In fr, this message translates to:
  /// **'Annonce mise à la une.'**
  String get featuredNow;

  /// No description provided for @markUnderOffer.
  ///
  /// In fr, this message translates to:
  /// **'Marquer « sous offre »'**
  String get markUnderOffer;

  /// No description provided for @markRentedOrSold.
  ///
  /// In fr, this message translates to:
  /// **'Marquer louée / vendue'**
  String get markRentedOrSold;

  /// No description provided for @backOnline.
  ///
  /// In fr, this message translates to:
  /// **'Remettre disponible'**
  String get backOnline;

  /// No description provided for @markInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Travaux en cours'**
  String get markInProgress;

  /// No description provided for @markDelivered.
  ///
  /// In fr, this message translates to:
  /// **'Programme livré'**
  String get markDelivered;

  /// No description provided for @seePublicListing.
  ///
  /// In fr, this message translates to:
  /// **'Voir l\'annonce'**
  String get seePublicListing;

  /// No description provided for @listingDraft.
  ///
  /// In fr, this message translates to:
  /// **'Brouillon'**
  String get listingDraft;

  /// No description provided for @listingPendingReview.
  ///
  /// In fr, this message translates to:
  /// **'En validation'**
  String get listingPendingReview;

  /// No description provided for @listingPublished.
  ///
  /// In fr, this message translates to:
  /// **'En ligne'**
  String get listingPublished;

  /// No description provided for @listingRejected.
  ///
  /// In fr, this message translates to:
  /// **'Refusée'**
  String get listingRejected;

  /// No description provided for @listingUnderOffer.
  ///
  /// In fr, this message translates to:
  /// **'Sous offre'**
  String get listingUnderOffer;

  /// No description provided for @listingRented.
  ///
  /// In fr, this message translates to:
  /// **'Louée'**
  String get listingRented;

  /// No description provided for @listingSold.
  ///
  /// In fr, this message translates to:
  /// **'Vendue'**
  String get listingSold;

  /// No description provided for @listingInactive.
  ///
  /// In fr, this message translates to:
  /// **'Hors ligne'**
  String get listingInactive;

  /// No description provided for @listingInProgress.
  ///
  /// In fr, this message translates to:
  /// **'Travaux en cours'**
  String get listingInProgress;

  /// No description provided for @listingDelivered.
  ///
  /// In fr, this message translates to:
  /// **'Livré'**
  String get listingDelivered;

  /// No description provided for @listingSuspended.
  ///
  /// In fr, this message translates to:
  /// **'Suspendue'**
  String get listingSuspended;

  /// No description provided for @waitingForReview.
  ///
  /// In fr, this message translates to:
  /// **'En cours de validation par ZAKA'**
  String get waitingForReview;

  /// No description provided for @reviewAgainTitle.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle validation'**
  String get reviewAgainTitle;

  /// No description provided for @reviewAgainBody.
  ///
  /// In fr, this message translates to:
  /// **'Votre annonce est en ligne : après modification, elle sera de nouveau vérifiée par ZAKA avant d\'être republiée.'**
  String get reviewAgainBody;

  /// No description provided for @tabInfo.
  ///
  /// In fr, this message translates to:
  /// **'Infos'**
  String get tabInfo;

  /// No description provided for @tabPhotos.
  ///
  /// In fr, this message translates to:
  /// **'Photos'**
  String get tabPhotos;

  /// No description provided for @tabOffers.
  ///
  /// In fr, this message translates to:
  /// **'Offres'**
  String get tabOffers;

  /// No description provided for @tabAvailability.
  ///
  /// In fr, this message translates to:
  /// **'Disponibilités'**
  String get tabAvailability;

  /// No description provided for @hotelIdentity.
  ///
  /// In fr, this message translates to:
  /// **'L\'hôtel'**
  String get hotelIdentity;

  /// No description provided for @hotelName.
  ///
  /// In fr, this message translates to:
  /// **'Nom de l\'hôtel'**
  String get hotelName;

  /// No description provided for @stars.
  ///
  /// In fr, this message translates to:
  /// **'Classement'**
  String get stars;

  /// No description provided for @notRated.
  ///
  /// In fr, this message translates to:
  /// **'Non classé'**
  String get notRated;

  /// No description provided for @receptionPhone.
  ///
  /// In fr, this message translates to:
  /// **'Téléphone de la réception'**
  String get receptionPhone;

  /// No description provided for @checkInTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure d\'arrivée'**
  String get checkInTime;

  /// No description provided for @checkOutTime.
  ///
  /// In fr, this message translates to:
  /// **'Heure de départ'**
  String get checkOutTime;

  /// No description provided for @cancellationPolicyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Conditions d\'annulation'**
  String get cancellationPolicyLabel;

  /// No description provided for @cancellationPolicyHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. gratuite jusqu\'à 24 h avant l\'arrivée'**
  String get cancellationPolicyHint;

  /// No description provided for @otherRules.
  ///
  /// In fr, this message translates to:
  /// **'Autres règles'**
  String get otherRules;

  /// No description provided for @photosHelp.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez des photos lumineuses : la première sert de couverture. 12 photos au plus, 8 Mo chacune.'**
  String get photosHelp;

  /// No description provided for @addPhotos.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter des photos'**
  String get addPhotos;

  /// No description provided for @cover.
  ///
  /// In fr, this message translates to:
  /// **'Couverture'**
  String get cover;

  /// No description provided for @makeCover.
  ///
  /// In fr, this message translates to:
  /// **'Mettre en couverture'**
  String get makeCover;

  /// No description provided for @photoTooLarge.
  ///
  /// In fr, this message translates to:
  /// **'{name} dépasse 8 Mo.'**
  String photoTooLarge(String name);

  /// No description provided for @addRoomType.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un type de chambre'**
  String get addRoomType;

  /// No description provided for @editRoomType.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le type de chambre'**
  String get editRoomType;

  /// No description provided for @noRoomTypeYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucun type de chambre'**
  String get noRoomTypeYet;

  /// No description provided for @noRoomTypeYetHint.
  ///
  /// In fr, this message translates to:
  /// **'Ajoutez vos chambres avec leur prix : il en faut au moins une pour publier.'**
  String get noRoomTypeYetHint;

  /// No description provided for @roomTypeName.
  ///
  /// In fr, this message translates to:
  /// **'Type de chambre'**
  String get roomTypeName;

  /// No description provided for @roomTypeNameHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. Chambre double climatisée'**
  String get roomTypeNameHint;

  /// No description provided for @pricePerNightLabel.
  ///
  /// In fr, this message translates to:
  /// **'Prix par nuit'**
  String get pricePerNightLabel;

  /// No description provided for @roomsOfThisType.
  ///
  /// In fr, this message translates to:
  /// **'Nombre de chambres'**
  String get roomsOfThisType;

  /// No description provided for @beds.
  ///
  /// In fr, this message translates to:
  /// **'Lits'**
  String get beds;

  /// No description provided for @bedsHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. 1 grand lit'**
  String get bedsHint;

  /// No description provided for @roomActive.
  ///
  /// In fr, this message translates to:
  /// **'Proposée aux clients'**
  String get roomActive;

  /// No description provided for @roomQuantity.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 chambre} other{{count} chambres}}'**
  String roomQuantity(int count);

  /// No description provided for @inactiveRoom.
  ///
  /// In fr, this message translates to:
  /// **'non proposée'**
  String get inactiveRoom;

  /// No description provided for @addOffer.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter une offre'**
  String get addOffer;

  /// No description provided for @editOffer.
  ///
  /// In fr, this message translates to:
  /// **'Modifier l\'offre'**
  String get editOffer;

  /// No description provided for @noOfferYet.
  ///
  /// In fr, this message translates to:
  /// **'Aucune offre spéciale'**
  String get noOfferYet;

  /// No description provided for @noOfferYetHint.
  ///
  /// In fr, this message translates to:
  /// **'Créez une remise sur une période : elle s\'affiche sur votre fiche.'**
  String get noOfferYetHint;

  /// No description provided for @offerTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre de l\'offre'**
  String get offerTitle;

  /// No description provided for @offerTitleHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. Spécial fêtes de fin d\'année'**
  String get offerTitleHint;

  /// No description provided for @discount.
  ///
  /// In fr, this message translates to:
  /// **'Remise'**
  String get discount;

  /// No description provided for @offerPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Choisir la période'**
  String get offerPeriod;

  /// No description provided for @offerRooms.
  ///
  /// In fr, this message translates to:
  /// **'Chambres concernées (aucune sélection : toutes)'**
  String get offerRooms;

  /// No description provided for @offerActive.
  ///
  /// In fr, this message translates to:
  /// **'Offre active'**
  String get offerActive;

  /// No description provided for @offerIncomplete.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez un titre, une remise entre 1 et 99 % et une période.'**
  String get offerIncomplete;

  /// No description provided for @inactiveOffer.
  ///
  /// In fr, this message translates to:
  /// **'inactive'**
  String get inactiveOffer;

  /// No description provided for @availabilityHelp.
  ///
  /// In fr, this message translates to:
  /// **'Indiquez les jours où vous avez moins de chambres libres (ou aucune). Les autres jours, toutes les chambres du type sont considérées comme disponibles.'**
  String get availabilityHelp;

  /// No description provided for @roomsAvailable.
  ///
  /// In fr, this message translates to:
  /// **'Chambres libres'**
  String get roomsAvailable;

  /// No description provided for @resetDay.
  ///
  /// In fr, this message translates to:
  /// **'Toutes libres'**
  String get resetDay;

  /// No description provided for @closeWholeMonth.
  ///
  /// In fr, this message translates to:
  /// **'Complet tout le mois'**
  String get closeWholeMonth;

  /// No description provided for @openWholeMonth.
  ///
  /// In fr, this message translates to:
  /// **'Tout disponible'**
  String get openWholeMonth;

  /// No description provided for @listingMain.
  ///
  /// In fr, this message translates to:
  /// **'L\'annonce'**
  String get listingMain;

  /// No description provided for @listingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Titre'**
  String get listingTitle;

  /// No description provided for @listingTitleHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. Villa 4 pièces avec jardin à Ouaga 2000'**
  String get listingTitleHint;

  /// No description provided for @rentPeriod.
  ///
  /// In fr, this message translates to:
  /// **'Loyer'**
  String get rentPeriod;

  /// No description provided for @perMonth.
  ///
  /// In fr, this message translates to:
  /// **'Par mois'**
  String get perMonth;

  /// No description provided for @perDay.
  ///
  /// In fr, this message translates to:
  /// **'Par jour'**
  String get perDay;

  /// No description provided for @deposit.
  ///
  /// In fr, this message translates to:
  /// **'Caution'**
  String get deposit;

  /// No description provided for @depositHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. 2 mois'**
  String get depositHint;

  /// No description provided for @advance.
  ///
  /// In fr, this message translates to:
  /// **'Avance sur loyer'**
  String get advance;

  /// No description provided for @advanceHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. 3 mois'**
  String get advanceHint;

  /// No description provided for @agencyFees.
  ///
  /// In fr, this message translates to:
  /// **'Frais d\'agence'**
  String get agencyFees;

  /// No description provided for @characteristics.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques'**
  String get characteristics;

  /// No description provided for @surface.
  ///
  /// In fr, this message translates to:
  /// **'Surface'**
  String get surface;

  /// No description provided for @roomsLabel.
  ///
  /// In fr, this message translates to:
  /// **'Pièces'**
  String get roomsLabel;

  /// No description provided for @bedrooms.
  ///
  /// In fr, this message translates to:
  /// **'Chambres'**
  String get bedrooms;

  /// No description provided for @bathrooms.
  ///
  /// In fr, this message translates to:
  /// **'Salles d\'eau'**
  String get bathrooms;

  /// No description provided for @addressHelp.
  ///
  /// In fr, this message translates to:
  /// **'Restez général si vous préférez : le quartier suffit.'**
  String get addressHelp;

  /// No description provided for @projectName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du programme'**
  String get projectName;

  /// No description provided for @deliveryDate.
  ///
  /// In fr, this message translates to:
  /// **'Livraison prévue'**
  String get deliveryDate;

  /// No description provided for @deliveryDateHint.
  ///
  /// In fr, this message translates to:
  /// **'Ex. 2e trimestre 2027'**
  String get deliveryDateHint;

  /// No description provided for @estimatedBudget.
  ///
  /// In fr, this message translates to:
  /// **'Budget estimé'**
  String get estimatedBudget;

  /// No description provided for @addUnit.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un lot'**
  String get addUnit;

  /// No description provided for @editUnit.
  ///
  /// In fr, this message translates to:
  /// **'Modifier le lot'**
  String get editUnit;

  /// No description provided for @unitName.
  ///
  /// In fr, this message translates to:
  /// **'Nom du lot'**
  String get unitName;

  /// No description provided for @receivedBookings.
  ///
  /// In fr, this message translates to:
  /// **'Demandes de réservation'**
  String get receivedBookings;

  /// No description provided for @receivedLeads.
  ///
  /// In fr, this message translates to:
  /// **'Demandes de contact'**
  String get receivedLeads;

  /// No description provided for @toHandle.
  ///
  /// In fr, this message translates to:
  /// **'À traiter ({count})'**
  String toHandle(int count);

  /// No description provided for @closedRequests.
  ///
  /// In fr, this message translates to:
  /// **'Closes'**
  String get closedRequests;

  /// No description provided for @noRequestHere.
  ///
  /// In fr, this message translates to:
  /// **'Aucune demande ici.'**
  String get noRequestHere;

  /// No description provided for @answerBefore.
  ///
  /// In fr, this message translates to:
  /// **'Répondre avant le {deadline}'**
  String answerBefore(String deadline);

  /// No description provided for @hotelPendingHelp.
  ///
  /// In fr, this message translates to:
  /// **'Acceptez ou refusez avant le {deadline}, sinon la demande expirera.'**
  String hotelPendingHelp(String deadline);

  /// No description provided for @hotelInfoRequestedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Vous avez demandé des précisions : la réponse du client remettra la demande en attente.'**
  String get hotelInfoRequestedHelp;

  /// No description provided for @hotelAcceptedHelp.
  ///
  /// In fr, this message translates to:
  /// **'Réservation confirmée. Le client peut payer en ligne ou sur place.'**
  String get hotelAcceptedHelp;

  /// No description provided for @hotelPaidHelp.
  ///
  /// In fr, this message translates to:
  /// **'Réservation confirmée et payée en ligne (mode test).'**
  String get hotelPaidHelp;

  /// No description provided for @askInfo.
  ///
  /// In fr, this message translates to:
  /// **'Demander des précisions'**
  String get askInfo;

  /// No description provided for @askInfoTitle.
  ///
  /// In fr, this message translates to:
  /// **'Question au client'**
  String get askInfoTitle;

  /// No description provided for @rejectBookingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Refuser la demande'**
  String get rejectBookingTitle;

  /// No description provided for @cancelAcceptedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Annuler la réservation'**
  String get cancelAcceptedTitle;

  /// No description provided for @stayCompleted.
  ///
  /// In fr, this message translates to:
  /// **'Séjour terminé'**
  String get stayCompleted;

  /// No description provided for @commissionDueFor.
  ///
  /// In fr, this message translates to:
  /// **'Commission ZAKA due pour ce séjour : {amount}'**
  String commissionDueFor(String amount);

  /// No description provided for @messageForClient.
  ///
  /// In fr, this message translates to:
  /// **'Message au client'**
  String get messageForClient;

  /// No description provided for @messageForClientOptional.
  ///
  /// In fr, this message translates to:
  /// **'Message au client (facultatif)'**
  String get messageForClientOptional;

  /// No description provided for @takeCharge.
  ///
  /// In fr, this message translates to:
  /// **'Prendre en charge'**
  String get takeCharge;

  /// No description provided for @scheduleVisit.
  ///
  /// In fr, this message translates to:
  /// **'Programmer une visite'**
  String get scheduleVisit;

  /// No description provided for @changeVisit.
  ///
  /// In fr, this message translates to:
  /// **'Changer la visite'**
  String get changeVisit;

  /// No description provided for @closeRequest.
  ///
  /// In fr, this message translates to:
  /// **'Clore la demande'**
  String get closeRequest;

  /// No description provided for @whatsappLeadText.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour, je vous contacte au sujet de « {title} » sur ZAKA.'**
  String whatsappLeadText(String title);

  /// No description provided for @badgeHotel.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel'**
  String get badgeHotel;

  /// No description provided for @starsValue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 étoile} other{{count} étoiles}}'**
  String starsValue(int count);

  /// No description provided for @upToGuests.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 pers.} other{Jusqu\'à {count} pers.}}'**
  String upToGuests(int count);

  /// No description provided for @roomTypesValue.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 type de chambre} other{{count} types de chambre}}'**
  String roomTypesValue(int count);

  /// No description provided for @unitsLeft.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =0{Complet} =1{1 lot disponible} other{{count} lots disponibles}}'**
  String unitsLeft(int count);

  /// No description provided for @deliveryShort.
  ///
  /// In fr, this message translates to:
  /// **'Livraison {date}'**
  String deliveryShort(String date);

  /// No description provided for @homeGreeting.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour {name} 👋'**
  String homeGreeting(String name);

  /// No description provided for @homeGreetingAnonymous.
  ///
  /// In fr, this message translates to:
  /// **'Bonjour 👋'**
  String get homeGreetingAnonymous;

  /// No description provided for @homeTagline.
  ///
  /// In fr, this message translates to:
  /// **'Trouvez l\'hôtel ou le logement qui vous ressemble'**
  String get homeTagline;

  /// No description provided for @homeSearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Hôtel, location, achat…'**
  String get homeSearchHint;

  /// No description provided for @homeSearchTitle.
  ///
  /// In fr, this message translates to:
  /// **'Que cherchez-vous ?'**
  String get homeSearchTitle;

  /// No description provided for @homeCategoryHotels.
  ///
  /// In fr, this message translates to:
  /// **'Hôtels'**
  String get homeCategoryHotels;

  /// No description provided for @homeCategoryProjects.
  ///
  /// In fr, this message translates to:
  /// **'Neuf'**
  String get homeCategoryProjects;

  /// No description provided for @homePopularCities.
  ///
  /// In fr, this message translates to:
  /// **'Villes populaires'**
  String get homePopularCities;

  /// No description provided for @citySearchHint.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une ville'**
  String get citySearchHint;

  /// No description provided for @seeRooms.
  ///
  /// In fr, this message translates to:
  /// **'Voir les chambres'**
  String get seeRooms;

  /// No description provided for @accountStatUnread.
  ///
  /// In fr, this message translates to:
  /// **'Non lues'**
  String get accountStatUnread;

  /// No description provided for @accountSectionActivity.
  ///
  /// In fr, this message translates to:
  /// **'Mon activité'**
  String get accountSectionActivity;

  /// No description provided for @accountSectionPro.
  ///
  /// In fr, this message translates to:
  /// **'Professionnels'**
  String get accountSectionPro;

  /// No description provided for @accountSectionInfo.
  ///
  /// In fr, this message translates to:
  /// **'Informations'**
  String get accountSectionInfo;

  /// No description provided for @accountSectionAccount.
  ///
  /// In fr, this message translates to:
  /// **'Compte'**
  String get accountSectionAccount;

  /// No description provided for @signInWelcome.
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue sur ZAKA'**
  String get signInWelcome;

  /// No description provided for @signInTagline.
  ///
  /// In fr, this message translates to:
  /// **'Réservez un hôtel, contactez les annonceurs et retrouvez vos favoris.'**
  String get signInTagline;

  /// No description provided for @resetFilters.
  ///
  /// In fr, this message translates to:
  /// **'Réinitialiser'**
  String get resetFilters;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
