---
layout: page
title: LissajouZ – Harmonic Epicycles & Lissajous Phase Space Visualizer
description: Interactive Ptolemaic Fourier epicycle composer and electrical (V, I) phase space simulator with Green's theorem area calculation and real-time planar DFT curve synthesis.
img: assets/img/lissajouz_cover.png
lang: en
importance: 1
category: fun
---

> 🌐 **Live Web App**: [lissajouz.jeduapf.com](https://lissajouz.jeduapf.com) — *Free interactive tool, 100% client-side, zero installation needed!*

---

## 🌀 Explore Harmonic Geometry with LissajouZ!

**LissajouZ** is a state-of-the-art interactive mathematical visualizer dedicated to **Ptolemaic Fourier epicycles**, **Lissajous curves**, and **electrical dynamic phase space $$(v, i)$$**.

Whether you are studying complex Fourier analysis, harmonic distortion at an electrical Point of Common Coupling (PCC), or the geometry of resonance, LissajouZ provides an intuitive laboratory to compose rotating phasor chains, trace closed orbits, and extract exact analytical invariants in real time.

---

## ⚡ What Makes LissajouZ Powerful?

- 🔄 **Tip-to-Tail Complex Epicycle Chains**: Chain rotating Ptolemaic arms with customizable harmonic orders $$k$$, radii $$r_k$$, phase angles $$\theta_k$$, and radial damping / growth rates $$\sigma_k$$.
- ⚡ **Electrical $$(V, I)$$ Phase Space & PCC Grid Impedance**: Switch seamlessly between rotating arms and symmetrical electrical phasors with Fortescue decomposition. Model Point of Common Coupling (PCC) series grid impedance $$Z_{\text{grid}} = R_g + j \cdot k\omega_0 L_g$$ to observe reactive power loops, harmonic distortion (THD), and rectifier deformations.
- 📈 **Live Synchronized Oscilloscope**: Dual-channel time-domain strip showing instantaneous $$v(t)$$ and $$i(t)$$ waveforms synchronized with phase-plane motion.
- ✏️ **Freehand Sketch-to-Epicycles via Planar DFT**: Draw any freehand curve directly on the canvas! The app automatically performs arc-length parameterization, uniform resampling ($$N = 256$$), and a complex 2D Discrete Fourier Transform (DFT) to synthesize matching epicycle chains.
- 📐 **Exact Mathematical Invariants HUD**: Real-time evaluation of cycle closure period $$T_{\text{cycle}}$$, self-intersection knot count, and exact enclosed signed area $$\oint v\,di$$ via Green's theorem.
- 📱 **Responsive & Mobile Ready**: Full touch gesture support (1-finger pan/draw, 2-finger pinch-to-zoom), collapsible controls drawer, high-contrast typography, and full 4K desktop scaling.
- 📖 **In-App Theory & Proofs Guide**: Complete mathematical derivations formatted in KaTeX detailing Fourier epicycles, Green's theorem area integrals, grid impedance dynamics, and DFT curve synthesis.

---

## 🔬 Technical & Mathematical Formulation

### 1. Complex Epicycle Series

A planar trajectory is represented in $$\mathbb{C} \cong \mathbb{R}^2$$ as a superposition of rotating complex phasors:

$$
z(t) = v(t) + j \cdot i(t) = \sum_{k \in \mathcal{K}} c_k e^{(\sigma_k + j \cdot k \cdot \omega_0) t}
$$

where $$c_k = r_k e^{j\theta_k}$$, $$k \in \mathbb{Z}$$ represents the harmonic order, and $$\omega_0 = 2\pi / T_0$$ is the fundamental angular frequency.

### 2. Closure Period & Resonance Condition

For undamped orbits ($$\sigma_k = 0$$), the curve closes if and only if frequency ratios are rational:

$$
T_{\text{cycle}} = \frac{2\pi}{\omega_0 \cdot \gcd(k_1, k_2, \dots, k_N)}
$$

### 3. Enclosed Signed Area via Green's Theorem

By Green's theorem and complex orthogonality, the enclosed area is evaluated analytically in closed form:

$$
\mathcal{A} = \oint_\gamma v \, di = \frac{1}{2j} \oint_\gamma (\bar{z} \, dz - z \, d\bar{z}) = \pi \sum_{k} k |c_k|^2 = \pi \sum_k k r_k^2
$$

Each harmonic arm contributes an independent signed area proportional to its frequency order $$k$$ and radius squared $$r_k^2$$.

### 4. Point of Common Coupling (PCC) Grid Impedance

The voltage distortion induced by current harmonics flowing through grid impedance $$Z_{\text{grid}}(k) = R_g + j \cdot k\omega_0 L_g$$ satisfies:

$$
v_{\text{pcc}}(t) = v_{\text{grid}}(t) - R_g i(t) - L_g \frac{di(t)}{dt}
$$

The reactive power loop area directly corresponds to $$\mathcal{Q} = \frac{\omega_0}{\pi} \mathcal{A}$$.

### 5. Planar Discrete Fourier Transform (DFT)

When sketching freehand contours, resampled points $$\{z_n = x_n + j y_n\}_{n=0}^{N-1}$$ are converted into epicycle arms via complex DFT:

$$
c_k = \frac{1}{N} \sum_{n=0}^{N-1} (x_n + j y_n) \exp\left( -j \frac{2\pi k n}{N} \right), \quad k \in [-K_{\max}, K_{\max}]
$$

---

🚀 **Try LissajouZ live now for free at [lissajouz.jeduapf.com](https://lissajouz.jeduapf.com)!**

---

`#Lissajous` `#Epicycles` `#FourierSeries` `#PhaseSpace` `#ElectricalEngineering` `#GridImpedance` `#DFT` `#Harmonics` `#SignalProcessing` `#KaTeX` `#DataVisualization` `#Vite`