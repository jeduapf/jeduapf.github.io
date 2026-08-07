---
layout: page
title: RPZeG — Gamified Route & Quest Travel Planner
description: The ultimate offline-first, gamified travel planner powered by mathematical MILP route optimization.
img: assets/img/rpzeg_cover.png
lang: en
importance: 1
category: fun
---

> 🚀 **Live Web App**: [rpg.jeduapf.com](https://rpg.jeduapf.com) — *Free to use, 100% offline-first, zero installation needed!*

---

## 🌟 Level Up Your Exploration with RPZeG!

Say goodbye to static, boring travel itineraries. **RPZeG** is the revolutionary gamified travel companion that turns any vacation, weekend trip, or urban adventure into an **interactive RPG quest deck**!

Whether you are exploring a new city, hunting down hidden gems, or balancing sights with culinary stops, RPZeG calculates the mathematically optimal visiting schedule in seconds and lets you play through your trip like a hero completing quests.

---

## ⚡ What Makes RPZeG Powerful?

- 🎮 **Gamified RPG Quest Deck**: Convert locations into main objectives and side quests with custom XP points, time budgets, and budget costs.
- 📐 **Military-Grade Mathematical Optimization**: Solves complex route scheduling using Operations Research algorithms, optimizing XP gains while respecting time windows and meal breaks.
- 📶 **100% Offline Single-File HTML Export**: Generate a zero-dependency, self-contained HTML file with embedded Leaflet maps and PWA offline storage. It runs anywhere without internet!
- 🎨 **Custom Style Studio**: Customize your map experience with retro fonts (`Caveat`, `Pacifico`, `Fredoka`), satellite tile layers, and custom map markers (Kingdom, Sakura Blossom, Adventure).
- 📡 **Live GPS Tracking**: Re-import exported itineraries online to track your live position via satellite GPS while completing quests.

---

## 🧪 Technical & Mathematical Formulation

Behind the playful interface, RPZeG solves a **Constrained Travelling Salesperson Problem with Time Windows (TSPTW)** combined with a **Multi-Objective Knapsack Optimization**:

$$
\max \sum_{i \in Q} x_i \cdot \text{XP}_i - \lambda \sum_{i, j} d_{ij} \cdot y_{ij}
$$

**Subject to:**
1. **Total Time Budget**: $$\sum_{i \in Q} t_{\text{visit}, i} + \sum_{i,j} t_{\text{travel}, ij} \cdot y_{ij} \le T_{\max}$$
2. **Financial Budget**: $$\sum_{i \in Q} c_i \cdot x_i \le C_{\max}$$
3. **Meal Time Windows**: For meal quests $$m$$, arrival time $$A_m \in [\text{Earliest}_m, \text{Latest}_m]$$
4. **Subtour Elimination**: Miller-Tucker-Zemlin (MTZ) formulation guaranteeing a continuous non-looping itinerary.

Powered by **Google OR-Tools** (C++ MILP / CP Engine), **FastAPI**, and **PuLP**.

---

👉 **Ready for your next adventure? Try RPZeG live for free now at [rpg.jeduapf.com](https://rpg.jeduapf.com)!**

---

`#GameFi` `#Gamefy` `#GamifiedTravel` `#TravelPlanner` `#OfflineTravelApp` `#OfflinePlanner` `#MILP` `#OperationsResearch` `#TSPTW` `#KnapsackProblem` `#ORTools` `#SmartRouteOptimizer`
