---
layout: page
title: TranspoZé
description: Optimisation énergétique pour une mobilité décarbonée
img: assets/img/transpoze_cover.png
lang: fr
importance: 2
category: travail
---

## Introduction

**TranspoZé** est un projet d’ingénierie et d’analyse énergétique visant à modéliser et optimiser la consommation d’énergie des véhicules thermiques dans une optique de **décarbonation du transport routier**.  
Conçu dans le cadre du mastère **OSE — Mines Paris – PSL**, le projet combine une approche **physique, mathématique et algorithmique** pour simuler les déplacements, estimer la consommation et analyser les leviers d’amélioration énergétique.

L’objectif est de proposer une méthode reproductible permettant de **quantifier les émissions et la dépense énergétique** d’un véhicule en fonction de son profil de conduite, du relief, et des conditions environnementales.

---

## Modélisation physique

La consommation énergétique est estimée à partir de la relation :

$$
\frac{\delta E}{\delta s} = m \dot{v} + m g \mu_d \cos(\theta) + m g \sin(\theta) + \frac{1}{2} \rho_{ar} C_d A v^2 + \frac{P_{elim}}{v}
$$

où :
- \(m\) est la masse du véhicule,  
- \(v\) sa vitesse instantanée,  
- \(\mu_d\) le coefficient de frottement,  
- \(\theta\) l’inclinaison de la route,  
- \(\rho_{ar}\) la densité de l’air (fonction de l’altitude),  
- \(C_d\) le coefficient aérodynamique,  
- \(A\) la surface frontale,  
- et \(P_{elim}\) la puissance perdue (ex. accessoires, frottements internes).
---

## Données d’entrée

Le modèle repose sur des **données de trajet détaillées** comprenant :
- le profil d’altitude,  
- les vitesses maximales par segment,  
- les coefficients de frottement,  
- et les arrêts complets (feux, intersections, etc.).

L’altitude permet d’estimer la **densité de l’air**, tandis que le **profil de vitesse** est ajusté par un **régulateur PI** simulant une conduite réaliste.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_map.png" title="Profil de route et altitudes" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_speed.png" title="Profil de vitesse simulé" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 2 : Exemples de profils d’entrée utilisés dans les simulations.
</div>

---

## Résultats et analyse

Les simulations montrent une **forte sensibilité de la consommation à la topographie et au style de conduite**.  
Une accélération douce et un maintien de vitesse stable permettent de réduire la consommation jusqu’à **25 %** sur certains trajets vallonnés.  
Les routes présentant des pentes supérieures à **5 %** entraînent une hausse exponentielle de la demande énergétique, confirmant le rôle majeur du relief dans les bilans carbone des transports.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_energy.png" title="Comparaison énergétique selon le relief" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_energy.png" title="Consommation selon le style de conduite" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 4 : Analyse de la consommation énergétique selon différents paramètres.
</div>


---
<div class="caption">
Projet TranspoZé — Mastère OSE, Mines Paris – PSL, 2025.
</div>
