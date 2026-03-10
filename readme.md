# Environnement de Dev - WeFund

Ce projet git a pour but la création d'un environnement de dev commun à tous les projets pour qu'ils puissent profiter de la même infra au besoin

## Prémières étapes
Si c'est votre prémière fois configurant l'environnement de dev, lancez la commande suivante:

```bash
make clone-projects
```

Ça clonera tous les projets git disponibles pour la première fois et les rajoutera sur les dossiers dépendants pour les lancer ensemble

## Mise à jour
Pour mettre à jour les repos git disponibles sur l'environnement, vous pouvez lancer la commande suivante:

```bash
make pull-projects
```

ATTENTION!
Cette commmande va changer automatiquement tous les branches du projet vers la main et fera un pull des repos git, si vous avez fait des changements, pensez à les commit sur une nouvelle branche ou faire un stash avant de le lancer

## Lancement des projets ensemble
TODO