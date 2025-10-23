---
layout: page
title: Electricity Production Planning
description: Optimization of electricity generation through Mixed-Integer Linear Programming (MILP)
img: assets/img/electricity_planning.jpg
lang: en
importance: 1
category: work
---

## Introduction

This project analyzes and optimizes the **daily planning of electricity generation** using **Mixed-Integer Linear Programming (MILP)**.  
Developed by **José ALVES**, this work was carried out as part of the course taught by [Sophie DEMASSEY](https://sofdem.github.io/) at the **École des Mines de Paris (PSL)**.  

The project studies different configurations of power plants (thermal and hydroelectric) in order to **minimize production costs** while satisfying **demand** and **reserve constraints**.  

The main objective is to determine the **optimal number of plants to operate** and their **power outputs** at each time period of the day, considering **operating costs**, **startup costs**, and **operational constraints**.

---

## Theoretical Background on Linear Optimization

**Linear Programming (LP)** aims to minimize (or maximize) a linear function subject to a set of linear constraints. In its standard form, a primal problem is written as:

$$
\min_{x} \; c^T x \quad \text{s.t.} \quad A x = b, \; x \ge 0
$$

Its associated **dual problem** is:

$$
\max_{y} \; b^T y \quad \text{s.t.} \quad A^T y \le c
$$

**Primal feasibility** means that there exists a vector $$x$$ satisfying $$A x = b$$ and $$x \ge 0$$, while **dual feasibility** requires a vector $$y$$ satisfying $$A^T y \le c$$.
When both problems admit feasible solutions, the **strong duality** theorem guarantees that their optimal values coincide:

$$
c^T x^* = b^T y^*
$$

This property forms the basis of much of the economic theory behind optimization: the Lagrange multipliers $$y_i$$ in the dual can be interpreted as **marginal costs** or **shadow prices**, representing the economic value of one additional unit of resource $$b_i$$.

In practice, the so-called **complementarity conditions** link the primal and dual optimal solutions:

$$
x_j (c_j - A_j^T y) = 0, \quad y_i (A_i x - b_i) = 0
$$

These relations show that:
- a strictly positive variable $$x_j$$ corresponds to a tight dual constraint,
- and a saturated primal constraint implies a nonzero dual multiplier.

Thus, analyzing both the primal and the dual helps not only to identify the optimal solution but also to understand the **system’s sensitivity** to variations in demand, costs, or generation capacities.

---

## Problem Data

### Characteristics of Thermal Plants

| Category | Number | Pmin (MW) | Pmax (MW) | Cmwh (€/MWh) | Cbase (€/h) | Cstart (€) |
|-----------|--------|-----------|-----------|--------------|-------------|------------|
| A         | 12     | 850       | 2000      | 2.0          | 1000        | 2000       |
| B         | 10     | 1250      | 1750      | 1.3          | 2600        | 1000       |
| C         | 5      | 1500      | 4000      | 3.0          | 3000        | 500        |

### Daily Demand Profile

| Period    | Hours | Demand (MW) |
|------------|--------|--------------|
| 00h - 06h  | 6      | 15000        |
| 06h - 09h  | 3      | 30000        |
| 09h - 15h  | 6      | 25000        |
| 15h - 18h  | 3      | 40000        |
| 18h - 00h  | 6      | 27000        |

---

## Model Evolution

### Model 1.5: Base Model with Minimum Power

The first model includes the **minimum power constraint** for each active plant:

$$
\min \sum_{t=1}^{3} \sum_{p=1}^{5} P_{tp} \cdot C_{t} \cdot T_{p}
$$

Subject to:

$$
\sum_{t=1}^{3} P_{tp} \geq D_{p}, \quad \forall p \in \{1, 2, 3, 4, 5\} \quad (C1)
$$

$$
N_{tp} P^{\text{min}}_t \leq P_{tp} \leq N_{tp} P^{\text{max}}_t, \quad \forall t, p \quad (C2)
$$

$$
N_{tp} \leq Nb_t, \quad \forall t, p \quad (C3)
$$

where:
- $$P_{tp}$$: total power from type $$t$$ during period $$p$$
- $$N_{tp}$$: number of active plants of type $$t$$ during period $$p$$
- $$C_t$$: marginal cost (€/MWh)
- $$T_p$$: duration of period $$p$$
- $$D_p$$: demand during period $$p$$

**Result: Optimal cost = 869 k€**

```python
# Variables
N = {}  # Number of active plants (integer)
P = {}  # Produced power (continuous)

for t in PLANTS.keys():
    for p in HOURS.keys():
        N[f"{t},{p}"] = m.addVar(lb=0, name=f"N_{t},{p}", vtype=gp.GRB.INTEGER)
        P[f"{t},{p}"] = m.addVar(lb=0, name=f"P_{t},{p}", vtype=gp.GRB.CONTINUOUS)
```

---

### Model 2.1: Integration of Fixed Costs (Cbase)

The model evolves to include **fixed operating costs**:

$$
\min \sum_{t=1}^{3} \sum_{p=1}^{5} \left[(P_{tp} - N_{tp} \cdot P^{\text{min}}_t) \cdot C_{t}^{mwh} + N_{tp} \cdot C_{t}^{base}\right] \cdot T_{p}
$$

This formulation separates:
- the **variable cost** proportional to production above the minimum
- the **fixed cost** proportional to the number of active plants

**Result: Optimal cost = 979 k€** (+12.7% compared to model 1.5)

---

### Model 2.2: Adding Startup Costs (Cstart)

The introduction of the variable $$X_{tp}$$ (number of plants started) requires a new consistency constraint:

$$
N_{tp} \leq X_{tp} + N_{t(p-1)} \quad (C4)
$$

The objective function becomes:

$$
\min \sum_{t=1}^{3} \sum_{p=1}^{5} \left[(P_{tp} - N_{tp} \cdot P^{\text{min}}_t) \cdot C_{t}^{mwh} + N_{tp} \cdot C_{t}^{base}\right] \cdot T_{p} + \sum_{t=1}^{3} \sum_{p=1}^{5} X_{tp} \cdot C_{t}^{start}
$$

**Result: Optimal cost = 1014 k€** (+3.6% compared to model 2.1)

```python
# Startup constraint
for p in HOURS.keys():
    for t in PLANTS.keys():
        left_side = X[f"{t},{p}"] + Ntp(t, p, N, cyclic=False)
        right_side = N[f"{t},{p}"]
        m.addConstr(left_side >= right_side, name=f"start_{t}_{p}")
```

---

### Model 3.1: Reserve Constraint (15%)

To ensure **grid reliability**, a 15% reserve margin is enforced:

$$
\sum_{t=1}^{3} (N_{tp} \cdot P^{\text{max}}_t - P_{tp}) \geq 0.15 \cdot D_{p} \quad (C5)
$$

**Result: Optimal cost = 1015 k€** (+0.1% compared to model 2.2)

---

### Model 4.1: Cyclic Planning

This model enforces that the final state (period 5) is consistent with the initial state (period 1):

$$
N_{tp} \leq X_{tp} + N_{t(p-1)} \quad \text{with } N_{t,0} = N_{t,5}
$$

This approach represents a **24-hour cyclic schedule**.

**Result: Optimal cost = 989 k€** (-2.6% compared to model 3.1)

---

### Model 5.1: Adding Hydroelectric Plants

Two hydroelectric plants are available:

| Type | Power (MW) | Base Cost (€/h) | Startup Cost (€) | Lowering (m/h) |
|------|-------------|-----------------|------------------|----------------|
| H1   | 900         | 90              | 1500             | 0.31           |
| H2   | 1400        | 150             | 1200             | 0.47           |

These plants **consume no fuel** (Cmwh = 0) but reduce the reservoir level.

**Result: Optimal cost = 890 k€** (-10.0% compared to model 4.1)

---

### Model 5.2: Pumping Constraint

The reservoir level must remain **constant over 24 hours**. Pumping requires 3000 MWh per meter of elevation:

$$
\sum_{p=1}^{5}\sum_{t=1}^{5} P_{tp} \cdot T_p \geq \sum_{p=1}^{5} D_{p} \cdot T_p + \sum_{p=1}^{5}\sum_{t=4}^{5} 3000 \cdot M_t \cdot N_{tp} \cdot T_p \quad (C6)
$$

where $$M_t$$ is the reservoir lowering speed (m/h).

**Result: Optimal cost = 987 k€** (+10.9% compared to model 5.1)

---

## Theoretical Analysis: Sensitivity and Duality

### Merit Order and Optimal Solution

The **Merit Order** method activates plants in ascending order of marginal cost.

For $$p=1$$ (demand = 15 GW): the numerical solution matches Gurobi results.

---

### Duality and Marginal Costs

The primal model in standard form:

$$
\begin{aligned}
\min & \quad 9 P_{A1} + 8.28 P_{B1} + 16.5 P_{C1} \\
\text{s.t.} & \quad P_{A1} + P_{B1} + P_{C1} = 15
\end{aligned}
$$

Its dual form:

$$
\begin{aligned}
\max & \quad 15 v \\
\text{s.t.} & \quad v \leq 9 \\
& \quad v \leq 8.28 \\
& \quad v \leq 16.5
\end{aligned}
$$

---

## Comparative Results

| Model | Variables | Constraints | Explored Nodes | Time (s) | Cost (k€) |
|--------|-----------|-------------|----------------|-----------|-----------|
| 1.5    | 30        | 50          | 1              | 0.02      | **869**   |
| 2.1    | 30        | 50          | 1              | 0.02      | **979**   |
| 2.2    | 45        | 65          | 1              | 0.06      | **1014**  |
| 3.1    | 45        | 70          | 1              | 0.01      | **1015**  |
| 4.1    | 45        | 70          | 1              | 0.01      | **989**   |
| 5.1    | 75        | 110         | 1              | 0.04      | **890**   |
| 5.2    | 75        | 111         | 16             | 0.15      | **987**   |

---

## Economic Interpretation

1. **Dominant fixed costs**: Moving from model 1.5 to 2.1 (+12.7%) highlights the significance of fixed costs.
2. **Moderate startup costs**: Model 2.2 adds only +3.6% extra cost.
3. **Cyclic planning advantage**: Model 4.1 reduces costs by 2.6% by optimizing transitions.
4. **Hydropower competitiveness**: Model 5.1 reduces costs by 10% thanks to zero variable cost.
5. **Pumping costs**: Model 5.2 shows reservoir neutrality adds +10.9% in cost.

---

## Mathematical Properties

### Total Unimodularity

The constraint matrix of model 1.5 exhibits **total unimodularity**:
- All coefficients belong to $$\{-1, 0, 1\}$$
- Each column contains at most two nonzero elements

**Consequence**: The continuous relaxation yields integer solutions, explaining the fast resolution (1 node explored).

### Complementarity Gaps

At the optimum, **Karush–Kuhn–Tucker (KKT)** conditions are:

$$
(c_j - u^T A_j) x_j = 0 \quad \text{and} \quad u_i (a_i x - b_i) = 0
$$

---

## Conclusion

This project demonstrates the effectiveness of **Mixed-Integer Linear Programming** for solving complex energy planning problems. The progressive model analysis reveals:

- The importance of modeling **all cost components** (fixed, variable, startup)
- The benefit of **cyclic planning** for smoother transitions
- The economic interest of **hydropower**, despite pumping constraints
- Numerical stability due to the **unimodular structure** of the problem

Results obtained with **Gurobi** show very short computation times (<0.2s), this is due to the small size of the problem, in real life there are thousands of variables, here we just have hundreds.

---

## Source Code

Try the Python **Streamlit** application using **Gurobi** and **Pandas** here:  
👉 [App](https://milp-ose.streamlit.app/)

---
<div class="caption">
Project presented as part of the OSE Master’s program — Mines Paris – PSL, 2025.
</div>
