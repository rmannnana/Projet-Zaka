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

  @override
  String get billingSubscription => 'Abonnement';

  @override
  String get billingCurrentPlan => 'Plan actuel';

  @override
  String get billingFreePlanHelp =>
      'Le plan Gratuit s\'applique tant qu\'aucun abonnement payant n\'est en cours.';

  @override
  String billingActiveUntil(String date) {
    return 'Actif jusqu\'au $date';
  }

  @override
  String billingPlanUntil(String plan, String date) {
    return '$plan · jusqu\'au $date';
  }

  @override
  String get billingAvailablePlans => 'Plans disponibles';

  @override
  String get billingNoPlans =>
      'Aucun plan payant n\'est proposé pour le moment.';

  @override
  String get billingFree => 'Gratuit';

  @override
  String billingPricePerMonth(String price) {
    return '$price par mois';
  }

  @override
  String billingPricePerYear(String price) {
    return '$price par an';
  }

  @override
  String billingMaxListings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count annonces publiées à la fois',
      one: '1 annonce publiée à la fois',
    );
    return '$_temp0';
  }

  @override
  String get billingUnlimitedListings => 'Annonces illimitées';

  @override
  String billingFeaturedListings(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count annonces mises en avant',
      one: '1 annonce mise en avant',
      zero: 'Pas de mise en avant',
    );
    return '$_temp0';
  }

  @override
  String get billingAdvancedStats => 'Statistiques détaillées';

  @override
  String get billingChoose => 'Choisir';

  @override
  String get billingRenew => 'Renouveler';

  @override
  String get billingOwnerOnly =>
      'Seul un propriétaire du compte peut changer d\'abonnement.';

  @override
  String get billingNeedsVerification =>
      'Les abonnements sont disponibles une fois votre compte vérifié.';

  @override
  String billingConfirmTitle(String plan) {
    return 'Plan $plan';
  }

  @override
  String billingConfirmMonth(String price) {
    return '$price pour 1 mois.';
  }

  @override
  String billingConfirmYear(String price) {
    return '$price pour 1 an.';
  }

  @override
  String billingRenewInfo(String date) {
    return 'La nouvelle période s\'ajoutera à la période en cours, qui se termine le $date.';
  }

  @override
  String billingReplaceWarning(String plan) {
    return 'Votre abonnement $plan sera remplacé dès le paiement, sans remboursement de la période restante.';
  }

  @override
  String get billingContinueToPayment => 'Continuer vers le paiement';

  @override
  String get billingPaymentHistory => 'Historique des paiements';

  @override
  String get billingNoPayments => 'Aucun paiement pour le moment.';

  @override
  String get paymentStatusPending => 'En attente';

  @override
  String get paymentStatusSucceeded => 'Réussi';

  @override
  String get paymentStatusFailed => 'Échoué';

  @override
  String get paymentStatusCancelled => 'Annulé';

  @override
  String get checkoutTitle => 'Paiement';

  @override
  String get checkoutTestBanner => 'Mode test : aucun paiement réel';

  @override
  String get checkoutTestExplain =>
      'Le paiement par Mobile Money ou carte arrivera plus tard. Pour l\'instant, choisissez l\'issue à simuler : aucun argent ne circule.';

  @override
  String get checkoutSimulateSuccess => 'Simuler un paiement réussi';

  @override
  String get checkoutSimulateFailure => 'Simuler un échec';

  @override
  String get checkoutCancel => 'Annuler le paiement';

  @override
  String get checkoutSucceeded => 'Paiement accepté';

  @override
  String checkoutSucceededUntil(String date) {
    return 'Votre abonnement est actif jusqu\'au $date.';
  }

  @override
  String get checkoutFailed => 'Paiement refusé';

  @override
  String get checkoutFailedBody =>
      'Aucun montant n\'a été débité. Vous pouvez réessayer depuis la page Abonnement.';

  @override
  String get checkoutCancelled => 'Paiement annulé';

  @override
  String get checkoutBackToSubscription => 'Retour à l\'abonnement';

  @override
  String get checkoutNotFound => 'Paiement introuvable.';

  @override
  String get commissionsTitle => 'Commissions';

  @override
  String get commissionsHelp =>
      'ZAKA perçoit une commission sur chaque séjour terminé, réservé via ZAKA. Elle est calculée avec le taux en vigueur à la fin du séjour.';

  @override
  String get commissionsOutstanding => 'Reste à régler';

  @override
  String get commissionsEmpty => 'Aucune commission pour le moment.';

  @override
  String commissionOn(String amount) {
    return 'Sur $amount';
  }

  @override
  String get commissionStatusDue => 'Due';

  @override
  String get commissionStatusInvoiced => 'Facturée';

  @override
  String get commissionStatusPaid => 'Payée';

  @override
  String get commissionStatusWaived => 'Offerte';

  @override
  String get accept => 'Accepter';

  @override
  String get reject => 'Refuser';

  @override
  String get all => 'Tout';

  @override
  String get any => 'Peu importe';

  @override
  String get apply => 'Appliquer';

  @override
  String get close => 'Fermer';

  @override
  String get confirm => 'Confirmer';

  @override
  String get delete => 'Supprimer';

  @override
  String get description => 'Description';

  @override
  String get send => 'Envoyer';

  @override
  String get sending => 'Envoi…';

  @override
  String get saved => 'Modifications enregistrées.';

  @override
  String get search => 'Rechercher';

  @override
  String get seeAll => 'Tout voir';

  @override
  String get explore => 'Explorer';

  @override
  String get requiredField => 'Champ obligatoire';

  @override
  String get call => 'Appeler';

  @override
  String get location => 'Emplacement';

  @override
  String get district => 'Quartier';

  @override
  String get allCities => 'Toutes les villes';

  @override
  String get price => 'Prix';

  @override
  String get priceSection => 'Prix et conditions';

  @override
  String get legalTerms => 'Conditions d\'utilisation';

  @override
  String get legalPrivacy => 'Confidentialité';

  @override
  String get navRequests => 'Demandes';

  @override
  String get favorites => 'Favoris';

  @override
  String get favoriteAdd => 'Ajouter aux favoris';

  @override
  String get favoriteRemove => 'Retirer des favoris';

  @override
  String get noFavorite => 'Aucun favori pour le moment';

  @override
  String get noFavoriteHint =>
      'Touchez le cœur d\'une annonce pour la retrouver ici.';

  @override
  String get featured => 'À la une';

  @override
  String publishedBy(String name) {
    return 'Publié par $name';
  }

  @override
  String get listingUnavailable => 'Cette annonce n\'est pas disponible.';

  @override
  String get requestNotFound => 'Demande introuvable.';

  @override
  String get homeFeaturedHotels => 'Hôtels à la une';

  @override
  String get homeFeaturedProperties => 'Biens à la une';

  @override
  String get homeNoHotelsYet =>
      'Les premiers hôtels arrivent bientôt sur ZAKA.';

  @override
  String get homeNoPropertiesYet =>
      'Les premières annonces arrivent bientôt sur ZAKA.';

  @override
  String get homeProTitle => 'Hôtel, agence, promoteur ou propriétaire ?';

  @override
  String get homeProBody =>
      'Publiez vos chambres et vos biens sur ZAKA et recevez des demandes de clients vérifiés.';

  @override
  String get homeProAction => 'Publier sur ZAKA';

  @override
  String get rent => 'Louer';

  @override
  String get buy => 'Acheter';

  @override
  String get forRent => 'À louer';

  @override
  String get forSale => 'À vendre';

  @override
  String get newProjects => 'Programmes neufs';

  @override
  String get newProject => 'Programme neuf';

  @override
  String get chooseDates => 'Choisir les dates';

  @override
  String get chooseYourDates => 'Choisissez vos dates d\'arrivée et de départ.';

  @override
  String get guests => 'Voyageurs';

  @override
  String guestsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voyageurs',
      one: '1 voyageur',
    );
    return '$_temp0';
  }

  @override
  String get filters => 'Filtres';

  @override
  String filtersCount(int count) {
    return 'Filtres ($count)';
  }

  @override
  String get maxPricePerNight => 'Budget maximum par nuit';

  @override
  String get maxBudget => 'Budget maximum';

  @override
  String get anyBudget => 'Tous budgets';

  @override
  String get amenities => 'Équipements';

  @override
  String get showResults => 'Voir les résultats';

  @override
  String hotelsFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hôtels trouvés',
      one: '1 hôtel trouvé',
    );
    return '$_temp0';
  }

  @override
  String get noHotelFound => 'Aucun hôtel ne correspond à votre recherche';

  @override
  String get noHotelFoundHint =>
      'Essayez une autre ville ou retirez des filtres.';

  @override
  String get propertyType => 'Type de bien';

  @override
  String get allTypes => 'Tous';

  @override
  String get minRooms => 'Pièces au minimum';

  @override
  String get furnishedOnly => 'Meublé uniquement';

  @override
  String get noPropertyFound => 'Aucun bien ne correspond à votre recherche';

  @override
  String get noPropertyFoundHint =>
      'Élargissez la recherche à une autre ville ou un autre budget.';

  @override
  String get noProjectFound => 'Aucun programme neuf pour le moment';

  @override
  String priceFromPerNight(String price) {
    return 'À partir de $price / nuit';
  }

  @override
  String pricePerNight(String price) {
    return '$price / nuit';
  }

  @override
  String pricePerMonth(String price) {
    return '$price / mois';
  }

  @override
  String pricePerDay(String price) {
    return '$price / jour';
  }

  @override
  String priceFrom(String price) {
    return 'À partir de $price';
  }

  @override
  String get rooms => 'Chambres';

  @override
  String get noRoomAvailable => 'Aucune chambre proposée pour le moment.';

  @override
  String roomCapacity(int adults, int children) {
    String _temp0 = intl.Intl.pluralLogic(
      adults,
      locale: localeName,
      other: '$adults adultes',
      one: '1 adulte',
    );
    String _temp1 = intl.Intl.pluralLogic(
      children,
      locale: localeName,
      other: ' + $children enfants',
      one: ' + 1 enfant',
      zero: '',
    );
    return '$_temp0$_temp1';
  }

  @override
  String get requestThisRoom => 'Demander';

  @override
  String get hotelRules => 'Règles de l\'hôtel';

  @override
  String checkInFrom(String time) {
    return 'Arrivée à partir de $time';
  }

  @override
  String checkOutBefore(String time) {
    return 'Départ avant $time';
  }

  @override
  String get petsAllowed => 'Animaux acceptés';

  @override
  String get petsNotAllowed => 'Animaux non acceptés';

  @override
  String cancellationPolicy(String policy) {
    return 'Annulation : $policy';
  }

  @override
  String offerUntil(String date) {
    return 'Jusqu\'au $date';
  }

  @override
  String get bookingConfirmationNotice =>
      'Chaque demande est confirmée par l\'hôtel, qui répond sous 48 h.';

  @override
  String get bookingRequestTitle => 'Demande de réservation';

  @override
  String get adults => 'Adultes';

  @override
  String get children => 'Enfants';

  @override
  String get roomsCount => 'Chambres';

  @override
  String get messageToHotel => 'Message à l\'hôtel (facultatif)';

  @override
  String get messageToHotelHint => 'Heure d\'arrivée, demande particulière…';

  @override
  String get estimatedTotal => 'Total estimé';

  @override
  String estimateDetail(String price, int nights, int rooms) {
    String _temp0 = intl.Intl.pluralLogic(
      nights,
      locale: localeName,
      other: '$nights nuits',
      one: '1 nuit',
    );
    String _temp1 = intl.Intl.pluralLogic(
      rooms,
      locale: localeName,
      other: '$rooms chambres',
      one: '1 chambre',
    );
    return '$price × $_temp0 × $_temp1';
  }

  @override
  String nightsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nuits',
      one: '1 nuit',
    );
    return '$_temp0';
  }

  @override
  String get bookingRequestNotice =>
      'Ceci est une demande : l\'hôtel confirme la disponibilité et le prix. Vous ne payez rien pour l\'instant.';

  @override
  String get sendRequest => 'Envoyer la demande';

  @override
  String get bookingSentTitle => 'Demande envoyée';

  @override
  String bookingSentBody(String hotel, String deadline) {
    return '$hotel a jusqu\'au $deadline pour vous répondre. Vous serez prévenu dès sa réponse.';
  }

  @override
  String get seeMyRequest => 'Voir ma demande';

  @override
  String get askVisit => 'Demander une visite';

  @override
  String get askInformation => 'Demander des informations';

  @override
  String surfaceValue(int value) {
    return '$value m²';
  }

  @override
  String roomsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count pièces',
      one: '1 pièce',
    );
    return '$_temp0';
  }

  @override
  String bedroomsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chambres',
      one: '1 chambre',
    );
    return '$_temp0';
  }

  @override
  String bathroomsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count salles d\'eau',
      one: '1 salle d\'eau',
    );
    return '$_temp0';
  }

  @override
  String get features => 'Atouts';

  @override
  String get rentConditions => 'Conditions de location';

  @override
  String depositValue(String value) {
    return 'Caution : $value';
  }

  @override
  String advanceValue(String value) {
    return 'Avance : $value';
  }

  @override
  String agencyFeesValue(String value) {
    return 'Frais d\'agence : $value';
  }

  @override
  String get publisher => 'Annonceur';

  @override
  String get verifiedProfessional => 'Professionnel vérifié par ZAKA';

  @override
  String get realEstateDisclaimer =>
      'ZAKA met en relation les particuliers et les professionnels. Ne versez jamais d\'argent avant d\'avoir visité le bien et vérifié les documents.';

  @override
  String deliveryValue(String date) {
    return 'Livraison prévue : $date';
  }

  @override
  String budgetValue(String amount) {
    return 'Budget estimé : $amount';
  }

  @override
  String unitsAvailableValue(int available, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      available,
      locale: localeName,
      other: '$available lots disponibles',
      one: '1 lot disponible',
      zero: 'Aucun lot disponible',
    );
    return '$_temp0 sur $total';
  }

  @override
  String get units => 'Lots';

  @override
  String get noUnitYet => 'Aucun lot renseigné pour le moment.';

  @override
  String get interested => 'Ça m\'intéresse';

  @override
  String get unitAvailable => 'Disponible';

  @override
  String get unitReserved => 'Réservé';

  @override
  String get unitSold => 'Vendu';

  @override
  String get leadTypeContact => 'Contacter';

  @override
  String get leadTypeVisit => 'Visite';

  @override
  String get leadTypeInfo => 'Information';

  @override
  String leadTemplate(String title) {
    return 'Bonjour, votre annonce « $title » m\'intéresse. Est-elle toujours disponible ?';
  }

  @override
  String leadTemplateUnit(String unit, String title) {
    return 'Bonjour, le lot $unit du programme « $title » m\'intéresse. Pouvez-vous m\'en dire plus ?';
  }

  @override
  String get yourMessage => 'Votre message';

  @override
  String get preferredDates => 'Vos disponibilités';

  @override
  String get preferredDatesHint => 'Ex. samedi matin, en semaine après 17 h';

  @override
  String preferredDatesValue(String value) {
    return 'Disponibilités : $value';
  }

  @override
  String get contactPhoneHelp =>
      'L\'annonceur pourra vous rappeler à ce numéro.';

  @override
  String get leadMessageRequired => 'Écrivez un message à l\'annonceur.';

  @override
  String get leadSent =>
      'Demande envoyée. L\'annonceur vous répondra dans votre espace Demandes.';

  @override
  String get leadNew => 'Nouvelle';

  @override
  String get leadInProgress => 'Prise en charge';

  @override
  String get leadVisitScheduled => 'Visite programmée';

  @override
  String get leadClosed => 'Close';

  @override
  String visitPlanned(String date) {
    return 'Visite prévue le $date';
  }

  @override
  String unitLabel(String label) {
    return 'Lot $label';
  }

  @override
  String get bookings => 'Réservations';

  @override
  String get contactRequests => 'Contacts';

  @override
  String get bookingRequest => 'Demande de réservation';

  @override
  String get contactRequest => 'Demande de contact';

  @override
  String get noBookingYet => 'Aucune réservation pour le moment';

  @override
  String get noBookingYetHint =>
      'Trouvez un hôtel et envoyez une demande : il vous répond sous 48 h.';

  @override
  String get findHotel => 'Trouver un hôtel';

  @override
  String get noLeadYet => 'Aucune demande de contact';

  @override
  String get noLeadYetHint =>
      'Contactez un annonceur ou demandez une visite depuis une annonce.';

  @override
  String get findProperty => 'Voir les annonces';

  @override
  String get bookingPending => 'En attente';

  @override
  String get bookingInfoRequested => 'Précisions demandées';

  @override
  String get bookingAccepted => 'Acceptée';

  @override
  String get bookingRejected => 'Refusée';

  @override
  String get bookingCancelled => 'Annulée';

  @override
  String get bookingExpired => 'Expirée';

  @override
  String get bookingCompleted => 'Séjour terminé';

  @override
  String bookingPendingHelp(String deadline) {
    return 'L\'hôtel doit vous répondre avant le $deadline.';
  }

  @override
  String get bookingInfoRequestedHelp =>
      'L\'hôtel vous pose une question : répondez dans la discussion ci-dessous.';

  @override
  String get bookingAcceptedHelp =>
      'Votre réservation est confirmée. Vous pouvez payer en ligne ou à l\'hôtel.';

  @override
  String get bookingPaidHelp =>
      'Votre réservation est confirmée et payée. Bon séjour !';

  @override
  String get bookingRejectedHelp =>
      'L\'hôtel ne peut pas vous accueillir à ces dates. Essayez d\'autres dates ou un autre hôtel.';

  @override
  String get bookingCancelledHelp => 'Cette réservation a été annulée.';

  @override
  String get bookingExpiredHelp =>
      'L\'hôtel n\'a pas répondu à temps. Votre demande est close, sans frais.';

  @override
  String get bookingCompletedHelp => 'Merci d\'avoir séjourné avec ZAKA !';

  @override
  String guestsSummary(int adults, int children, int rooms) {
    String _temp0 = intl.Intl.pluralLogic(
      adults,
      locale: localeName,
      other: '$adults adultes',
      one: '1 adulte',
    );
    String _temp1 = intl.Intl.pluralLogic(
      children,
      locale: localeName,
      other: ', $children enfants',
      one: ', 1 enfant',
      zero: '',
    );
    String _temp2 = intl.Intl.pluralLogic(
      rooms,
      locale: localeName,
      other: '$rooms chambres',
      one: '1 chambre',
    );
    return '$_temp0$_temp1 · $_temp2';
  }

  @override
  String get payOnline => 'Payer en ligne';

  @override
  String get payAtHotelNotice =>
      'Vous pouvez aussi payer directement à l\'hôtel.';

  @override
  String get paidSimulated => 'Payée en ligne (mode test)';

  @override
  String get cancelBooking => 'Annuler la réservation';

  @override
  String get keepBooking => 'Garder';

  @override
  String get cancelBookingTitle => 'Annuler cette demande ?';

  @override
  String get cancelBookingBody =>
      'L\'hôtel sera prévenu. Les conditions d\'annulation de l\'hôtel s\'appliquent.';

  @override
  String get conversation => 'Discussion';

  @override
  String get conversationEmpty => 'Aucun message. Posez vos questions ici.';

  @override
  String get writeMessage => 'Écrire un message…';

  @override
  String get checkoutBookingPaid =>
      'Votre réservation est payée. L\'hôtel est prévenu.';

  @override
  String get checkoutBackToBooking => 'Retour à la réservation';

  @override
  String get myListings => 'Mes annonces';

  @override
  String get myListingsHint => 'Créer, publier, mettre en avant';

  @override
  String get newListing => 'Nouvelle annonce';

  @override
  String get newProperty => 'Nouveau bien';

  @override
  String get newProjectListing => 'Nouveau programme';

  @override
  String get noListingYet => 'Aucune annonce pour le moment';

  @override
  String get noListingYetHint =>
      'Créez votre première annonce : elle reste en brouillon jusqu\'à sa publication.';

  @override
  String get listingsNeedVerification =>
      'Vous pourrez publier dès que votre compte sera vérifié.';

  @override
  String get listingsReviewedByZaka =>
      'Vos annonces sont vérifiées par ZAKA avant d\'être publiées, généralement sous 24 h.';

  @override
  String listingsOnline(int online, int max) {
    return '$online / $max annonces en ligne';
  }

  @override
  String listingsOnlineUnlimited(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count annonces en ligne',
      one: '1 annonce en ligne',
    );
    return '$_temp0';
  }

  @override
  String planLabel(String name) {
    return 'Plan $name';
  }

  @override
  String get changePlan => 'Changer';

  @override
  String get untitledHotel => 'Hôtel sans nom';

  @override
  String get untitledListing => 'Annonce sans titre';

  @override
  String get untitledProject => 'Programme sans nom';

  @override
  String roomTypesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count types de chambres',
      one: '1 type de chambre',
      zero: 'Aucun type de chambre',
    );
    return '$_temp0';
  }

  @override
  String acceptanceRate(int rate) {
    return '$rate % de demandes acceptées';
  }

  @override
  String statsHotel(int views, int requests) {
    return '$views vues · $requests demandes';
  }

  @override
  String statsListing(int views, int leads) {
    return '$views vues · $leads contacts';
  }

  @override
  String moderationReason(String reason) {
    return 'Motif : $reason';
  }

  @override
  String get publish => 'Publier';

  @override
  String get sendForReview => 'Envoyer à la validation';

  @override
  String get publishedNow => 'Annonce en ligne.';

  @override
  String get sentForReview => 'Annonce envoyée à ZAKA pour validation.';

  @override
  String get takeOffline => 'Retirer de la ligne';

  @override
  String get takenOffline => 'Annonce retirée.';

  @override
  String get feature => 'Mettre à la une';

  @override
  String get unfeature => 'Retirer de la une';

  @override
  String get featuredNow => 'Annonce mise à la une.';

  @override
  String get markUnderOffer => 'Marquer « sous offre »';

  @override
  String get markRentedOrSold => 'Marquer louée / vendue';

  @override
  String get backOnline => 'Remettre disponible';

  @override
  String get markInProgress => 'Travaux en cours';

  @override
  String get markDelivered => 'Programme livré';

  @override
  String get seePublicListing => 'Voir l\'annonce';

  @override
  String get listingDraft => 'Brouillon';

  @override
  String get listingPendingReview => 'En validation';

  @override
  String get listingPublished => 'En ligne';

  @override
  String get listingRejected => 'Refusée';

  @override
  String get listingUnderOffer => 'Sous offre';

  @override
  String get listingRented => 'Louée';

  @override
  String get listingSold => 'Vendue';

  @override
  String get listingInactive => 'Hors ligne';

  @override
  String get listingInProgress => 'Travaux en cours';

  @override
  String get listingDelivered => 'Livré';

  @override
  String get listingSuspended => 'Suspendue';

  @override
  String get waitingForReview => 'En cours de validation par ZAKA';

  @override
  String get reviewAgainTitle => 'Nouvelle validation';

  @override
  String get reviewAgainBody =>
      'Votre annonce est en ligne : après modification, elle sera de nouveau vérifiée par ZAKA avant d\'être republiée.';

  @override
  String get tabInfo => 'Infos';

  @override
  String get tabPhotos => 'Photos';

  @override
  String get tabOffers => 'Offres';

  @override
  String get tabAvailability => 'Disponibilités';

  @override
  String get hotelIdentity => 'L\'hôtel';

  @override
  String get hotelName => 'Nom de l\'hôtel';

  @override
  String get stars => 'Classement';

  @override
  String get notRated => 'Non classé';

  @override
  String get receptionPhone => 'Téléphone de la réception';

  @override
  String get checkInTime => 'Heure d\'arrivée';

  @override
  String get checkOutTime => 'Heure de départ';

  @override
  String get cancellationPolicyLabel => 'Conditions d\'annulation';

  @override
  String get cancellationPolicyHint =>
      'Ex. gratuite jusqu\'à 24 h avant l\'arrivée';

  @override
  String get otherRules => 'Autres règles';

  @override
  String get photosHelp =>
      'Ajoutez des photos lumineuses : la première sert de couverture. 12 photos au plus, 8 Mo chacune.';

  @override
  String get addPhotos => 'Ajouter des photos';

  @override
  String get cover => 'Couverture';

  @override
  String get makeCover => 'Mettre en couverture';

  @override
  String photoTooLarge(String name) {
    return '$name dépasse 8 Mo.';
  }

  @override
  String get addRoomType => 'Ajouter un type de chambre';

  @override
  String get editRoomType => 'Modifier le type de chambre';

  @override
  String get noRoomTypeYet => 'Aucun type de chambre';

  @override
  String get noRoomTypeYetHint =>
      'Ajoutez vos chambres avec leur prix : il en faut au moins une pour publier.';

  @override
  String get roomTypeName => 'Type de chambre';

  @override
  String get roomTypeNameHint => 'Ex. Chambre double climatisée';

  @override
  String get pricePerNightLabel => 'Prix par nuit';

  @override
  String get roomsOfThisType => 'Nombre de chambres';

  @override
  String get beds => 'Lits';

  @override
  String get bedsHint => 'Ex. 1 grand lit';

  @override
  String get roomActive => 'Proposée aux clients';

  @override
  String roomQuantity(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count chambres',
      one: '1 chambre',
    );
    return '$_temp0';
  }

  @override
  String get inactiveRoom => 'non proposée';

  @override
  String get addOffer => 'Ajouter une offre';

  @override
  String get editOffer => 'Modifier l\'offre';

  @override
  String get noOfferYet => 'Aucune offre spéciale';

  @override
  String get noOfferYetHint =>
      'Créez une remise sur une période : elle s\'affiche sur votre fiche.';

  @override
  String get offerTitle => 'Titre de l\'offre';

  @override
  String get offerTitleHint => 'Ex. Spécial fêtes de fin d\'année';

  @override
  String get discount => 'Remise';

  @override
  String get offerPeriod => 'Choisir la période';

  @override
  String get offerRooms => 'Chambres concernées (aucune sélection : toutes)';

  @override
  String get offerActive => 'Offre active';

  @override
  String get offerIncomplete =>
      'Indiquez un titre, une remise entre 1 et 99 % et une période.';

  @override
  String get inactiveOffer => 'inactive';

  @override
  String get availabilityHelp =>
      'Indiquez les jours où vous avez moins de chambres libres (ou aucune). Les autres jours, toutes les chambres du type sont considérées comme disponibles.';

  @override
  String get roomsAvailable => 'Chambres libres';

  @override
  String get resetDay => 'Toutes libres';

  @override
  String get closeWholeMonth => 'Complet tout le mois';

  @override
  String get openWholeMonth => 'Tout disponible';

  @override
  String get listingMain => 'L\'annonce';

  @override
  String get listingTitle => 'Titre';

  @override
  String get listingTitleHint => 'Ex. Villa 4 pièces avec jardin à Ouaga 2000';

  @override
  String get rentPeriod => 'Loyer';

  @override
  String get perMonth => 'Par mois';

  @override
  String get perDay => 'Par jour';

  @override
  String get deposit => 'Caution';

  @override
  String get depositHint => 'Ex. 2 mois';

  @override
  String get advance => 'Avance sur loyer';

  @override
  String get advanceHint => 'Ex. 3 mois';

  @override
  String get agencyFees => 'Frais d\'agence';

  @override
  String get characteristics => 'Caractéristiques';

  @override
  String get surface => 'Surface';

  @override
  String get roomsLabel => 'Pièces';

  @override
  String get bedrooms => 'Chambres';

  @override
  String get bathrooms => 'Salles d\'eau';

  @override
  String get addressHelp =>
      'Restez général si vous préférez : le quartier suffit.';

  @override
  String get projectName => 'Nom du programme';

  @override
  String get deliveryDate => 'Livraison prévue';

  @override
  String get deliveryDateHint => 'Ex. 2e trimestre 2027';

  @override
  String get estimatedBudget => 'Budget estimé';

  @override
  String get addUnit => 'Ajouter un lot';

  @override
  String get editUnit => 'Modifier le lot';

  @override
  String get unitName => 'Nom du lot';

  @override
  String get receivedBookings => 'Demandes de réservation';

  @override
  String get receivedLeads => 'Demandes de contact';

  @override
  String toHandle(int count) {
    return 'À traiter ($count)';
  }

  @override
  String get closedRequests => 'Closes';

  @override
  String get noRequestHere => 'Aucune demande ici.';

  @override
  String answerBefore(String deadline) {
    return 'Répondre avant le $deadline';
  }

  @override
  String hotelPendingHelp(String deadline) {
    return 'Acceptez ou refusez avant le $deadline, sinon la demande expirera.';
  }

  @override
  String get hotelInfoRequestedHelp =>
      'Vous avez demandé des précisions : la réponse du client remettra la demande en attente.';

  @override
  String get hotelAcceptedHelp =>
      'Réservation confirmée. Le client peut payer en ligne ou sur place.';

  @override
  String get hotelPaidHelp =>
      'Réservation confirmée et payée en ligne (mode test).';

  @override
  String get askInfo => 'Demander des précisions';

  @override
  String get askInfoTitle => 'Question au client';

  @override
  String get rejectBookingTitle => 'Refuser la demande';

  @override
  String get cancelAcceptedTitle => 'Annuler la réservation';

  @override
  String get stayCompleted => 'Séjour terminé';

  @override
  String commissionDueFor(String amount) {
    return 'Commission ZAKA due pour ce séjour : $amount';
  }

  @override
  String get messageForClient => 'Message au client';

  @override
  String get messageForClientOptional => 'Message au client (facultatif)';

  @override
  String get takeCharge => 'Prendre en charge';

  @override
  String get scheduleVisit => 'Programmer une visite';

  @override
  String get changeVisit => 'Changer la visite';

  @override
  String get closeRequest => 'Clore la demande';

  @override
  String whatsappLeadText(String title) {
    return 'Bonjour, je vous contacte au sujet de « $title » sur ZAKA.';
  }

  @override
  String get badgeHotel => 'Hôtel';

  @override
  String starsValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count étoiles',
      one: '1 étoile',
    );
    return '$_temp0';
  }

  @override
  String upToGuests(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Jusqu\'à $count pers.',
      one: '1 pers.',
    );
    return '$_temp0';
  }

  @override
  String roomTypesValue(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count types de chambre',
      one: '1 type de chambre',
    );
    return '$_temp0';
  }

  @override
  String unitsLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lots disponibles',
      one: '1 lot disponible',
      zero: 'Complet',
    );
    return '$_temp0';
  }

  @override
  String deliveryShort(String date) {
    return 'Livraison $date';
  }

  @override
  String homeGreeting(String name) {
    return 'Bonjour $name 👋';
  }

  @override
  String get homeGreetingAnonymous => 'Bonjour 👋';

  @override
  String get homeTagline =>
      'Trouvez l\'hôtel ou le logement qui vous ressemble';

  @override
  String get homeSearchHint => 'Hôtel, location, achat…';

  @override
  String get homeSearchTitle => 'Que cherchez-vous ?';

  @override
  String get homeCategoryHotels => 'Hôtels';

  @override
  String get homeCategoryProjects => 'Neuf';

  @override
  String get homePopularCities => 'Villes populaires';

  @override
  String get citySearchHint => 'Rechercher une ville';

  @override
  String get seeRooms => 'Voir les chambres';

  @override
  String get accountStatUnread => 'Non lues';

  @override
  String get accountSectionActivity => 'Mon activité';

  @override
  String get accountSectionPro => 'Professionnels';

  @override
  String get accountSectionInfo => 'Informations';

  @override
  String get accountSectionAccount => 'Compte';

  @override
  String get signInWelcome => 'Bienvenue sur ZAKA';

  @override
  String get signInTagline =>
      'Réservez un hôtel, contactez les annonceurs et retrouvez vos favoris.';

  @override
  String get resetFilters => 'Réinitialiser';
}
