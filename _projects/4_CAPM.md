---
layout: page
title: Modèle CAPM du Marché Parisien
description: Analyse de la frontière efficiente du marché français (2000–2025)
img: assets/img/CAPM_Paris.png
lang: fr
importance: 1
category: cool
---

## Introduction

Le projet **CAPM du Marché Parisien** étudie la relation entre le risque et le rendement des plus grandes entreprises cotées sur **Euronext Paris** entre **janvier 2000 et janvier 2025**, selon le **modèle d’évaluation des actifs financiers (CAPM)**.  
Développé par **José Eduardo Alves**, ce travail vise à reconstituer la **frontière efficiente** du marché à partir des rendements journaliers, en considérant un **taux sans risque de 3 %**.

Afin d’assurer la liquidité et la représentativité du portefeuille, seules les entreprises dont le **volume moyen d’échange** est supérieur à la **moyenne + un écart-type** du marché total ont été retenues.

---

## Méthodologie

L’analyse repose sur les hypothèses fondamentales du **CAPM** :

- **Période d’étude** : janvier 2000 – janvier 2025  
- **Fréquence** : journalière  
- **Taux sans risque (Rf)** : 3 % par an  
- **Univers** : actions cotées sur **Euronext Paris**  
- **Critère de sélection** : volumes > moyenne + 1 écart-type  
- **Optimisation** : minimisation de la variance pour un rendement cible donné  
- **Contraintes** : pondérations positives et somme unitaire des poids  

Les points de la **frontière efficiente** sont obtenus en résolvant, pour chaque niveau de volatilité, le portefeuille offrant le rendement maximal, conformément au modèle moyenne-variance de Markowitz.

### Modèle CAPM

Le **CAPM** relie le rendement attendu d’un actif à son risque systématique via la formule :

$$
E[R_i] = R_f + \beta_i \, (E[R_m] - R_f)
$$

où :  
- $E[R_i]$ : rendement attendu de l’action $i$  
- $R_f$ : taux sans risque  
- $E[R_m]$ : rendement attendu du marché  
- $\beta_i$ : sensibilité de l’actif $i$ au marché, calculée comme :

$$
\beta_i = \frac{\operatorname{Cov}(R_i, R_m)}{\operatorname{Var}(R_m)}
$$

Le **rendement excédentaire** d’un actif peut donc s’écrire :

$$
R_i - R_f = \beta_i (R_m - R_f) + \epsilon_i
$$

avec $\epsilon_i$ un terme d’erreur non systématique.

---

## CAC40

La figure ci-dessous illustre le **CAC40** du marché parisien, calculé sur la période **2000–2025** à partir des **rendements journaliers** :

<div class="row justify-content-center">
  <div class="col-12 col-lg-10 mt-3 text-center">
    {% include figure.html path="assets/img/CAC40.png" title="Évolution du CAC40 (2000–2025)" class="img-fluid rounded z-depth-1 w-100" %}
    <div class="figure-caption">Évolution du CAC40 (2000–2025) basée sur les rendements journaliers</div>
  </div>
</div>

---

## Frontière efficiente

La figure ci-dessous illustre la **frontière efficiente** du marché parisien, calculée sur la période 2000–2025 à partir des rendements journaliers :

<div class="row justify-content-center">
  <div class="col-12 col-lg-10 mt-3 text-center">
    {% include figure.html path="assets/img/CAPM_Paris.png" title="Frontière efficiente du marché parisien (2000–2025)" class="img-fluid rounded z-depth-1 w-100" %}
    <div class="figure-caption">Frontière efficiente du marché parisien (2000–2025)</div>
  </div>
</div>

---

### Données de la frontière

| **Rendement** | 0.002643 | 0.005480 | 0.008317 | 0.011153 | 0.013990 | 0.016827 | 0.019663 | 0.022500 | 0.025337 | 0.028174 | … | 0.116112 | 0.118949 |
|----------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|---|-----------|-----------|
| **Volatilité** | 0.187905 | 0.187108 | 0.186377 | 0.185726 | 0.185136 | 0.184626 | 0.184171 | 0.183778 | 0.183444 | 0.183170 | … | 0.260928 | 0.283468 |

---

### Composition des portefeuilles

Les portefeuilles situés le long de la frontière présentent une évolution progressive :  
les stratégies prudentes privilégient des valeurs défensives (Sanofi, Danone, Vinci),  
tandis que les portefeuilles à haut rendement se concentrent sur des titres cycliques et industriels (Vinci, Schneider Electric).

| **Symbole** | 0.0026 | 0.0055 | 0.0083 | 0.0112 | 0.0140 | 0.0168 | … | 0.1161 | 0.1189 |
|-------------|--------|--------|--------|--------|--------|--------|---|--------|--------|
| **VIV.PA (Vivendi)** | 1.631 | 1.514 | 1.500 | 1.252 | 1.315 | 1.535 | … | 0.000 | 0.000 |
| **ORA.PA (Orange)** | 10.963 | 10.477 | 10.122 | 9.634 | 9.288 | 8.625 | … | 0.000 | 0.000 |
| **ML.PA (Michelin)** | 0.110 | 0.487 | 0.756 | 1.232 | 1.663 | 2.080 | … | 0.000 | 0.000 |
| **SAN.PA (Sanofi)** | 15.611 | 15.689 | 16.265 | 16.982 | 17.262 | 17.597 | … | 0.000 | 0.000 |
| **CA.PA (Crédit Agricole)** | 13.115 | 12.577 | 11.577 | 11.067 | 10.365 | 9.663 | … | 0.000 | 0.000 |
| **DSY.PA (Dassault Systèmes)** | 7.565 | 8.068 | 8.247 | 8.594 | 8.582 | 8.896 | … | 3.164 | 0.000 |
| **BN.PA (Danone)** | 36.551 | 37.194 | 37.592 | 37.305 | 38.245 | 38.282 | … | 0.000 | 0.000 |
| **DG.PA (Vinci)** | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 | 0.351 | … | 66.430 | 100.000 |
| **SU.PA (Schneider Electric)** | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 | 0.000 | … | 30.406 | 0.000 |

---

## Interprétation économique

Les résultats confirment la **validité empirique du CAPM** sur le marché français :

- Le rendement croît avec la volatilité, suivant la pente définie par le **taux sans risque (3 %) et la prime de marché**.  
- Les portefeuilles à faible risque sont dominés par **Sanofi**, **Danone** et **Vinci**.  
- Les portefeuilles à rendement élevé concentrent le risque sur des titres industriels tels que **Vinci** et **Schneider Electric**.  
- La transition le long de la frontière reflète la rotation sectorielle classique entre **défensif** et **cyclique**.

---

## Conclusion

L’étude met en lumière la stabilité du **marché parisien** et la cohérence de sa structure rendement-risque sur 25 ans.  
Le **modèle CAPM**, appliqué à un ensemble restreint d’entreprises liquides, reproduit une **frontière efficiente stable et économiquement interprétable**.

Les résultats démontrent que, même sur la base de données journalières, la **prime de risque** du marché français reste positive et qu’un **investisseur rationnel** peut optimiser son portefeuille le long de cette frontière selon son appétence au risque.

---

## Code source

L’intégralité du code Python utilisé pour la génération de la frontière efficiente est disponible ici :  
👉 [Voir le code sur Google Colab](https://colab.research.google.com/drive/12_D6r0LAcYi9bpXKJdYyxmCcEk9qtQUc?usp=sharing)
