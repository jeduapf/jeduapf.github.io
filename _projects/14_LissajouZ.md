---
layout: page
title: LissajouZ – Epiciclos Harmônicos & Visualizador de Espaço de Fase de Lissajous
description: Compositor interativo de epiciclos de Fourier ptolemaicos e simulador de espaço de fase elétrico (V, I) com cálculo de área pelo teorema de Green e síntese DFT em tempo real.
img: assets/img/lissajouz_cover.png
lang: pt
importance: 1
category: diversão
---

> 🌐 **Aplicativo Web ao Vivo**: [lissajouz.jeduapf.com](https://lissajouz.jeduapf.com) — *Ferramenta interativa gratuita, 100% no navegador, sem necessidade de instalação!*

---

## 🌀 Explore a Geometria Harmônica com o LissajouZ!

O **LissajouZ** é um visualizador matemático e físico interativo de última geração dedicado aos **epiciclos de Fourier ptolemaicos**, às **curvas de Lissajous** e à dinâmica do **espaço de fase elétrico $(v, i)$**.

Seja estudando séries de Fourier complexas, distorção harmônica no Ponto de Acoplamento Comum (PAC/PCC) de redes elétricas ou geometria de ressonância, o LissajouZ fornece um laboratório intuitivo para compor cadeias de fasores rotativos, rastrear órbitas fechadas e calcular invariantes analíticos exatos em tempo real.

---

## ⚡ Por que escolher o LissajouZ?

- 🔄 **Cadeias de Epiciclos Complexos Ponta-a-Ponta**: Conecte braços rotativos ptolemaicos com ordens harmônicas $k$, raios $r_k$, ângulos de fase $\theta_k$ e taxas de amortecimento / crescimento $\sigma_k$ totalmente configuráveis.
- ⚡ **Espaço de Fase Elétrico $(V, I)$ & Impedância de Rede (PCC)** : Alterne fluidamente entre a representação mecânica e os fasores elétricos simétricos com decomposição de Fortescue. Modele a impedância de rede $Z_{\text{grid}} = R_g + j \cdot k\omega_0 L_g$ para observar laços de potência reativa, distorção harmônica total (THD) e deformações causadas por cargas não-lineares.
- 📈 **Osciloscópio Temporal Sincronizado**: Canal duplo no domínio do tempo exibindo as formas de onda de $v(t)$ e $i(t)$ em sincronia precisa com o movimento no plano de fase.
- ✏️ **Desenho Livre Convertido em Epiciclos via DFT Planar**: Desenhe qualquer contorno livremente na tela! O app aplica automaticamente parametrização por comprimento de arco, reamostragem uniforme ($N = 256$) e a Transformada Discreta de Fourier (DFT) 2D complexa para sintetizar a cadeia de epiciclos equivalente.
- 📐 **Painel de Invariantes Matemáticos Exatos**: Avaliação em tempo real do período de fechamento do ciclo $T_{\text{cycle}}$, contagem de auto-interseções da curva e cálculo exato da área orientada delimitada $\oint v\,di$ pelo teorema de Green.
- 📱 **Experiência Responsiva e Touch**: Gestos touch fluidos (arrastar com 1 dedo para transladar / desenhar, pinça com 2 dedos para zoom), menu lateral retrátil em smartphones e alta legibilidade em telas 4K.
- 📖 **Guia Teórico & Deduções Integrado**: Demonstrações analíticas completas formatadas em KaTeX abrangendo epiciclos de Fourier, integrais de área de Green, dinâmica de impedância de rede e síntese DFT.

---

## 🔬 Formulação Matemática & Técnica

### 1. Série de Epiciclos Complexos

Uma trajetória planar no espaço $\mathbb{C} \cong \mathbb{R}^2$ é modelada como a superposição de fasores rotativos:

$$
z(t) = v(t) + j \cdot i(t) = \sum_{k \in \mathcal{K}} c_k e^{(\sigma_k + j \cdot k \cdot \omega_0) t}
$$

onde $c_k = r_k e^{j\theta_k}$, $k \in \mathbb{Z}$ representa a ordem do harmônico e $\omega_0 = 2\pi / T_0$ é a frequência angular fundamental.

### 2. Período de Fechamento & Ressonância

Para trajetórias sem amortecimento ($\sigma_k = 0$), a órbita se fecha periodicamente se e somente se as razões de frequência forem racionais:

$$
T_{\text{cycle}} = \frac{2\pi}{\omega_0 \cdot \gcd(k_1, k_2, \dots, k_N)}
$$

### 3. Área Orientada Delimitada pelo Teorema de Green

Através do teorema de Green e da ortogonalidade complexa, a área delimitada é calculada analiticamente em forma fechada:

$$
\mathcal{A} = \oint_\gamma v \, di = \frac{1}{2j} \oint_\gamma (\bar{z} \, dz - z \, d\bar{z}) = \pi \sum_{k} k |c_k|^2 = \pi \sum_k k r_k^2
$$

Cada braço harmônico contribui com uma área orientada independente proporcional à sua ordem $k$ e ao quadrado do raio $r_k^2$.

### 4. Impedância de Rede no Ponto de Acoplamento Comum (PCC)

A deformação de tensão originada pelas correntes harmônicas que fluem pela impedância $Z_{\text{grid}}(k) = R_g + j \cdot k\omega_0 L_g$ satisfaz:

$$
v_{\text{pcc}}(t) = v_{\text{grid}}(t) - R_g i(t) - L_g \frac{di(t)}{dt}
$$

A área do laço no plano $(v, i)$ é proporcional à potência reativa $\mathcal{Q} = \frac{\omega_0}{\pi} \mathcal{A}$.

### 5. Transformada Discreta de Fourier (DFT) Planar

Ao desenhar uma curva na tela, os pontos amostrados $\{z_n = x_n + j y_n\}_{n=0}^{N-1}$ são transformados em epiciclos via DFT complexa:

$$
c_k = \frac{1}{N} \sum_{n=0}^{N-1} (x_n + j y_n) \exp\left( -j \frac{2\pi k n}{N} \right), \quad k \in [-K_{\max}, K_{\max}]
$$

---

🚀 **Experimente o LissajouZ gratuitamente agora mesmo em [lissajouz.jeduapf.com](https://lissajouz.jeduapf.com)!**

---

`#Lissajous` `#Epiciclos` `#SeriesDeFourier` `#EspacoDeFase` `#EngenhariaEletrica` `#ImpedanciaDeRede` `#DFT` `#Harmonicas` `#ProcessamentoDeSinais` `#KaTeX` `#VisualizacaoDeDados` `#Vite`