# ZAKA — Ce qu'il faut créer

> Liste de tout ce qu'il faut mettre en place avant et pendant le développement : comptes, projets cloud, code, services externes.
> À cocher au fur et à mesure. Complément de [PLAN_CONCEPTION.md](PLAN_CONCEPTION.md).

**Rappel : il n'y a pas de serveur à louer ni à administrer.** Le back-end est entièrement porté par Firebase et Google Cloud : Firestore pour les données, Cloud Functions pour la logique serveur, Hosting pour les sites web.

---

## 1. Comptes à ouvrir (une seule fois)

Ouvrir ces comptes au nom de **la structure ZAKA**, avec une adresse e-mail partagée (par exemple `tech@…`), et non avec un compte personnel. Ajouter William et Herman comme administrateurs.

| # | Compte | Pour quoi faire | Coût |
|---|---|---|---|
| ☐ 1 | **Compte Google de la structure** + **Organisation Google Cloud** (via Google Workspace ou Cloud Identity gratuit) | Posséder les projets GCP/Firebase indépendamment des comptes personnels | Gratuit (Cloud Identity Free) |
| ☐ 2 | **Compte de facturation Google Cloud** | Obligatoire pour le plan Blaze (Cloud Functions, sauvegardes, Secret Manager) | Paiement à l'usage, très faible au début |
| ☐ 3 | **Organisation GitHub** `zaka-…` | Dépôt de code, CI/CD (GitHub Actions) | Gratuit |
| ☐ 4 | **Google Play Console** | Publier l'app Android | 25 USD une fois |
| ☐ 5 | **Nom de domaine** (par exemple `zaka.africa` ou `zaka.<pays>`) | Site web, e-mails, liens profonds | ~10 à 50 USD / an |
| ☐ 6 | **Brevo** (ou SendGrid) | Envoi des e-mails transactionnels | Gratuit jusqu'à 300 e-mails / jour |
| ☐ 7 | **CinetPay** : compte marchand + accès **sandbox** | Paiements. Au MVP, seul le sandbox sert à préparer l'intégration | Commission par transaction (phase 6) |

---

## 2. Projets Firebase / Google Cloud

### 2.1 Trois projets

| Projet | Usage | Données |
|---|---|---|
| ☑ `zaka-dev-01` | Développement quotidien | Données factices |
| ☑ `zaka-staging` | Tests avant mise en production, démos | Copie anonymisée ou jeu de test |
| ☑ `zaka-prod-8c5c8` | Production | Données réelles |

Les ID `zaka-dev` et `zaka-prod` étant déjà pris, Firebase a ajouté un suffixe. Les alias `dev`, `staging` et `prod` de `.firebaserc` pointent vers ces ID : `firebase deploy -P dev`.

Pour **chaque** projet :

- ☑ (dev) Passer au plan **Blaze** et le rattacher au compte de facturation
- ☑ (dev) Créer la base **Firestore** en mode natif, région **`europe-west1`** (⚠️ choix définitif)
- ☑ (dev) Créer le bucket **Storage** en `europe-west1`
- ☑ Fixer la région par défaut des **Cloud Functions** : `europe-west1`
- ☑ (dev) Créer une **alerte de budget** (par exemple 20 €, 50 € et 100 € par mois en dev/staging, à ajuster en prod)

### 2.2 Services Firebase à activer

