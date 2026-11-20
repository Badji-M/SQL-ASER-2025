# Base de données relationnelle : Électrification rurale (ASER)

Conception et implémentation d'une base de données relationnelle pour le suivi des programmes de l'Agence Sénégalaise d'Électrification Rurale (ASER).

**Auteurs :** Pape Mamadou BADJI, Ndeye Aïssatou CISSE (ENSAE)
**Date :** juillet 2025

---

## Contexte

L'électrification rurale demande de suivre à la fois la localisation des villages, leur statut d'électrification, les installations déployées, la consommation et la maintenance. Ce projet propose un modèle de données unique qui centralise ces informations et permet de les interroger pour appuyer la planification, en particulier pour identifier les villages prioritaires.

## Modèle de données

La base comporte 11 tables, organisées autour de la table centrale `village`.

| Table | Rôle |
|---|---|
| `region` | Régions administratives |
| `departement` | Départements, rattachés à une région |
| `commune` | Communes, rattachées à un département |
| `village` | Table centrale : localisation (latitude, longitude), population, statut et date d'électrification |
| `priorite` | Villages jugés prioritaires, avec niveau, motif et date de classement |
| `electrification` | Installations : type de source d'énergie, puissance, date, durée, coût |
| `consommation` | Consommation annuelle en kWh par village |
| `appareil` | Types d'appareils, puissance et durée de vie |
| `utilisation_appareil` | Nombre d'appareils par village |
| `maintenance` | Opérations de maintenance et leur coût (FCFA) |
| `distance_village` | Distances entre villages, pour les calculs de proximité |

La hiérarchie administrative suit le découpage `region` > `departement` > `commune` > `village`, avec des clés étrangères à chaque niveau.

## Contenu du dépôt

| Fichier | Description |
|---|---|
| `electrification.sql` | Script complet : création des tables, contraintes, insertion des données et requêtes d'analyse |
| `electrification.pdf` | Rapport du projet : modélisation, schéma et résultats des requêtes |

## Utilisation

Avec MySQL :

```bash
mysql -u <utilisateur> -p < electrification.sql
```

Le script peut aussi être exécuté depuis MySQL Workbench ou tout autre client SQL compatible.

## Compétences mobilisées

- Modélisation conceptuelle et logique d'une base relationnelle
- Normalisation et contraintes d'intégrité (clés primaires et étrangères)
- Requêtes SQL d'analyse : jointures, agrégations, sous-requêtes
- Application à un cas concret de politique publique
