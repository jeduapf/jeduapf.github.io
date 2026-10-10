---
layout: page
title: Planification de la Production d'Électricité
description: Optimisation de la production électrique par programmation linéaire en nombres entiers mixtes (MILP)
img: assets/img/electricity_planning.jpg
lang: fr
key: electric-planning
importance: 1
category: travail
---

## Introduction

Ce projet analyse et optimise la **planification journalière de la production d'électricité** en utilisant la **programmation linéaire en nombres entiers mixtes (MILP)**.  

Ce travail a été réalisé dans le cadre du cours de [Sophie DEMASSEY](https://sofdem.github.io/) à l’**École des Mines de Paris (PSL)**.  

Le projet étudie différentes configurations de centrales électriques (thermiques et hydroélectriques) afin de **minimiser les coûts de production** tout en respectant les contraintes de **demande** et de **réserve**.  

L'objectif principal est de déterminer le **nombre optimal de centrales à activer** et leurs **puissances** à chaque période de la journée, en tenant compte des **coûts de fonctionnement**, des **coûts de démarrage** et des **contraintes opérationnelles**. 

Il faut tenir en compte que ce projet simplifie la nature réelle du problème, en supposant que la **demande** est connue et fixe avant la planification. En réalité, la demande est une variable aléatoire, et la planification doit tenir compte de la **réserve** pour assurer la stabilité de la réseau électrique.

---

## Complément théorique sur l’optimisation linéaire

La **programmation linéaire (PL)** consiste à minimiser (ou maximiser) une fonction linéaire soumise à un ensemble de contraintes linéaires. Sous sa forme standard, un problème primal s’écrit :

$$
\min_{x} ; c^T x \quad \text{sous} \quad A x = b, ; x \ge 0
$$

À ce problème est associé un **problème dual**, exprimé par :

$$
\max_{y} ; b^T y \quad \text{sous} \quad A^T y \le c
$$

La **faisabilité primale** signifie qu’il existe au moins un vecteur $$x$$ respectant les contraintes $$A x = b$$ et $$x \ge 0$$, tandis que la **faisabilité duale** impose l’existence d’un vecteur $$y$$ satisfaisant $$A^T y \le c$$.
Lorsqu’un problème admet une solution réalisable pour les deux formulations (primal et dual), la **dualité forte** garantit que leurs valeurs optimales coïncident :

$$
c^T x^* = b^T y^*
$$

Cette propriété fonde une grande partie de la théorie économique de l’optimisation : les multiplicateurs de Lagrange $$y_i$$ associés au dual peuvent être interprétés comme des **coûts marginaux** ou **prix d’ombre**, représentant la valeur économique d’une unité supplémentaire de ressource $$b_i$$.

Dans la pratique, les conditions dites de **complémentarité** relient les solutions primales et duales à l’optimum :

$$
x_j (c_j - A_j^T y) = 0, \quad y_i (A_i x - b_i) = 0
$$

Ces relations démontrent que :

* une variable $$x_j$$ strictement positive correspond à une contrainte duale saturée,
* et une contrainte primale saturée implique un multiplicateur dual non nul.

Ainsi, l’étude conjointe du primal et du dual permet non seulement d’identifier la solution optimale, mais aussi de comprendre la **sensibilité du système** aux variations de la demande, des coûts ou des capacités de production.

---

## Données du Problème

### Caractéristiques des Centrales Thermiques

| Catégorie | Nombre | Pmin (MW) | Pmax (MW) | Cmwh (€/MWh) | Cbase (€/h) | Cstart (€) |
|-----------|--------|-----------|-----------|--------------|-------------|------------|
| A         | 12     | 850       | 2000      | 2.0          | 1000        | 2000       |
| B         | 10     | 1250      | 1750      | 1.3          | 2600        | 1000       |
| C         | 5      | 1500      | 4000      | 3.0          | 3000        | 500        |



### Profil de Demande Journalière

| Période    | Heures | Demande (MW) |
|------------|--------|--------------|
| 00h - 06h  | 6      | 15000        |
| 06h - 09h  | 3      | 30000        |
| 09h - 15h  | 6      | 25000        |
| 15h - 18h  | 3      | 40000        |
| 18h - 00h  | 6      | 27000        |

---

## Évolution des Modèles

### Modèle 1.5 : Modèle de Base avec Puissance Minimale

Le premier modèle intègre la contrainte de **puissance minimale** pour chaque centrale activée :

$$
\min \sum_{t=1}^{3} \sum_{p=1}^{5} P_{tp} \cdot C_{t} \cdot T_{p}
$$

Sous les contraintes :

$$
\sum_{t=1}^{3} P_{tp} \geq D_{p}, \quad \forall p \in \{1, 2, 3, 4, 5\} \quad (C1)
$$

$$
N_{tp} P^{\text{min}}_t \leq P_{tp} \leq N_{tp} P^{\text{max}}_t, \quad \forall t, p \quad (C2)
$$

$$
N_{tp} \leq Nb_t, \quad \forall t, p \quad (C3)
$$

où :
- $$P_{tp}$$ : puissance totale du type $$t$$ à la période $$p$$
- $$N_{tp}$$ : nombre de centrales actives du type $$t$$ à la période $$p$$
- $$C_t$$ : coût marginal (€/MWh)
- $$T_p$$ : durée de la période $$p$$
- $$D_p$$ : demande de la période $$p$$

**Résultat : Coût optimal = 869 k€**

En Gurobi, les variables sont déclarées comme suit : 
```python
# Variables
N = {}  # Nombre de centrales actives (entières)
P = {}  # Puissance produite (continues)

for t in USINES.keys():
    for p in HOURS.keys():
        N[f"{t},{p}"] = m.addVar(lb=0, name=f"N_{t},{p}", vtype=gp.GRB.INTEGER)
        P[f"{t},{p}"] = m.addVar(lb=0, name=f"P_{t},{p}", vtype=gp.GRB.CONTINUOUS)
```

---

### Modèle 2.1 : Intégration des Coûts Fixes (Cbase)

Le modèle évolue pour intégrer les **coûts fixes de fonctionnement** :

$$
\min \sum_{t=1}^{3} \sum_{p=1}^{5} \left[(P_{tp} - N_{tp} \cdot P^{\text{min}}_t) \cdot C_{t}^{mwh} + N_{tp} \cdot C_{t}^{base}\right] \cdot T_{p}
$$

Cette formulation sépare :
- Le **coût variable** proportionnel à la production au-delà du minimum
- Le **coût fixe** proportionnel au nombre de centrales actives

**Résultat : Coût optimal = 979 k€** (+12.7% par rapport au modèle 1.5)

---

### Modèle 2.2 : Ajout des Coûts de Démarrage (Cstart)

L'introduction de la variable $$X_{tp}$$ (nombre de centrales démarrées) nécessite une nouvelle contrainte de cohérence :

$$
N_{tp} \leq X_{tp} + N_{t(p-1)} \quad (C4)
$$

La fonction objectif devient :

$$
\min \sum_{t=1}^{3} \sum_{p=1}^{5} \left[(P_{tp} - N_{tp} \cdot P^{\text{min}}_t) \cdot C_{t}^{mwh} + N_{tp} \cdot C_{t}^{base}\right] \cdot T_{p} + \sum_{t=1}^{3} \sum_{p=1}^{5} X_{tp} \cdot C_{t}^{start}
$$

**Résultat : Coût optimal = 1014 k€** (+3.6% par rapport au modèle 2.1)

En Gurobi, les variables sont déclarées comme suit : 
```python
# Contrainte de démarrage
for p in HOURS.keys():
    for t in USINES.keys():
        left_side = X[f"{t},{p}"] + Ntp(t, p, N, cyclique=False)
        right_side = N[f"{t},{p}"]
        m.addConstr(left_side >= right_side, name=f"allume_{t}_{p}")
```

---

### Modèle 3.1 : Contrainte de Réserve (15%)

Pour garantir la **sécurité du réseau**, on impose une réserve de puissance de 15% :

$$
\sum_{t=1}^{3} (N_{tp} \cdot P^{\text{max}}_t - P_{tp}) \geq 0.15 \cdot D_{p} \quad (C5)
$$

**Résultat : Coût optimal = 1015 k€** (+0.1% par rapport au modèle 2.2)

L'impact marginal s'explique par le fait que la solution précédente disposait déjà d'une marge naturelle.

---

### Modèle 4.1 : Planification Cyclique

Dans ce modèle, on impose que l'état final (période 5) soit cohérent avec l'état initial (période 1) :

$$
N_{tp} \leq X_{tp} + N_{t(p-1)} \quad \text{avec } N_{t,0} = N_{t,5}
$$

Cette approche reflète une **planification sur 24h répétable quotidiennement**.

**Résultat : Coût optimal = 989 k€** (-2.6% par rapport au modèle 3.1)

L'optimisation cyclique permet de **réduire les coûts de démarrage** en optimisant la transition jour-nuit.

En Gurobi, cette contrainte peut être implémentée comme suit :
```python
def Ntp(t, p, N, cyclique=True):
    if p == 1:
        if cyclique:
            Np_1 = N[f"{t},5"]  # Boucle cyclique
        else:
            Np_1 = 0  # Démarrage à froid
    else:
        Np_1 = N[f"{t},{p-1}"]
    return Np_1
```

---

## Intégration des Centrales Hydroélectriques

### Modèle 5.1 : Ajout de Deux Centrales Hydro

Deux centrales hydroélectriques sont disponibles :

| Type | Puissance (MW) | Coût base (€/h) | Coût démarrage (€) | Abaissement (m/h) |
|------|----------------|-----------------|---------------------|-------------------|
| H1   | 900            | 90              | 1500                | 0.31              |
| H2   | 1400           | 150             | 1200                | 0.47              |

Ces centrales **ne consomment pas de combustible** (Cmwh = 0) mais abaissent le niveau du réservoir.

**Résultat : Coût optimal = 890 k€** (-10.0% par rapport au modèle 4.1)

Les centrales hydro, plus économiques, remplacent partiellement les centrales thermiques coûteuses.

---

### Modèle 5.2 : Contrainte de Pompage

Le niveau du réservoir doit être **constant sur 24h**. Le pompage nécessite 3000 MWh par mètre d'élévation :

$$
\sum_{p=1}^{5}\sum_{t=1}^{5} P_{tp} \cdot T_p \geq \sum_{p=1}^{5} D_{p} \cdot T_p + \sum_{p=1}^{5}\sum_{t=4}^{5} 3000 \cdot M_t \cdot N_{tp} \cdot T_p \quad (C6)
$$

où $$M_t$$ est la vitesse d'abaissement du réservoir (en m/h).

**Résultat : Coût optimal = 987 k€** (+10.9% par rapport au modèle 5.1)

Le coût du pompage compense partiellement l'économie réalisée par l'hydro.

En Gurobi, cette contrainte peut être implémentée comme suit :
```python
# Contrainte de pompage
left_side = sum(P[f"{t},{p}"]*HOURS[p] for t in USINES.keys() for p in HOURS.keys())
right_side = (sum(DEMAND[p]*HOURS[p] for p in HOURS.keys()) + 
              sum(3000*N[f"{t},{p}"]*USINES[t]['v_abai']*HOURS[p] 
                  for t in USINES.keys() for p in HOURS.keys()))
m.addConstr(left_side >= right_side, name="Pompage")
```

---

## Analyse Théorique : Sensibilité et Dualité

### Merit Order et Solution Optimale

La méthode du **Merit Order** consiste à activer les centrales dans l'ordre croissant de leur coût marginal :

Pour $$p=1$$ (demande = 15 GW) :

$$
\mathbf{X_1} = \begin{bmatrix} P_{A1} = 0 \\ P_{B1} = 15 \\ P_{C1} = 0 \end{bmatrix}
$$

Cette solution est **vérifiée numériquement** par Gurobi.

---

### Dualité et Coûts Marginaux

Le modèle primal en forme standard :

$$
\begin{aligned}
\min & \quad 9 P_{A1} + 8.28 P_{B1} + 16.5 P_{C1} \\
\text{s.t.} & \quad P_{A1} + \delta_A = 24 \\
& \quad P_{B1} + \delta_B = 17.5 \\
& \quad P_{C1} + \delta_C = 20 \\
& \quad P_{A1} + P_{B1} + P_{C1} = 15
\end{aligned}
$$

Son dual s'écrit :

$$
\begin{aligned}
\max & \quad 24 u_{A} + 17.5 u_{B} + 20 u_{C} + 15 v \\
\text{s.t.} & \quad u_A + v \leq 9 \\
& \quad u_B + v \leq 8.28 \\
& \quad u_C + v \leq 16.5
\end{aligned}
$$

---

### Analyse de Sensibilité

#### Impact d'une augmentation de la demande (+1 GW)

La nouvelle solution est :

$$
x_{\beta}^{'} = x_{\beta} + \Delta \cdot A_{\beta}^{-1} e_4
$$

**Résultat : Coût additionnel = 8.28 k€**

```python
delta = 1
x_beta_ligne = x_beta + np.dot(delta*np.linalg.inv(A_beta1), e(4, 4))
cout_maintenant = np.dot(C_beta1, x_beta_ligne)[0][0]
print(f"Surcoût: {cout_maintenant - cout_avant:.2f} k€")
```

#### Impact d'une centrale supplémentaire de type B

- **Période 1** : aucun impact (capacité excédentaire)
- **Période 2** : économie de **630 €**

---

## Résultats Comparatifs

| Modèle | Variables | Contraintes | Nœuds explorés | Temps (s) | Coût (k€) |
|--------|-----------|-------------|----------------|-----------|-----------|
| 1.5    | 30        | 50          | 1              | 0.02      | **869**   |
| 2.1    | 30        | 50          | 1              | 0.02      | **979**   |
| 2.2    | 45        | 65          | 1              | 0.06      | **1014**  |
| 3.1    | 45        | 70          | 1              | 0.01      | **1015**  |
| 4.1    | 45        | 70          | 1              | 0.01      | **989**   |
| 5.1    | 75        | 110         | 1              | 0.04      | **890**   |
| 5.2    | 75        | 111         | 16             | 0.15      | **987**   |

---

## Interprétation Économique

1. **Coûts fixes dominants** : Le passage du modèle 1.5 au 2.1 (+12.7%) montre l'importance des coûts de base.
2. **Coûts de démarrage modérés** : Le modèle 2.2 n'ajoute que 3.6% de coût supplémentaire.
3. **Planification cyclique avantageuse** : Le modèle 4.1 réduit les coûts de 2.6% en optimisant les transitions.
4. **Hydroélectricité compétitive** : Le modèle 5.1 réduit les coûts de 10% grâce à des coûts variables nuls.
5. **Pompage coûteux** : Le modèle 5.2 montre que la contrainte de neutralité du réservoir ajoute 10.9% aux coûts.

---

## Propriétés Mathématiques

### Unimodularité Totale

La matrice des contraintes du modèle 1.5 possède la **propriété d'unimodularité totale** :
- Tous les coefficients sont dans $$\{-1, 0, 1\}$$
- Chaque colonne contient au plus deux éléments non nuls

**Conséquence** : La relaxation continue donne une solution entière, ce qui explique la résolution rapide (1 nœud exploré).

### Écarts Complémentaires

À l'optimum, les conditions de **Karush-Kuhn-Tucker (KKT)** s'écrivent :

$$
(c_j - u^T A_j) x_j = 0 \quad \text{et} \quad u_i (a_i x - b_i) = 0
$$

Ces conditions garantissent qu'à l'optimum :
- Les variables non basiques ont un coût réduit positif
- Les contraintes saturées ont un multiplicateur de Lagrange non nul

---

## Conclusion

Ce projet démontre l'efficacité de la **programmation linéaire en nombres entiers** pour résoudre des problèmes complexes de planification énergétique. L'analyse progressive des modèles révèle :

- L'importance de modéliser **tous les coûts** (fixes, variables, démarrage)
- Les bénéfices de la **planification cyclique** pour réduire les coûts de transition
- L'intérêt économique de l'**hydroélectricité**, malgré les contraintes de pompage
- La stabilité numérique grâce à l'**unimodularité** de la structure du problème

Les résultats obtenus avec **Gurobi** montrent des temps de résolution très courts (< 0.2 s). Cependant, en réalité, ce type de problème contient des milliers de variables, ce qui augmente considérablement le temps de résolution.

---

## Code Source

Jouer avec l'application Streamlit codé en Python utilisant **Gurobi** et **Pandas** sur:  
👉 [App](https://milp-ose.streamlit.app/)

---
<div class="caption">
Projet présenté dans le cadre du mastère OSE — Mines Paris – PSL, 2025.
</div>