| Service | Réglages à faire |
|---|---|
| ☑ (dev) **Authentication** | Activer Téléphone, E-mail/mot de passe et Google. Dans *Paramètres → Politique de région SMS*, **autoriser uniquement** les 8 pays UEMOA. Ajouter des numéros de test en dev. Dans *Paramètres → Domaines autorisés*, ajouter les domaines des deux sites web |
| ◐ **Empreintes Android** | Fait pour la clé de debug en dev (`firebase apps:android:sha:create`). Ajouter les empreintes **SHA-1 et SHA-256** de chaque clé de signature (debug, upload, et clé Google Play App Signing) dans les paramètres de l'app Android. Indispensable pour la connexion par SMS (Play Integrity) et Google |
| ☑ (dev) **Firestore** | Déployer `firestore.rules` et `firestore.indexes.json` depuis le dépôt (jamais à la main dans la console) |
| ☑ (dev) **Storage** | Déployer `storage.rules`. Dossiers : `public/` (photos d'annonces) et `private/verification/` (IFU, RCCM, justificatifs) |
| ☑ (dev) **Cloud Functions** | Déployées depuis le dossier `functions/` |
| ☑ (dev) **Hosting** | Créer **2 sites** : `zaka-<env>` (site public + espace pro) et `zaka-admin-<env>` (back-office). En dev : `zaka-dev-01` et `zaka-admin-dev`, reliés aux cibles `public` et `admin` par `firebase target:apply` |
| ☑ **Cloud Messaging (FCM)** | Rien à configurer pour Android. Pour le web : clé VAPID générée (dev : dans `app/config/dev.json`) ; pour staging et prod, générer la **clé VAPID** (*Paramètres → Cloud Messaging → Web Push*) et la passer au build web : `--dart-define=FCM_VAPID_KEY=…`. Sans elle, le web n'a pas de push (les notifications restent visibles dans l'app) |
| ☐ **App Check** | Play Integrity (Android), reCAPTCHA Enterprise (web). Créer la clé reCAPTCHA Enterprise, l'enregistrer dans *App Check*, puis builder avec `--dart-define=APP_CHECK=true --dart-define=RECAPTCHA_ENTERPRISE_KEY=…`. Commencer en mode « surveillance » avant de l'imposer. À faire avec la création de la fiche Play Console : tant que Play Integrity ne marche pas sur Android, App Check ne peut pas être imposé et n'apporte aucune protection |
| ◐ **Clés d'API** | Dans *Google Cloud → API et services → Identifiants*, garder la restriction d'API posée par Firebase (API Firebase seulement) et ajouter une restriction d'application. **Clé web** : sites `https://<site>.web.app/*` et `https://<projet>.firebaseapp.com/*` de chaque site, plus `http://localhost:5000/*` en dev (fait sur `zaka-dev-01`). **Clé Android** : nom du paquet et SHA-1 de chaque clé de signature, **à faire après les premiers tests sur téléphone** (une restriction mal posée bloque la connexion par SMS) |
| ☐ **Remote Config** | Créer les paramètres `payments_provider` = `simulation`, `module_installments` = `false`, `module_investments` = `false`, `min_app_version` |
| ☐ **Crashlytics** + **Analytics** | Activés par défaut avec FlutterFire |

### 2.3 Extensions Firebase à installer

| Extension | Réglages |
|---|---|
| ☐ **Resize Images** | Tailles 200×200, 600×400, 1200×800, format WebP. Uniquement sur le dossier `public/` |
| ☐ **Trigger Email from Firestore** | Branchée sur le SMTP de Brevo, collection `mail` (déjà alimentée par la fonction `onNotificationCreated` : tant que l'extension n'est pas installée, les e-mails attendent dans la collection) |
| ☐ **Stream Firestore to BigQuery** (optionnel au début) | Pour les statistiques avancées |

### 2.4 Services Google Cloud à configurer

| Service | Réglages |
|---|---|
| ☐ **Secret Manager** | Secrets : `BREVO_SMTP_PASSWORD`, `CINETPAY_API_KEY`, `CINETPAY_SITE_ID`, `CINETPAY_SECRET_KEY` (sandbox en dev/staging) |
| ◐ **Sauvegardes Firestore et Storage** | Point-in-time recovery, sauvegardes quotidienne (7 jours) et hebdomadaire (14 semaines), versionnage Storage (30 jours) : commandes dans [SAUVEGARDE_RESTAURATION.md](SAUVEGARDE_RESTAURATION.md). En place sur `zaka-dev-01`, à refaire sur staging et prod |
| ☐ **Cloud Scheduler** | Créé automatiquement par les fonctions planifiées (expiration des demandes, rappels, stats) |
| ☐ **BigQuery** | Dataset `zaka_analytics` en `EU` |
| ☐ **Cloud Monitoring** | Alertes : erreurs des Functions, pics de lectures Firestore |
| ☐ **Comptes de service CI** | Un compte de service par projet, avec les rôles strictement nécessaires au déploiement. Authentification GitHub Actions par **Workload Identity Federation** (pas de clé JSON dans GitHub) |

