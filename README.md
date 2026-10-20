## Script

### ASDevops - 2026-27
Cahier des charges — Script PowerShell
TP : Développement d'un jeu interactif « Devine le nombre »

9. Recette et critères de validation
Le projet sera considéré comme fonctionnel si les scénarios de test suivants sont satisfaits.
Grille de recette
0/12 validés

T01 — Lancement sur un système sans fichier de scores
Menu affiché sans erreur
T02 — Saisie d'un choix de menu invalide
Nouveau choix demandé
T03 — Saisie de lettres à la place d'un nombre
Message d'erreur, tentative non consommée
T04 — Nombre proposé hors des bornes
Proposition refusée
T05 — Nombre proposé inférieur au secret
Indication « Plus grand »
T06 — Nombre proposé supérieur au secret
Indication « Plus petit »
T07 — Nombre exact proposé
Victoire et score correct
T08 — Épuisement des tentatives
Défaite et révélation du nombre
T09 — Fermeture et relancement du script
Historique conservé
T10 — Consultation des classements
Tri et affichage corrects
T11 — Recherche d'un joueur inconnu
Message adapté
T12 — Plusieurs parties successives
Historique ajouté, sans écrasement
 
12. Enrichissements possibles
Les fonctionnalités suivantes ne sont pas obligatoires. Elles permettront aux stagiaires les plus avancés d'approfondir le projet.
1. Indices intelligents
Après plusieurs tentatives infructueuses, proposer un indice : nombre pair ou impair, divisible par 5, ou distance approximative avec le nombre secret.
Facile
2. Mode « Chaud / Froid »
Indiquer si une proposition se rapproche ou s'éloigne du nombre secret par rapport à la précédente.
Intermédiaire
3. Mode contre-la-montre
Mesurer le temps de résolution avec Measure-Command ou [System.Diagnostics.Stopwatch] et attribuer un bonus de rapidité.
 