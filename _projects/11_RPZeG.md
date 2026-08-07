---
layout: page
title: RPZeG — Planejador de Viagens Gamificado e Otimizador de Rotas
description: O melhor planejador de viagens gamificado e offline-first, impulsionado por otimização matemática MILP.
img: assets/img/rpzeg_cover.png
lang: pt
importance: 1
category: diversão
---

> 🚀 **Aplicativo Web ao Vivo**: [rpg.jeduapf.com](https://rpg.jeduapf.com) — *Gratuito, 100% offline-first, sem necessidade de instalação!*

---

## 🌟 Eleve suas Viagens ao Próximo Nível com o RPZeG!

Diga adeus aos roteiros de viagem estáticos e sem graça. O **RPZeG** é o revolucionário aplicativo de viagens gamificado que transforma qualquer férias, viagem de fim de semana ou passeio urbano em um **baralho de missões RPG interativo**!

Seja explorando uma nova cidade ou organizando pontos turísticos e paradas para refeição, o RPZeG calcula a sequência de visitas matematicamente perfeita em segundos, permitindo que você aproveite a viagem como um herói completando missões.

---

## ⚡ Por que escolher o RPZeG?

- 🎮 **Baralho de Missões RPG**: Transforme locais em objetivos principais e missões secundárias com pontos de XP, limites de tempo e custos orçamentários.
- 📐 **Otimização Matemática de Alta Performance**: Algoritmos de Pesquisa Operacional para maximizar os pontos de XP respeitando janelas de horário e paradas de refeição.
- 📶 **Exportação HTML 100% Offline**: Gere um arquivo HTML autônomo e leve com mapas Leaflet integrados e armazenamento offline PWA. Funciona em qualquer lugar sem internet!
- 🎨 **Estúdio de Estilo Personalizado**: Estilize seus mapas com fontes manuscritas, camadas de mapa (Satélite, Terreno, CartoDB) e marcadores temáticos.
- 📡 **Rastreamento GPS ao Vivo**: Reimporte o arquivo HTML no app online para acompanhar sua localização via GPS por satélite enquanto completa suas missões.

---

## 🧪 Formulação Técnica e Matemática

Por trás da interface divertida, o RPZeG resolve um **Problema do Caixeiro Viajante com Janelas de Tempo (TSPTW)** combinado com o **Problema da Mochila (Knapsack)**:

$$
\max \sum_{i \in Q} x_i \cdot \text{XP}_i - \lambda \sum_{i, j} d_{ij} \cdot y_{ij}
$$

**Restrições:**
1. **Orçamento de Tempo**: $$\sum_{i \in Q} t_{\text{visita}, i} + \sum_{i,j} t_{\text{trajeto}, ij} \cdot y_{ij} \le T_{\max}$$
2. **Orçamento Financeiro**: $$\sum_{i \in Q} c_i \cdot x_i \le C_{\max}$$
3. **Janelas de Refeição**: Chegada $$A_m \in [\text{Início}_m, \text{Fim}_m]$$ para cada missão de refeição.
4. **Eliminação de Subtours**: Formulação Miller-Tucker-Zemlin (MTZ) para garantir um itinerário contínuo e sem ciclos isolados.

Desenvolvido com **Google OR-Tools** (motor C++ MILP / CP), **FastAPI** e **PuLP**.

---

👉 **Pronto para a sua próxima aventura? Experimente o RPZeG gratuitamente em [rpg.jeduapf.com](https://rpg.jeduapf.com)!**

---

`#GameFi` `#Gamefy` `#GamifiedTravel` `#TravelPlanner` `#OfflineTravelApp` `#OfflinePlanner` `#MILP` `#OperationsResearch` `#TSPTW` `#KnapsackProblem` `#ORTools` `#SmartRouteOptimizer`
