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

**TranspoZé** est un projet d’analyse énergétique visant à modéliser la consommation d’énergie des véhicules thermiques et éléctriques dans une optique de **décarbonation du transport routier**.  

Conçu dans le cadre de mon alternance chez EDF, le projet combine une approche **physique, mathématique et algorithmique** pour simuler les déplacements, estimer la consommation et analyser les leviers d’amélioration énergétique.

L’objectif est de proposer une méthode reproductible et claire permettant de **quantifier les émissions et la dépense énergétique** d’un véhicule en fonction de son profil de conduite, du relief et d'autres conditions du véhicules ou de la route.

---

## Modélisation physique

La consommation énergétique est estimée à partir de la relation :

$$
\frac{\delta E}{\delta s} = m \dot{v} + m g \mu_d \cos(\theta) + m g \sin(\theta) + \frac{1}{2} \rho_{ar} C_d A v^2 + \frac{P_{elim}}{v}
$$

où :

$$E$$ est l'énergie consommée

$$m$$ est la masse du véhicule

$$v$$ sa vitesse instantanée

$$\mu_d$$ le coefficient de frottement

$$\theta$$ l’inclinaison de la route 

$$\rho_{ar}$$  la densité de l’air

$$C_d$$ le coefficient aérodynamique

$$A$$ la surface frontale

$$P_{elim}$$ les puissances auxiliaires comme la climatisation par exemple

$$\frac{\delta E}{\delta s}$$ est la consommation d'énergie par unité de distance parcourue

---

## Données d’entrée

