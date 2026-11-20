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
