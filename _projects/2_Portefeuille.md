---
layout: page
title: Décarbonisation du S&P500
description: Stratégies d’investissement à faibles émissions de carbone
img: assets/img/AT.png
lang: fr
importance: 3
category: travail
---

## Introduction

Le projet **Décarbonisation du S&P500** propose une approche innovante d’investissement durable, dérivée de l’indice S&P500.  
Développé par **José Eduardo Alves** et **Mathias Trochon**, ce travail vise à concevoir des portefeuilles réduisant l’intensité carbone tout en préservant la performance financière et l’exposition au marché.

L’objectif est de permettre aux investisseurs institutionnels d’aligner leurs portefeuilles sur les objectifs climatiques, sans compromettre la rentabilité à long terme.

---

## Stratégie d’investissement

Les stratégies proposées reposent sur trois piliers fondamentaux :

- **Réduction de l’intensité carbone** : entre 20 % et 80 % par rapport au S&P500.  
- **Performance ajustée au risque** : maintien ou amélioration du ratio de Sharpe moyen (≈ 0.7 ± 1.7).  
- **Contrôle de l’erreur de suivi (Tracking Error)** : inférieure à 5 % lorsque possible.

Quatre profils d’investissement ont été définis :

1. **Stratégie à faible déviation** – minimisation des écarts avec le S&P500 tout en réduisant modérément le carbone.  
2. **Stratégie à rendement élevé** – approche agressive acceptant plus de risque pour maximiser le retour.  
3. **Stratégie zéro carbone** – forte réduction de l’intensité carbone (~80 %) avec un rendement moindre.  
4. **Stratégie équilibrée** – compromis entre risque, rendement et environement.

---

## Analyse comparative des portefeuilles

Les performances des portefeuilles ont été testées sur **30 ans de données (1989–2019)** avec des mises à jour trimestrielles des poids optimaux.

<div class="row">
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/te_02.png" title="Erreur de suivi pour ξ = 0.2" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/te_05.png" title="Erreur de suivi pour ξ = 0.5" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="row">
  <div class="col-12 mt-3">
    {% include figure.html path="assets/img/te_08.png" title="Erreur de suivi pour ξ = 0.8" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 1 : Erreur de suivi (Tracking Error) pour différentes contraintes carbone.
</div>


---

### Rendements et volatilité

Les portefeuilles **Global Minimum Variance (GMV)** et **Tracking Error (TE)** affichent la plus faible volatilité annuelle.  
À l’inverse, la stratégie **Également pondérée (EW)** présente la variabilité la plus importante, notamment sous contrainte carbone stricte (ξ = 0.2).

<div class="row">
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/returns_vol_02.png" title="Rendement et volatilité (ξ = 0.2)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/returns_vol_05.png" title="Rendement et volatilité (ξ = 0.5)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="row">
  <div class="col-12 mt-3">
    {% include figure.html path="assets/img/returns_vol_08.png" title="Rendement et volatilité (ξ = 0.8)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 2 : Rendements et volatilités annualisés selon le niveau de contrainte carbone.
</div>


---

### Croissance cumulée

Une simulation d’investissement de **1 000 $** au 1er janvier 1989 montre que toutes les stratégies surpassent l’indice S&P500 à long terme, même sous fortes contraintes carbone.

<div class="row justify-content-center">
  <div class="col-12 col-lg-10 mt-3">
    {% include figure.html path="assets/img/Portifolios_cumulative.png" title="Croissance cumulée des portefeuilles" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 3 : Évolution d’un investissement de 1 000 $ (1989–2019).
</div>

---

### Ratios de Sharpe

Les ratios de Sharpe confirment la solidité des stratégies, avec des valeurs stables autour de 1 pour les portefeuilles **Risk Parity (RP)** et **Equally Weighted (EW)**.  
Une contrainte carbone plus faible (ξ = 0.8) tend à améliorer le ratio de Sharpe.

<div class="row">
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/sharpe_02.png" title="Sharpe (ξ = 0.2)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/sharpe_08.png" title="Sharpe (ξ = 0.8)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 4 : Ratios de Sharpe pour différentes contraintes carbone.
</div>

---

### Répartition sectorielle

Les portefeuilles sont naturellement diversifiés.  
Sous contrainte carbone stricte, les secteurs **Énergie** et **Services publics** deviennent quasi inexistants.  
La stratégie **Risk Parity** tend à équilibrer les secteurs, même sans contrainte d’égalisation imposée.

<div class="row">
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/sector_rp_02.png" title="Répartition sectorielle RP (ξ = 0.2)" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-12 col-md-6 mt-3">
    {% include figure.html path="assets/img/sector_de_08.png" title="Répartition sectorielle DE (ξ = 0.8)" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 5 : Composition sectorielle des portefeuilles selon le niveau de décarbonation.
</div>

---

## Choix des paramètres

| Stratégie | Type de portefeuille | Réduction CO₂ | Ratio de Sharpe | Erreur de suivi | Rendement attendu |
|------------|----------------------|----------------|-----------------|-----------------|-------------------|
| Faible déviation | RP | 20 % | 1.3 ± 1.7 | −0.7 ± 4.2 % | 11.8 ± 32.7 % |
| Haut rendement | DE | 20 % | 1.3 ± 2.3 | −2.7 ± 10.3 % | 19.9 ± 42.4 % |
| Zéro carbone | TE | 80 % | 1.6 ± 1.9 | −0.5 ± 6.0 % | 11.1 ± 28.1 % |
| Équilibrée | RP | 50 % | 1.3 ± 1.7 | −0.8 ± 4.4 % | 11.9 ± 34.0 % |

---

## Méthodologie

Les portefeuilles sont réoptimisés tous les **3 mois** à partir de fenêtres glissantes de **2 ans** sur des données hebdomadaires.  
Les hypothèses clés incluent :

- Données carbone (Scope 1 et 2) fixes basées sur 2019.  
- Données manquantes interpolées via spline de degré 2 (si < 5 % de trous).  
- Aucune prise en compte de frais de transaction.  
- Pondération constante du S&P500 sur toute la période.

Les fonctions d’optimisation couvrent plusieurs approches :  
**Variance minimale**, **Diversification maximale**, **Décorrélation maximale**, **Égal pondéré**, **Risk Parity**, et **Erreur de suivi minimale**.

---

## Code source

L’ensemble du code Python et les graphiques correspondants sont disponibles ici :  
👉 [Voir le code sur Google Drive](https://drive.google.com/file/d/1fU5SLwBES8iJTRw_UZ3iGKBhJjrMPNFA/view?usp=sharing)

---

<div class="caption">
Projet présenté dans le cadre du mastère OSE — Mines Paris – PSL, 2025.
</div>
