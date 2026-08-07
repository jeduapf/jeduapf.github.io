---
layout: page
title: RPZeG
description: Gamified travel itinerary builder and smart route optimizer using TSPTW & Knapsack algorithms.
img: assets/img/rpzeg_cover.png
lang: en
importance: 1
category: fun
---

> **Live Demo**: [rpg.jeduapf.com](https://rpg.jeduapf.com)  
> **Source Code**: [github.com/jeduapf/RPZeG](https://github.com/jeduapf/RPZeG)

---

## Overview

**RPZeG** is an offline-first, gamified travel companion that turns any trip or daily exploration into an interactive RPG quest deck. 

Travelers can define main objectives, side quests, budget constraints, and preferred dining time windows. With a single click, RPZeG solves the optimal visiting sequence using mathematical optimization algorithms and exports a zero-dependency standalone HTML file that works 100% offline on any mobile device.

---

## 🧪 Technical & Mathematical Formulation

Under the hood, RPZeG formulates route generation as a **Constrained Travelling Salesperson Problem with Time Windows (TSPTW)** combined with a **Knapsack Problem**:

$$
\max \sum_{i \in Q} x_i \cdot \text{XP}_i - \lambda \sum_{i, j} d_{ij} \cdot y_{ij}
$$

**Constraints:**
1. **Time Budget**: $$\sum_{i \in Q} t_{\text{visit}, i} + \sum_{i,j} t_{\text{travel}, ij} \cdot y_{ij} \le T_{\max}$$
2. **Financial Budget**: $$\sum_{i \in Q} c_i \cdot x_i \le C_{\max}$$
3. **Meal Time Windows**: For meal quests $$m$$, arrival time $$A_m \in [\text{Earliest}_m, \text{Latest}_m]$$
4. **Subtour Elimination**: Miller-Tucker-Zemlin (MTZ) formulation preventing disconnected loops.

The optimization gateway leverages **Google OR-Tools** (C++ MILP / Constraint Programming engine) backed by **FastAPI** and **PuLP** reference solvers.

---

## Key Features

- 🎮 **Gamified Quest Deck**: Assign custom XP weights, budget costs, and category wallpapers.
- 🎨 **Custom Style Studio**: Personalized Google Latin fonts (`Caveat`, `Pacifico`, `Fredoka`), custom map tile layers (CartoDB, Satellite, Terrain), and cute map marker icons (Kingdom, Sakura Blossom, Travel Adventure).
- 📶 **100% Offline Single-File HTML Export**: Embedded Leaflet map, PWA manifest, and offline state engine in a single downloadable HTML file.
- 📡 **HTTPS & PWA Live GPS**: Re-import exported HTML files online to track your real-time satellite GPS coordinates.

---

👉 **Try RPZeG for free right now at [rpg.jeduapf.com](https://rpg.jeduapf.com)!**
