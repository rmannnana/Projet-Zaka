# ZAKA — Sauvegarde et restauration

> Procédure exigée par le cahier des charges. À appliquer sur chaque projet (`zaka-dev-01`,
> `zaka-staging`, `zaka-prod-8c5c8`), en priorité sur la production.
> Les commandes se lancent depuis n'importe quel dossier, avec `gcloud` connecté à un compte
> propriétaire du projet.

## 1. Ce qui est sauvegardé

| Donnée | Où | Sauvegarde |
|---|---|---|
| Comptes, annonces, demandes, messages, commissions, paiements, journal d'audit | Firestore | Point-in-time recovery (7 jours) + sauvegarde quotidienne conservée 7 jours + sauvegarde hebdomadaire (dimanche) conservée 14 semaines |
| Photos d'annonces, pièces justificatives, exports de litiges | Cloud Storage | Versionnage des objets : un fichier supprimé ou écrasé reste récupérable 30 jours, puis il est effacé automatiquement |
| Comptes de connexion (e-mail, téléphone, Google) | Firebase Authentication | Export mensuel (`firebase auth:export`) conservé hors du projet |
| Code, règles de sécurité, index, scripts | GitHub | Historique git ; tout se redéploie depuis le dépôt |

Les règles de sécurité et les index ne se sauvegardent pas à part : ils viennent du dépôt
(`firebase/firestore.rules`, `firebase/storage.rules`, `firebase/firestore.indexes.json`).

## 2. Mise en place (une fois par projet)

| Projet | État |
|---|---|
| `zaka-dev-01` | ✅ En place depuis le 25/11/2026 |
| `zaka-staging` | ☐ À faire après activation de la facturation |
| `zaka-prod-8c5c8` | ☐ À faire avant l'ouverture au public |

Remplacer `PROJET` par l'identifiant du projet (ex. `zaka-prod-8c5c8`). Commandes à lancer
depuis la racine du dépôt (le fichier `docs/storage-lifecycle.json` y est référencé).

```powershell
# Point-in-time recovery : retour possible à n'importe quelle minute des 7 derniers jours.
gcloud firestore databases update --database="(default)" --enable-pitr --project=PROJET

# Sauvegardes de toute la base. Google limite une sauvegarde quotidienne à 7 jours de
# conservation et une hebdomadaire à 14 semaines : on cumule les deux.
gcloud firestore backups schedules create --database="(default)" --recurrence=daily --retention=7d --project=PROJET
gcloud firestore backups schedules create --database="(default)" --recurrence=weekly --day-of-week=SUN --retention=14w --project=PROJET

# Versionnage du bucket Storage, et suppression des anciennes versions après 30 jours.
gcloud storage buckets update gs://PROJET.firebasestorage.app --versioning --lifecycle-file=docs/storage-lifecycle.json --project=PROJET
```

Après une suppression de compte, les copies de sauvegarde disparaissent donc au plus tard
14 semaines plus tard ; la politique de confidentialité l'indique (article 6.2).

Vérifier :

```powershell
gcloud firestore backups schedules list --database="(default)" --project=PROJET
gcloud firestore backups list --location=europe-west1 --project=PROJET
```

Export mensuel des comptes de connexion (fichier à ranger dans le coffre de l'équipe, jamais dans le dépôt) :

```powershell
firebase auth:export comptes-AAAA-MM.json --format=json --project PROJET
```

## 3. Restaurer

### 3.1 Une erreur récente (moins de 7 jours) : lecture à une date passée

Le point-in-time recovery permet de relire un document tel qu'il était à une minute donnée,
puis de le réécrire. C'est la voie à privilégier pour réparer quelques documents (annonce
effacée par erreur, mauvaise manipulation dans le back-office).

### 3.2 Base entière : restauration d'une sauvegarde quotidienne

La restauration crée une **nouvelle base** ; l'app continue d'utiliser `(default)` pendant ce temps.

```powershell
gcloud firestore backups list --location=europe-west1 --project=PROJET
gcloud firestore databases restore --source-backup=projects/PROJET/locations/europe-west1/backups/ID_SAUVEGARDE --destination-database=restauration-AAAAMMJJ --project=PROJET
```

Ensuite, selon le besoin :

- **Récupérer des données** : copier les documents utiles de `restauration-AAAAMMJJ` vers `(default)` avec un script Admin SDK ;
- **Revenir entièrement en arrière** (incident majeur) : prévenir les utilisateurs, exporter la base restaurée et la réimporter dans `(default)` (`gcloud firestore export` / `gcloud firestore import`), puis supprimer la base temporaire.

### 3.3 Fichier Storage supprimé ou écrasé

```powershell
gcloud storage ls --all-versions gs://PROJET.firebasestorage.app/public/orgs/ID_COMPTE/
gcloud storage cp "gs://PROJET.firebasestorage.app/CHEMIN#GENERATION" gs://PROJET.firebasestorage.app/CHEMIN
```

### 3.4 Règles, index ou fonctions cassés par un déploiement

Revenir au dernier commit sain puis redéployer depuis la racine du dépôt :

```powershell
git checkout <commit-sain>
firebase deploy --only firestore,storage,functions -P prod
```

## 4. Exercice de restauration

Une fois par trimestre, sur `zaka-staging` : restaurer la dernière sauvegarde dans une base
temporaire, vérifier quelques documents (un compte pro, une réservation, une commission),
puis supprimer la base temporaire. Noter la date et le résultat ci-dessous.

| Date | Projet | Sauvegarde utilisée | Résultat | Par |
|---|---|---|---|---|
| | | | | |
