# ZAKA

Marketplace hôtellerie et immobilier pour la zone UEMOA (priorité Burkina Faso).
Flutter (Android + web) · Firebase · Google Cloud (`europe-west1`).

| Document | Contenu |
|---|---|
| [docs/PLAN_CONCEPTION.md](docs/PLAN_CONCEPTION.md) | Architecture, modèle de données, fonctionnalités, phases |
| [docs/MISE_EN_PLACE.md](docs/MISE_EN_PLACE.md) | Comptes et services à créer |
| [docs/CGU_ET_CONFIDENTIALITE.txt](docs/CGU_ET_CONFIDENTIALITE.txt) | Textes juridiques (brouillon) |

## Organisation du dépôt

```
app/          Application Flutter
  lib/main.dart          app publique (Android + web)
  lib/main_admin.dart    back-office (web)
functions/    Cloud Functions TypeScript + tests des règles
firebase/     Règles Firestore et Storage, index
docs/         Cahier des charges, plan, documents
```

## Prérequis

- Flutter 3.44.8 (stable)
- Node.js 22 (`nvm install 22 && nvm use 22`)
- Java 21 (émulateurs Firebase)
- Firebase CLI : `npm install -g firebase-tools`

## Démarrer en local (sans compte Firebase)

Tant que les projets `zaka-dev`, `zaka-staging` et `zaka-prod` n'existent pas, tout tourne sur les
**émulateurs Firebase** avec le projet de démonstration `demo-zaka`.

```bash
# 1. Installer et compiler les Cloud Functions
cd functions
npm install
npm run build

# 2. Lancer les émulateurs (Auth, Firestore, Storage, Functions)
#    Console : http://localhost:4000
npm run serve

# 3. Dans un autre terminal : lancer l'app
cd app
flutter pub get
flutter run -d chrome --dart-define=FLAVOR=dev                          # app publique (web)
flutter run -d chrome -t lib/main_admin.dart --dart-define=FLAVOR=dev   # back-office
flutter run --flavor dev --dart-define=FLAVOR=dev --dart-define=EMULATOR_HOST=10.0.2.2   # émulateur Android
```

### Données de départ

```bash
cd functions
npm run seed-catalog     # villes UEMOA, équipements, types de biens
npm run seed-billing     # plan Gratuit et commission hôtelière par défaut (valeurs provisoires)
```

### Options de build (vrais projets)

