# Problème d'unification des modèles de données (Projet 1 / Projet 2)

## Contexte

Le script `seed_unified_only_proj1.sql` vise à peupler la base uniquement avec les entités du Projet 1 (projects, campagnes, news, etc.) et à lier toutes les contributions/transactions à ces campagnes/projets (UUID).

README – Création du Dashboard Statistiques avec filtre global de dates dans Metabase
Objectif

Guide pour créer tes 5 questions Metabase (interface graphique)
Story 2 – Montant total collecté sur une période

Résultat attendu : date | amount_eur

Étapes :
Nouvelle question → table transactions.
Filtrer sur statut = captured.
Regrouper par date sur la colonne createdAt (par jour, mois, ou selon ton besoin).
Résumé → Somme de montant.
Ne pas fixer la date, pour laisser la plage vide. Tu ajouteras un filtre global plus tard.
Choisis une visualisation type tableau ou graphique à barres pour voir l’évolution par date.
Story 3 – Taux de succès global

Résultat attendu : total_campaigns | successful | failed | active | success_rate_percent

Étapes :
Nouvelle question → table campagnes.
Résumer → Nombre total (total_campaigns).
Crée 3 filtres ou segments via “Filtrer par champ” :
statut est dans (REUSSIE, SUCCESSFUL) → successful
statut est dans (ECHOUEE, FAILED) → failed
statut est dans (ACTIVE, EN_COURS) → active

Ajoute une colonne personnalisée pour calculer le taux de succès :

success_rate_percent = (successful / (successful + failed)) * 100
Cette question est globale (pas besoin de filtre date sauf si tu veux affiner).
Story 4 – Nombre total de contributions sur une période

Résultat attendu : date | count

Étapes :
Nouvelle question → table contributions.
Regrouper par date sur createdAt (jour, mois, etc.).
Résumer → Nombre de lignes (count).
Pas de filtre date fixé dans la question.
Story 5 – Nombre moyen de contributions par campagne

Résultat attendu : total_contributions | total_campaigns | average

Étapes :

C’est un peu plus complexe, car ça combine deux tables et un ratio. Voici comment procéder en GUI :

Crée une question Contributions :
Filtrer par date sur createdAt (laisser vide).
Résumer → Nombre total de contributions.
Sauvegarde comme total_contributions.
Crée une question Campagnes :
Filtrer statut dans (ACTIVE, EN_COURS).
Filtrer date dateDebut <= et dateFin >= la même plage (laisser vide).
Résumer → Nombre total de campagnes actives.
Sauvegarde comme total_campaigns.
Sur un dashboard, ajoute les deux questions.

Crée un champ calculé dans le dashboard :

average = total_contributions / total_campaigns
Story 6 – Montant moyen par contribution

Résultat attendu : total_amount_eur | total_contributions | average_eur

Étapes :
Nouvelle question → table contributions.
Filtrer par date sur createdAt (laisser vide).
Résumer →
Somme de montant → total_amount_eur
Nombre de lignes → total_contributions

Crée une colonne personnalisée :

average_eur = total_amount_eur / total_contributions
Final – Créer le dashboard avec filtre global
Crée un nouveau dashboard.
Ajoute les 5 questions.
Ajoute un filtre global Date (plage).
Connecte ce filtre à chaque question via le champ createdAt ou date pertinente.
Teste la plage de dates : toutes les questions se mettront à jour automatiquement.