---

## 3. Dépôt de code

### 3.1 Un seul dépôt (monorepo)

```
zaka/
├── app/                      # projet Flutter (mobile + web public + web admin)
├── functions/                # Cloud Functions TypeScript
├── firebase/
│   ├── firestore.rules
│   ├── firestore.indexes.json
│   ├── storage.rules
│   └── remoteconfig.template.json
├── scripts/                  # données de démo, comptes de test, migrations
├── docs/                     # plan de conception, procédures
├── firebase.json
├── .firebaserc               # alias dev / staging / prod
└── .github/workflows/        # CI : tests, analyse, déploiement
```

- ☐ Créer le dépôt `zaka` dans l'organisation GitHub
- ☐ Protéger la branche `main` (relecture obligatoire, CI verte)
- ☐ Branches : `main` (prod), `develop` (staging), branches de fonctionnalité
- ☑ Ajouter `.gitignore` pour Flutter, Node et les fichiers secrets (`*.jks`, `key.properties`, `.env`, `service-account*.json`)

### 3.2 Projet Flutter (`app/`)

- ☑ `flutter create --org com.zaka --platforms android,web app`
- ☑ Configurer les **flavors** `dev`, `staging`, `prod` (identifiants d'app distincts, par exemple `com.zaka.app.dev`)
- ◐ `flutterfire configure` une fois **par flavor** (fait pour dev, commande dans `lib/app/firebase_options.dart`), ce qui génère un `firebase_options_<env>.dart` et un `android/app/src/<env>/google-services.json` pour chacun
- ☑ Deux points d'entrée : `lib/main.dart` (app publique) et `lib/main_admin.dart` (admin, build web avec `-t lib/main_admin.dart`)
- ☐ Créer la **clé de signature Android** (upload key) et la conserver hors du dépôt, dans un coffre partagé

**Paquets principaux**

| Rôle | Paquets |
|---|---|
| Firebase | `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `cloud_functions`, `firebase_messaging`, `firebase_app_check`, `firebase_remote_config`, `firebase_crashlytics`, `firebase_analytics` |
| Architecture | `flutter_riverpod`, `riverpod_annotation`, `go_router` |
| Modèles | `freezed`, `freezed_annotation`, `json_serializable`, `build_runner` |
| Interface | `cached_network_image`, `image_picker`, `flutter_image_compress`, `intl`, `flutter_localizations` |
| Carte et géo | `google_maps_flutter` (ou `flutter_map` + OpenStreetMap, sans clé payante), `geoflutterfire_plus` |
| Fichiers | `file_picker` (dépôt des pièces IFU, RCCM, bail en PDF ou photo) |
| Tests | `mocktail`, `fake_cloud_firestore`, `firebase_auth_mocks` |

### 3.3 Cloud Functions (`functions/`)

- ☑ `firebase init functions` en **TypeScript**, Node.js 22
- ☐ Structure : `src/auth/`, `src/organizations/`, `src/bookings/`, `src/billing/` (commissions, abonnements, `PaymentGateway`), `src/leads/`, `src/moderation/`, `src/scheduled/`
- ☐ Implémenter `PaymentGateway` avec `SimulatedGateway` au MVP. `CinetPayGateway` viendra en phase 6
- ☑ Validation des entrées avec `zod`
- ☑ Tests avec l'**émulateur Firebase** : règles Firestore (`npm run test:emulators`) et logique (`npm test`, vitest)

### 3.4 Outils sur chaque poste de développement

- ☐ Flutter SDK (version stable, la même pour William et Herman : la figer avec **FVM**)
- ☐ Node.js 22 et `firebase-tools` (CLI Firebase)
- ☐ `gcloud` CLI
- ☐ Java 21 (pour l'émulateur Firebase et Android)
- ☐ Android Studio (SDK et émulateur)
- ☐ VS Code avec les extensions Flutter, Dart et ESLint

---

## 4. Intégration continue (GitHub Actions)

| Workflow | Déclencheur | Étapes |
|---|---|---|
| ☑ `ci.yml` | Chaque pull request | `flutter analyze`, `flutter test`, lint et tests des Functions, **tests des règles de sécurité** sur l'émulateur |
| ☐ `deploy-staging.yml` | Push sur `develop` | Déploiement des règles, index, Functions et des 2 sites web sur `zaka-staging`. App Android sur Firebase App Distribution |
| ☐ `deploy-prod.yml` | Tag de version `v*` sur `main` | Même chose sur `zaka-prod`, après validation manuelle |

La publication sur Google Play peut être automatisée plus tard (piste interne via l'API Play Developer).

---

## 5. Données et comptes de départ

- ☑ Script `functions/scripts/seed-catalog.mjs` (`npm run seed-catalog`) : villes des 8 pays UEMOA (Burkina Faso en tête), équipements, types de biens. À lancer une fois par projet, puis les listes se gèrent dans le back-office. Lancé sur `zaka-dev-01`
- ◐ Plan d'abonnement **« Gratuit »** et règle de commission hôtelière par défaut : script `npm run seed-billing` (valeurs **provisoires** : 3 annonces, 10 % par réservation, à fixer par l'équipe dans *Facturation* du back-office). À lancer sur chaque projet ; fait sur `zaka-dev-01`
- ☐ `config/app` avec `bookingExpiryHours: 48`
- ◐ Premier compte **admin** : `npm run set-role -- email admin`, une seule fois par projet (mode d'emploi PowerShell en tête du script) ; les rôles suivants se donnent depuis le back-office. Fait sur `zaka-dev-01`
- ☐ Comptes de test en dev/staging : 1 client, 1 hôtel vérifié, 1 agence vérifiée, 1 particulier, 1 modérateur
- ☐ Jeu de démonstration : quelques hôtels, chambres et biens avec photos

---

## 6. Documents non techniques à préparer

Ils sont obligatoires pour publier sur les stores ou exigés par le cahier des charges.

- ☐ **Conditions générales d'utilisation** et **politique de confidentialité** : première version rédigée dans [CGU_ET_CONFIDENTIALITE.txt](CGU_ET_CONFIDENTIALITE.txt). À compléter, à faire relire par un juriste, puis à publier sur le Google Site (l'URL de la politique de confidentialité est exigée par Google Play)
- ☐ Vérifier auprès de la **CIL du Burkina Faso** les formalités de déclaration du traitement des données
- ☐ **Conditions partenaires** (règles de publication, commissions, abonnements)
- ☐ Fiches des stores : nom, description, captures d'écran, icône, catégorie
- ☑ Procédure de **sauvegarde et restauration** (livrable du cahier des charges) : [SAUVEGARDE_RESTAURATION.md](SAUVEGARDE_RESTAURATION.md)

---

## 7. Ordre conseillé

1. Comptes 1 à 3, puis les 3 projets Firebase (sections 1 et 2.1)
2. Dépôt GitHub + projet Flutter + Functions (section 3)
3. Services Firebase et Remote Config sur `zaka-dev` (section 2.2)
4. CI de base (section 4)
5. Script de données et comptes de test (section 5)
6. Compte Google Play, domaine, Brevo : à faire **en parallèle**. La validation d'un compte Play d'organisation peut prendre quelques jours
7. CinetPay sandbox : avant la phase 6 seulement
