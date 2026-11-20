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
