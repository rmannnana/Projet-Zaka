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
```

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

## Environnements

| Flavor | Projet Firebase | Identifiant Android |
|---|---|---|
| `dev` | `demo-zaka` (émulateurs, par défaut) ou `zaka-dev-01` (`--dart-define=USE_EMULATORS=false`) | `com.zaka.app.dev` |
| `staging` | `zaka-staging` (pas encore configuré) | `com.zaka.app.staging` |
| `prod` | `zaka-prod-8c5c8` (pas encore configuré) | `com.zaka.app` |

Brancher un vrai projet : voir `app/lib/app/firebase_options.dart`.

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

Sites web : compiler depuis `app/`, puis déployer depuis la racine :

```powershell
cd app
flutter build web --dart-define=FLAVOR=dev --dart-define=USE_EMULATORS=false
flutter build web -t lib/main_admin.dart --output build/web_admin --dart-define=FLAVOR=dev --dart-define=USE_EMULATORS=false
cd ..
firebase deploy --only hosting -P dev
```

Catalogues et rôle du premier admin sur un vrai projet : voir le mode d'emploi
en tête de `functions/scripts/seed-catalog.mjs` et `functions/scripts/set-role.mjs`.
