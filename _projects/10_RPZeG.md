---
layout: page
title: RPZeG
description: Planificateur d'itinéraire gamifié et optimiseur de parcours basé sur les algorithmes TSPTW et Sac à dos.
img: assets/img/rpzeg_cover.png
lang: fr
importance: 1
category: cool
---

> **Démonstration en direct** : [rpg.jeduapf.com](https://rpg.jeduapf.com)  
> **Code Source** : [github.com/jeduapf/RPZeG](https://github.com/jeduapf/RPZeG)

---

## Présentation

**RPZeG** est un compagnon de voyage gamifié et offline-first qui transforme n'importe quel itinéraire ou journée d'exploration en un deck de quêtes RPG interactif. 

Les voyageurs peuvent définir des objectifs principaux, des quêtes secondaires, un budget maximal et des créneaux horaires pour les repas. En un clic, RPZeG calcule le parcours optimal grâce à un algorithme d'optimisation mathématique et génère un fichier HTML autonome 100% hors ligne.

---

## 🧪 Formulation Mathématique & Technique

RPZeG modélise la planification d'itinéraire sous la forme d'un **Problème du Voyageur de Commerce avec Fenêtres Temporelles (TSPTW)** couplé à un **Problème du Sac à Dos (Knapsack)** :

$$
\max \sum_{i \in Q} x_i \cdot \text{XP}_i - \lambda \sum_{i, j} d_{ij} \cdot y_{ij}
$$

**Contraintes mathématiques :**
1. **Budget Temporel** : $$\sum_{i \in Q} t_{\text{visite}, i} + \sum_{i,j} t_{\text{trajet}, ij} \cdot y_{ij} \le T_{\max}$$
2. **Budget Financier** : $$\sum_{i \in Q} c_i \cdot x_i \le C_{\max}$$
3. **Fenêtres Repas** : Arrivée $$A_m \in [\text{Début}_m, \text{Fin}_m]$$ pour chaque quête repas.
4. **Élimination de Sous-Tours** : Formulation MTZ pour garantir un parcours connexe sans boucles isolées.

Le moteur d'optimisation utilise **Google OR-Tools** (moteur MILP / Programmation par Contraintes) propulsé par une API **FastAPI** et un solveur de référence **PuLP**.

---

## Fonctionnalités Clés

- 🎮 **Deck de Quêtes RPG** : Définissez l'XP, la durée, les coûts et attribuez des fonds d'écran par catégorie.
- 🎨 **Studio de Style Personnalisé** : Polices Google manuscrites (`Caveat`, `Pacifico`, `Fredoka`), couches de carte OpenStreetMap (CartoDB, Satellite, Terrain) et marqueurs kawaï (Royaume, Cerisier en fleurs, Aventure).
- 📶 **Exportation HTML Autonome 100% Hors Ligne** : Carte Leaflet intégrée, manifest PWA et moteur d'état complet dans un fichier HTML unique.
- 📡 **Suivi GPS Temps Réel (HTTPS / PWA)** : Réimportez votre fichier HTML en ligne pour suivre votre position GPS en temps réel sur mobile.

---

👉 **Essayez RPZeG gratuitement dès maintenant sur [rpg.jeduapf.com](https://rpg.jeduapf.com) !**