| Option | Effet |
|---|---|
| `--dart-define=USE_EMULATORS=false` | Vise le vrai projet dev (`zaka-dev-01`) au lieu des émulateurs |
| `--dart-define=FCM_VAPID_KEY=…` | Notifications push sur le web (clé Web Push de la console, publique) |
| `--dart-define=APP_CHECK=true --dart-define=RECAPTCHA_ENTERPRISE_KEY=…` | Active App Check |
| `--dart-define=PUBLIC_SITE_URL=…` | Back-office : adresse du site public (liens « Voir l'annonce ») |

### Paiements

Au MVP, les paiements sont **simulés** : l'écran de paiement affiche « Mode test : aucun
paiement réel » et l'on choisit l'issue (réussite, échec, annulation). Les tarifs se
règlent dans le back-office, menu *Facturation* (admins).

### Connexion par SMS en local

L'émulateur n'envoie pas de SMS : le code apparaît dans la console des émulateurs
(http://localhost:4000/auth) et dans le terminal qui les a lancés.

### Devenir admin en local

1. Créer un compte depuis l'app (onglet **Compte**).
2. Lui donner le rôle admin (émulateurs démarrés) :
   ```bash
   cd functions
   npm run set-role -- votre@email.com admin
   ```
3. Se déconnecter puis se reconnecter sur le back-office.

## Tests

```bash
cd app && flutter analyze && flutter test        # app
cd functions && npm test                          # logique des Cloud Functions
cd functions && npm run test:emulators            # règles de sécurité Firestore et Storage (émulateurs)
cd functions && npm run test:integration          # parcours complets sur les émulateurs (Functions comprises)
```

## Génération de code

Après toute modification d'un modèle `freezed` ou d'un fichier `.arb` :

```bash
cd app
dart run build_runner build -d
flutter gen-l10n
```

## Identité visuelle

| Élément | Où |
|---|---|
| Couleurs (vert `#0B4A3C`, doré `#E6AD5E`, teintes des catégories) et thème Material | `app/lib/app/theme.dart` (`ZakaColors`, `ZakaPalette`) |
| Police **Plus Jakarta Sans** (licence SIL OFL) | `app/assets/fonts/` |
| Logo dans l'app (noir sur transparent, recoloré à l'affichage par `ZakaLogo`) | `app/assets/brand/` |
| Sources de l'icône et de l'écran de démarrage | `app/branding/` (logo d'origine : `logo_source.jpg`) |
| Composants communs (cartes d'annonce, en-tête des fiches, tuiles, menus) | `app/lib/core/widgets/listing_widgets.dart` |

Après une modification du logo, régénérer l'icône et l'écran de démarrage (Android et web) :

```bash
cd app
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## Environnements

| Flavor | Projet Firebase | Identifiant Android |
|---|---|---|
| `dev` | `demo-zaka` (émulateurs, par défaut) ou `zaka-dev-01` (`--dart-define=USE_EMULATORS=false`) | `com.zaka.app.dev` |
| `staging` | `zaka-staging` (pas encore configuré) | `com.zaka.app.staging` |
| `prod` | `zaka-prod-8c5c8` (pas encore configuré) | `com.zaka.app` |

Brancher un vrai projet : voir `app/lib/app/firebase_options.dart`.

Lancer l'app web en local sur `zaka-dev-01` plutôt que sur les émulateurs :

```powershell
flutter run -d chrome --web-port 5000 --dart-define=FLAVOR=dev --dart-define=USE_EMULATORS=false
```

### Clés d'API Firebase

Les clés présentes dans `firebase_options_*.dart`, `google-services.json` et
`web/firebase-messaging-sw.js` ne sont **pas des secrets** : elles identifient le projet
et sont de toute façon lisibles dans le code de tout site web Firebase (voir
https://firebase.google.com/docs/projects/api-keys). GitHub les signale quand même ; on
ferme ces alertes avec « Won't fix ». Ce qui protège les données : les règles Firestore et
Storage, les contrôles des Cloud Functions, puis App Check (phase 5). Chaque clé est
restreinte dans Google Cloud (voir `docs/MISE_EN_PLACE.md`, « Clés d'API »).

Les vrais secrets (comptes de service, clés CinetPay, mot de passe SMTP) ne vont jamais
dans le dépôt : ils sont dans Secret Manager.

### Sites de dev

- App publique : https://zaka-dev-01.web.app
- Back-office : https://zaka-admin-dev.web.app

### Déployer sur zaka-dev-01 (PowerShell)

Depuis la racine du dépôt :

```powershell
# Règles, index et Cloud Functions.
# Le chargement du code des Functions dépasse parfois les 10 s par défaut sous Windows.
$env:FUNCTIONS_DISCOVERY_TIMEOUT = "60"
firebase deploy --only firestore,storage,functions -P dev
```

Sites web : compiler depuis `app/`, puis déployer depuis la racine. Les options du vrai projet
dev (pas d'émulateurs, clé Web Push, adresse du site public) sont dans `app/config/dev.json` :
uniquement des valeurs publiques, jamais de secret dans ce dossier.

```powershell
cd app
flutter build web --dart-define-from-file=config/dev.json
flutter build web -t lib/main_admin.dart --output build/web_admin --dart-define-from-file=config/dev.json
cd ..
firebase deploy --only hosting -P dev
```

Catalogues et rôle du premier admin sur un vrai projet : voir le mode d'emploi
en tête de `functions/scripts/seed-catalog.mjs` et `functions/scripts/set-role.mjs`.
