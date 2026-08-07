---
layout: page
title: RPZeG — Planificateur de Voyage Gamifié & Optimiseur de Route
description: Le compagnon de voyage ultime gamifié et hors-ligne, propulsé par l'optimisation mathématique MILP.
img: assets/img/rpzeg_cover.png
lang: fr
importance: 1
category: cool
---

> 🚀 **Application Web en Direct** : [rpg.jeduapf.com](https://rpg.jeduapf.com) — *Gratuit, 100% hors-ligne, sans aucune installation !*

---

## 🌟 Pimentez vos Explorations avec RPZeG !

Fini les itinéraires de voyage statiques et ennuyeux. **RPZeG** est le compagnon de voyage révolutionnaire qui transforme chaque vacances, week-end ou journée d'exploration en un **deck de quêtes RPG interactif** !

Que vous exploriez une nouvelle métropole ou cherchiez les meilleurs spots culinaires, RPZeG calcule en quelques secondes le parcours idéal grâce à l'optimisation mathématique et vous permet de vivre votre voyage comme un héros en quête d'XP.

---

## ⚡ Les Points Forts de RPZeG

- 🎮 **Deck de Quêtes RPG** : Transformez vos étapes en objectifs principaux et quêtes secondaires avec points d'XP, contraintes de temps et budget.
- 📐 **Optimisation Mathématique de Pointe** : Résolution algorithmique poussée (Recherche Opérationnelle) pour maximiser les gains d'XP tout en respectant vos horaires de repas et durées de visite.
- 📶 **Exportation Autonome 100% Hors-Ligne** : Génération d'un fichier HTML unique sans aucune dépendance, incluant cartes Leaflet et moteur d'état offline. Fonctionne partout sans connexion !
- 🎨 **Studio de Style Personnalisé** : Personnalisez vos cartes avec des polices manuscrites, des fonds de carte (Satellite, CartoDB, Terrain) et des marqueurs illustrés.
- 📡 **Suivi GPS en Temps Réel** : Rechargez votre fichier HTML en ligne pour suivre votre position satellite GPS sur mobile pendant la réalisation de vos quêtes.

---

## 🧪 Formulation Mathématique & Technique

Derrière son interface ludique, RPZeG résout un **Problème du Voyageur de Commerce avec Fenêtres Temporelles (TSPTW)** couplé à un **Problème du Sac à Dos (Knapsack)** :

$$
\max \sum_{i \in Q} x_i \cdot \text{XP}_i - \lambda \sum_{i, j} d_{ij} \cdot y_{ij}
$$

**Contraintes mathématiques :**
1. **Budget Temporel** : $$\sum_{i \in Q} t_{\text{visite}, i} + \sum_{i,j} t_{\text{trajet}, ij} \cdot y_{ij} \le T_{\max}$$
2. **Budget Financier** : $$\sum_{i \in Q} c_i \cdot x_i \le C_{\max}$$
3. **Fenêtres Repas** : Arrivée $$A_m \in [\text{Début}_m, \text{Fin}_m]$$ pour chaque quête repas.
4. **Élimination de Sous-Tours** : Formulation MTZ garantissant un circuit connexe sans sous-boucles.

Propulsé par **Google OR-Tools** (moteur MILP / CP), **FastAPI** et le solveur **PuLP**.

---

👉 **Prêt pour l'aventure ? Essayez RPZeG gratuitement sur [rpg.jeduapf.com](https://rpg.jeduapf.com) !**

---

`#GameFi` `#Gamefy` `#GamifiedTravel` `#TravelPlanner` `#OfflineTravelApp` `#OfflinePlanner` `#MILP` `#OperationsResearch` `#TSPTW` `#KnapsackProblem` `#ORTools` `#SmartRouteOptimizer`
