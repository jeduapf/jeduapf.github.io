---
layout: page
title: RPZeG
description: Criador de itinerários de viagem gamificado e otimizador de rotas baseado nos algoritmos TSPTW e Mochila.
img: assets/img/rpzeg_cover.png
lang: pt
importance: 1
category: diversão
---

> **Demonstração ao Vivo**: [rpg.jeduapf.com](https://rpg.jeduapf.com)  
> **Código Fonte**: [github.com/jeduapf/RPZeG](https://github.com/jeduapf/RPZeG)

---

## Apresentação

O **RPZeG** é um acompanhante de viagem gamificado offline-first que transforma qualquer itinerário em um baralho de missões RPG interativo. 

Os viajantes podem definir missões principais, secundárias, limites de orçamento e janelas de horário de refeição. Com apenas um clique, o RPZeG resolve a sequência ideal de visitas usando algoritmos de otimização matemática e exporta um arquivo HTML autônomo sem dependências que funciona 100% offline em qualquer dispositivo móvel.

---

## 🧪 Formulação Técnica e Matemática

O RPZeG modela a geração de rotas como um **Problema do Caixeiro Viajante com Janelas de Tempo (TSPTW)** combinado com o **Problema da Mochila (Knapsack)**:

$$
\max \sum_{i \in Q} x_i \cdot \text{XP}_i - \lambda \sum_{i, j} d_{ij} \cdot y_{ij}
$$

**Restrições:**
1. **Orçamento de Tempo**: $$\sum_{i \in Q} t_{\text{visita}, i} + \sum_{i,j} t_{\text{trajeto}, ij} \cdot y_{ij} \le T_{\max}$$
2. **Orçamento Financeiro**: $$\sum_{i \in Q} c_i \cdot x_i \le C_{\max}$$
3. **Janelas de Refeição**: Chegada $$A_m \in [\text{Início}_m, \text{Fim}_m]$$ para cada missão de refeição.
4. **Eliminação de Subtours**: Formulação Miller-Tucker-Zemlin (MTZ) para garantir uma rota contínua sem ciclos isolados.

O motor de otimização utiliza o **Google OR-Tools** (motor C++ de Programação Linear Inteira Mista / Programação por Restrições) com gateway **FastAPI** e resolvedor **PuLP**.

---

## Principais Destaques

- 🎮 **Baralho de Missões RPG**: Atribua XP, custos, duração e papéis de parede por categoria.
- 🎨 **Estúdio de Estilo Personalizado**: Fontes manuscritas do Google (`Caveat`, `Pacifico`, `Fredoka`), temas de mapa OpenStreetMap (CartoDB, Satélite, Terreno) e marcadores fofos (Reino, Flores de Cerejeira, Aventura).
- 📶 **Exportação HTML Autônoma 100% Offline**: Mapa Leaflet integrado, manifesto PWA e motor de estado em um único arquivo HTML baixável.
- 📡 **GPS ao Vivo via HTTPS / PWA**: Reimporte o arquivo HTML no app online para rastrear sua posição GPS via satélite em tempo real no celular.

---

👉 **Experimente o RPZeG gratuitamente agora mesmo em [rpg.jeduapf.com](https://rpg.jeduapf.com)!**
