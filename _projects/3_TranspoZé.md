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

Le modèle repose sur des **données de trajet détaillées** qui contiennent les points de latitude et de longitude du trajet original enrichies par la base française [BD Topo](https://geoservices.ign.fr/bdtopo). Ces points sont enrichis avec les informations suivantes :  

- le profil d’altitude,  
- les vitesses maximales par segment.  

L’altitude permet d’estimer la **densité de l’air** et la **pente** de la route, tandis que les **vitesses maximales** sont "ajustées" pour estimer un **profil de vitesses** simulant une conduite réaliste.

À la fin, une liste de points de latitude, longitude, altitude et vitesse maximale seront entrés dans le modèle physique pour estimer la consommation d'énergie entre chaque deux points consécutifs.

Le trajet peut être visualisé sur la carte de la [Figure 2](#figure-2-carte-du-trajet) et le profil de vitesses maximales ainsi que les altitudes récupérées de la base BD Topo sont montrés sur la [Figure 3](#figure-3-vitesses-et-altitudes).

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_map.png" title="Profil de route et altitudes" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption" id="figure-2-carte-du-trajet">
    Figure 2 : Exemple d'une carte contenant le trajet défini par l'utilisateur.
</div>

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_altitude.png" title="Profil de route et altitudes" class="img-fluid rounded z-depth-1" %}
  </div>
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_speed.png" title="Profil de vitesse simulé" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption" id="figure-3-vitesses-et-altitudes">
    Figure 3 : Exemples des vitesses maximales courbe en rouge seulement et des altitudes récupérées de la base BD Topo pour un des trajets de la Figure 2.
</div>


---

## Estimation de la Vitesse

Le profil de vitesse réel est estimé à partir des **vitesses maximales réglementaires** ($$V_{max}$$) de chaque segment routier, en appliquant un **coefficient d'ajustement** $$\alpha$$ dépendant du type de route et des styles de conduite de la région en question (la France).

### Modèle polynomial d'ajustement

Comme première approche, le coefficient $$\alpha$$ est calculé par un modèle polynomial calibré empiriquement sur des données réelles mesurées sur la route :

$$
\alpha(V_{\text{max}}) = 9.27 \times 10^{-6} V_{\text{max}}^4 - 7.37 \times 10^{-4} V_{\text{max}}^3 + 0.0225 V_{\text{max}}^2 - 0.314 V_{\text{max}} + 2.34
$$

avec $$\alpha$$ plafonné à 0.98 pour garantir que la vitesse réelle reste inférieure à la limite réglementaire.

La vitesse réelle "instantanée" est alors calculée en tout point $$s$$ de la route en fonction du profil de vitesse maximale récupéré par la base BD Topo ([Figure 4](#figure-4-coefficient-ajustement)):

$$
v_{\text{réelle}}(s) = \alpha \times V_{\text{max}}(s)
$$

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_alpha.png" title="Détermination du coefficient d'ajustement" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption" id="figure-4-coefficient-ajustement">
    Figure 4 : Détermination du coefficient d'ajustement $$\alpha$$.
</div>

### Contraintes d'accélération

L'accélération maximale est limitée par le minimum entre :
- La **capacité moteur** : $$a_{\text{moteur}} = \frac{1000 P_{\text{moteur}} \eta_{\text{mot}}}{V_{\text{max}} m}$$
- Le **frottement statique** : $$a_{\text{friction}} = g \mu_s \cos(\theta)$$

où $$P_{\text{moteur}}$$ est la puissance du moteur (kW), $$\eta_{\text{mot}}$$ l'efficacité de transmission du moteur, et $$\mu_s ≈ 0.9$$ le coefficient de frottement statique.

La [Figure 5](#figure-5-profil-vitesse-reelle) montre le résultat final du profil de vitesse réelle.


<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_final_speed.png" title="Détermination du profil de vitesse réelle $$v_{\text{réelle}}(s)$$ a partir du profil de vitesse maximale $$V_{\text{max}}(s)$$ et du coefficient d'ajustement $$\alpha$$." class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption" id="figure-5-profil-vitesse-reelle">
    Figure 5 : Détermination du profil de vitesse réelle $$v_{\text{réelle}}(s)$$ à partir du profil de vitesse maximale $$V_{\text{max}}(s)$$ et du coefficient d'ajustement $$\alpha$$.
</div>


---

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
- **Vitesse** : $$\partial E/\partial v = (ρ_{ar} C_d A v - P_{elim}/v²) Δs$$

L'incertitude totale $$\sigma_E$$ sur l'énergie consommée s'exprime en **joules** ou **kWh**, permettant de définir des **marges d'erreur** pour chaque simulation.

---

## Intervalles de Confiance

Grâce au **Théorème Central Limite (TCL)**, la somme des consommations énergétiques sur l'ensemble des segments du trajet converge vers une **distribution gaussienne**, même si les incertitudes individuelles ne suivent pas une loi normale.

### Intervalle de confiance à 95%

L'intervalle de confiance à 95% pour l'estimation énergétique est :

$$
\text{IC}_{95\%} = \mu \pm 1.96 \sigma
$$

Cela signifie qu'il y a **95 % de chances** que la consommation réelle se situe dans cet intervalle.

### Visualisation du TCL

La [Figure 6](#figure-6-theoreme-central-limite) illustre ce principe à travers une simulation.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html path="assets/img/transpoze_clt.gif" title="Simulation du Théorème Central Limite" class="img-fluid rounded z-depth-1" %}
  </div>
</div>
<div class="caption" id="figure-6-theoreme-central-limite">
    Figure 6 : Illustration du Théorème Central Limite. La somme de nombreuses mesures indépendantes converge vers une distribution gaussienne.
</div>

Cette approche probabiliste renforce la **robustesse** du modèle et permet de fournir des **estimations quantifiées** avec leurs marges d'incertitude.

---


## Résultats et analyse

Les simulations montrent une **forte sensibilité de la consommation à la topographie et au style de conduite**. 

Une accélération douce et un maintien de vitesse stable permettent de réduire la consommation jusqu’à **25 %** sur certains trajets vallonnés.  

Les routes présentant des pentes supérieures à **5 %** entraînent une hausse exponentielle de la demande énergétique, confirmant le rôle majeur du relief dans les bilans carbone des transports.

Ci-dessous, la [Figure 7](#figure-7-dashboard-resultats) présente le dashboard de visualisation des résultats qui permet de comparer les différentes pertes énergétiques (accélération, vent, frottement, etc.) sur un trajet donné, ainsi que l'incertitude finale sur la consommation totale. La [Figure 8](#figure-8-analyse-consommation) montre une analyse détaillée de la consommation énergétique selon différents paramètres.

<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html 
       path="assets/img/transpoze_dashboard.png" 
       title="Dashboard de visualisation des résultats" 
       class="img-fluid rounded z-depth-1" 
    %}
  </div>
</div>
<div class="caption" id="figure-7-dashboard-resultats">
    Figure 7 : Dashboard de visualisation des résultats condensés.
</div>



<div class="row">
  <div class="col-sm mt-3 mt-md-0">
    {% include figure.html 
       path="assets/img/transpoze_energy.png" 
       title="Comparaison énergétique selon le relief et vitesse" 
       class="img-fluid rounded z-depth-1" 
    %}
  </div>
</div>
<div class="caption" id="figure-8-analyse-consommation">
    Figure 8 : Analyse de la consommation énergétique selon différents paramètres.
</div>


---
<div class="caption">
Projet TranspoZé — Mastère OSE, Mines Paris – PSL, 2025. Réalisé dans le cadre de mon alternance chez EDF.
</div>