Le modèle repose sur des **données de trajet détaillées** récupérées de la base française [BD Topo](https://geoservices.ign.fr/bdtopo), comprenant :  

- le profil d’altitude,  
- les vitesses maximales par segment.  

L’altitude permet d’estimer la **densité de l’air**, tandis que les **vitesses maximales** sont **ajustées** pour estimer un **profil de vitesses** simulant une conduite réaliste.

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

## Estimation de la Vitesse

Le profil de vitesse réel est estimé à partir des **vitesses maximales réglementaires** (`V_max`) de chaque segment routier, en appliquant un **coefficient d'ajustement** $$\alpha$$ dépendant du type de route et des styles de conduite de la région en question (la France).

### Modèle polynomial d'ajustement

Le coefficient $$\alpha$$ est calculé par un modèle polynomial calibré empiriquement :

$$
\alpha(V_{\text{max}}) = 9.27 \times 10^{-6} V_{\text{max}}^4 - 7.37 \times 10^{-4} V_{\text{max}}^3 + 0.0225 V_{\text{max}}^2 - 0.314 V_{\text{max}} + 2.34
$$

avec $$\alpha$$ plafonné à 0.98 pour garantir que la vitesse réelle reste inférieure à la limite réglementaire.

La vitesse réelle "instantanée" est alors calculée en tout point $$s$$ de la route en fonction du profil de vitesse maximale récupéré par la base BD Topo:

$$
v_{\text{réelle}}(s) = \alpha \times V_{\text{max}}(s)
$$

<!-- ESPACE RÉSERVÉ POUR IMAGE DU PROFIL DE VITESSE -->

### Contraintes d'accélération

L'accélération maximale est limitée par le minimum entre :
- La **capacité moteur** : $$a_{\text{moteur}} = \frac{1000 P_{\text{moteur}} \eta_{\text{mot}}}{V_{\text{max}} m}$$
- Le **frottement statique** : $$a_{\text{friction}} = g \mu_s \cos(\theta)$$

où $$P_moteur$$ est la puissance du moteur (kW), $$\eta_{mot}$$ l'efficacité de transmission du moteur, et $$\mu_s ≈ 0.9$$ le coefficient de frottement statique.

---

<!-- ESPACE RÉSERVÉ POUR IMAGE DU PROFIL DE VITESSE -->

## Propagation des Incertitudes

La **propagation des incertitudes** permet de quantifier la **fiabilité** de l'estimation énergétique. Les incertitudes sur les paramètres d'entrée se propagent par dérivées partielles selon l'hypothèse de **linéarité** et d'**indépendance** des variables.

### Sources d'incertitude

Les incertitudes relatives réalistes pour chaque paramètre sont :

| Paramètre | Incertitude | Exemples |
|-----------|-------------|---------------|
| Masse $$m$$ | **±20%** | Variation de 1 à 5 passagers dans un véhicule d'environ 1 tonne |
| Coefficient de frottement $$\mu_d$$ | **±10%** | Variabilité due aux différents revêtements (sec, mouillé, etc.) |
| Vitesse $$v$$ | **±20%** | Imprécision du modèle de vitesse estimée |
| Densité de l'air $$\rho_{ar}$$ | **±5%** | Estimée par altitude GPS ; affectée par l'humidité et autres facteurs météo |
| Coefficient aérodynamique $$C_d$$ | **±0.5%** | Valeur bien connue pour les véhicules standards |
| Surface frontale $$A$$ | **±0.5%** | Spécification constructeur généralement précise |
| Inclinaison $$\theta$$ | **±20%** | **Incertitude majeure** avec la masse ; difficile à mesurer sans instruments embarqués ; estimée par `arctan(Δh/Δd)` à partir des coordonnées GPS |

### Formule de propagation

La variance de l'énergie totale est calculée par :

$$
\sigma_E^2 = \sum_{i} \left( \frac{\partial E}{\partial x_i} \sigma_{x_i} \right)^2
$$

où $$\partial E/\partial x_i$$ représente la dérivée partielle de l'énergie par rapport au paramètre $$x_i$$, et $$\sigma_{x_i}$$ son incertitude.

Pour l'équation énergétique complète, les principales dérivées partielles sont :

- **Masse** : $$\partial E/\partial m = (g sin(θ) + g μ_d cos(θ)) Δs$$
- **Inclinaison** : $$\partial E/\partial θ = m g (cos(θ) - μ_d sin(θ)) Δs$$
- **Vitesse** : $$\partial E/\partial v = (ρ_ar C_d A v - P_elim/v²) Δs$$

L'incertitude totale $$\sigma_E$$ sur l'énergie consommée s'exprime en **joules** ou **kWh**, permettant de définir des **marges d'erreur** pour chaque simulation.

---

## Intervalles de Confiance

Grâce au **Théorème Central Limite (TCL)**, la somme des consommations énergétiques sur l'ensemble des segments du trajet converge vers une **distribution gaussienne**, même si les incertitudes individuelles ne suivent pas une loi normale.

### Intervalle de confiance à 95%

L'intervalle de confiance à 95% pour l'estimation énergétique est :

$$
\text{IC}_{95\%} = \mu \pm 1.96 \sigma
$$

Cela signifie qu'il y a **95% de chances** que la consommation réelle se situe dans cet intervalle.

### Visualisation du TCL

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/clt_simulation_edf.gif" title="Simulation du Théorème Central Limite" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption">
    Figure 3 : Illustration du Théorème Central Limite. La somme de nombreuses mesures indépendantes converge vers une distribution gaussienne.
</div>

Cette approche probabiliste renforce la **robustesse** du modèle et permet de fournir des **estimations quantifiées** avec leurs marges d'incertitude.

---


## Résultats et analyse

Les simulations montrent une **forte sensibilité de la consommation à la topographie et au style de conduite**. 

Une accélération douce et un maintien de vitesse stable permettent de réduire la consommation jusqu’à **25 %** sur certains trajets vallonnés.  

Les routes présentant des pentes supérieures à **5 %** entraînent une hausse exponentielle de la demande énergétique, confirmant le rôle majeur du relief dans les bilans carbone des transports.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html 
       path="assets/img/transpoze_energy.png" 
       title="Comparaison énergétique selon le relief et vitesse" 
       class="img-fluid rounded z-depth-1" 
    %}
  </div>
</div>
<div class="caption">
    Figure 4 : Analyse de la consommation énergétique selon différents paramètres.
</div>


---
<div class="caption">
Projet TranspoZé — Mastère OSE, Mines Paris – PSL, 2025. Réalisé dans le cadre de mon alternance chez EDF.
</div>
