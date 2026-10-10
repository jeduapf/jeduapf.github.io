---
layout: page
title: LissajouZ – Épicycles Harmoniques & Visualiseur d'Espace de Phase de Lissajous
description: Compositeur interactif d'épicycles de Fourier ptolémaïques et simulateur d'espace de phase électrique (V, I) avec calcul d'aire par le théorème de Green et synthèse DFT en temps réel.
img: assets/img/lissajouz_cover.png
lang: fr
importance: 1
category: cool
---

> 🌐 **Application Web en Direct** : [lissajouz.jeduapf.com](https://lissajouz.jeduapf.com) — *Outil interactif gratuit, 100% exécuté dans le navigateur, sans installation !*

---

## 🌀 Explorez la Géométrie Harmonique avec LissajouZ !

**LissajouZ** est un visualiseur mathématique et physique interactif dédié aux **épicycles de Fourier ptolémaïques**, aux **figures de Lissajous** et à l'**espace de phase électrique dynamique $(v, i)$**.

Que vous étudiiez les séries de Fourier complexes, la distorsion harmonique au Point de Raccordement Commun (PCC) d'un réseau électrique ou la géométrie de résonance, LissajouZ offre un laboratoire visuel pour assembler des chaînes de phaseurs rotatifs, tracer des trajectoires orbitales et extraire des invariants analytiques exacts en temps réel.

---

## ⚡ Les Points Forts de LissajouZ

- 🔄 **Chaînes d'Épicycles Complexes Bout à Bout** : Composez des bras ptolémaïques rotatifs avec ordres harmoniques $k$, rayons $r_k$, angles de phase $\theta_k$ et taux d'amortissement / croissance $\sigma_k$ personnalisables.
- ⚡ **Espace de Phase Électrique $(V, I)$ & Impédance de Réseau (PCC)** : Basculez facilement entre la vue cinématique et les phaseurs électriques symétriques via décomposition de Fortescue. Modélisez l'impédance série du réseau $Z_{\text{grid}} = R_g + j \cdot k\omega_0 L_g$ pour analyser les boucles de puissance réactive, le taux de distorsion harmonique (THD) et les déformations de ponts redresseurs.
- 📈 **Oscilloscope Temporel Synchronisé** : Affichage temps réel à double canal présentant les signaux $v(t)$ et $i(t)$ en parfaite synchronisation avec la trajectoire du plan de phase.
- ✏️ **Esquisse à Main Levée vers Épicycles par DFT Planaire** : Dessinez n'importe quelle forme directement sur le canevas ! L'application réalise une paramétrisation par longueur d'arc, un rééchantillonnage uniforme ($N = 256$) et une Transformée de Fourier Discrète (DFT) complexe 2D pour synthétiser automatiquement la chaîne d'épicycles correspondante.
- 📐 **HUD d'Invariants Mathématiques Exacts** : Évaluation instantanée de la période de fermeture du cycle $T_{\text{cycle}}$, détection du nombre d'auto-intersections et calcul exact de l'aire algébrique délimitée $\oint v\,di$ via le théorème de Green.
- 📱 **Ergonomie Mobile & Multi-Écrans** : Prise en charge tactile complète (glisser à 1 doigt pour translater / dessiner, pincement à 2 doigts pour zoomer), tiroir rétractable pour smartphones et haute lisibilité sur écrans 4K.
- 📖 **Guide Théorique & Démonstrations Intégré** : Formulations complètes avec rendu KaTeX expliquant les épicycles de Fourier, le calcul analytique d'aire de Green, l'impédance de réseau et la synthèse DFT.

---

## 🔬 Formulation Mathématique & Technique

### 1. Série d'Épicycles Complexes

Une trajectoire planaire s'exprime dans $\mathbb{C} \cong \mathbb{R}^2$ comme une somme de phaseurs rotatifs complexes :

$$
z(t) = v(t) + j \cdot i(t) = \sum_{k \in \mathcal{K}} c_k e^{(\sigma_k + j \cdot k \cdot \omega_0) t}
$$

où $c_k = r_k e^{j\theta_k}$, $k \in \mathbb{Z}$ est l'ordre harmonique et $\omega_0 = 2\pi / T_0$ la pulsation fondamentale.

### 2. Période de Clôture & Condition de Résonance

Pour un système non amorti ($\sigma_k = 0$), la courbe est strictement fermée si et seulement si les rapports de fréquences sont rationnels :

$$
T_{\text{cycle}} = \frac{2\pi}{\omega_0 \cdot \gcd(k_1, k_2, \dots, k_N)}
$$

### 3. Aire Algébrique Délimitée par le Théorème de Green

En utilisant le théorème de Green et l'orthogonalité complexe, l'aire délimitée est obtenue sous forme exacte fermée :

$$
\mathcal{A} = \oint_\gamma v \, di = \frac{1}{2j} \oint_\gamma (\bar{z} \, dz - z \, d\bar{z}) = \pi \sum_{k} k |c_k|^2 = \pi \sum_k k r_k^2
$$

Chaque bras harmonique apporte une contribution algébrique indépendante proportionnelle à son rang fréquentiel $k$ et au carré de son amplitude $r_k^2$.

### 4. Modèle d'Impédance de Réseau au PCC

La chute de tension causée par les courants harmoniques traversant l'impédance de grille $Z_{\text{grid}}(k) = R_g + j \cdot k\omega_0 L_g$ obéit à :

$$
v_{\text{pcc}}(t) = v_{\text{grid}}(t) - R_g i(t) - L_g \frac{di(t)}{dt}
$$

L'aire de la boucle de phase correspond directement à la puissance réactive $\mathcal{Q} = \frac{\omega_0}{\pi} \mathcal{A}$.

### 5. Transformée de Fourier Discrète (DFT) Planaire

Lors du dessin d'une forme libre, les points interpolés $\{z_n = x_n + j y_n\}_{n=0}^{N-1}$ sont convertis en harmoniques par DFT complexe :

$$
c_k = \frac{1}{N} \sum_{n=0}^{N-1} (x_n + j y_n) \exp\left( -j \frac{2\pi k n}{N} \right), \quad k \in [-K_{\max}, K_{\max}]
$$

---

🚀 **Essayez LissajouZ dès maintenant gratuitement sur [lissajouz.jeduapf.com](https://lissajouz.jeduapf.com) !**

---

`#Lissajous` `#Epicycles` `#FourierSeries` `#EspaceDePhase` `#GenieElectrique` `#ImpedanceDeReseau` `#DFT` `#Harmoniques` `#TraitementDuSignal` `#KaTeX` `#DataVisualization` `#Vite`