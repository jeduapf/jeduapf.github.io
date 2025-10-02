---
layout: default
permalink: /power/
title: power calculator
nav: true
nav_order: 7
---

<h2>power for test of equality of quantiles</h2>

Power calculator based on the test of equality of quantiles as described in the paper ["Univariate and multivariate tests of equality of quantiles with right-censored data"](https://arxiv.org/abs/2505.03234).
This calculator assumes exponential distributions for control and censoring times, with balanced groups.  
You can choose the model type: *Proportional hazards* (exponential experimental arm), and *Nonproportional hazards with late treatment effects* (piecewise exponential experimental arm).

Enter your parameters and click **Calculate Power** to view the analytical power alongside the survival curves :)

<p>Choose model type:</p>
<button onclick="setModel('exponential')">Proportional</button>
<button onclick="setModel('piecewise')">Nonproportional</button>
<p>Current model: <span id="model-type">Exponential</span></p>

<form id="power-form">
  <label>Probability: <input type="number" id="prob" step="any" required></label><br>
  <label>Difference: <input type="number" id="diff" step="any" required></label><br>
  <label>Total Sample Size: <input type="number" id="sample-size" required></label><br>
  <label>Rate of Control Arm: <input type="number" id="rate-control" step="any" required></label><br>
  <label>Rate of Censoring: <input type="number" id="rate-cens" step="any" required></label><br>
  <label>Significance Level (alpha): <input type="number" id="alpha" step="any" required></label><br>
  <div id="piecewise-options" style="display:none">
    <label>Time Cutoff (tcut): <input type="number" id="tcut" step="any"></label><br>
  </div>
  <button type="submit">Calculate Power</button>
</form>

<p id="result"></p>

<canvas id="survival-chart" width="800" height="400"></canvas>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.4.0/dist/chartjs-plugin-annotation.min.js"></script>

{% raw %}
<script>
let model = 'exponential';
function setModel(m) {
  model = m;
  document.getElementById("model-type").innerText = m.charAt(0).toUpperCase() + m.slice(1);
  document.getElementById("piecewise-options").style.display = (m === 'piecewise') ? 'block' : 'none';
}

function normCDF(x) {
  var sign = x < 0 ? -1 : 1;
  x = Math.abs(x) / Math.sqrt(2);
  var a1 = 0.254829592, a2 = -0.284496736, a3 = 1.421413741,
      a4 = -1.453152027, a5 = 1.061405429, p = 0.3275911;
  var t = 1 / (1 + p * x);
  var y = 1 - (((((a5 * t + a4) * t) + a3) * t + a2) * t + a1) * t * Math.exp(-x * x);
  return 0.5 * (1 + sign * y);
}

function expo_pdf(x, lambda) {
  return lambda * Math.exp(-lambda * x);
}

function piecewise_pdf(x, rateC, rateE, tcut) {
  if (x <= tcut) {
    return rateC * Math.exp(-rateC * x);
  } else {
    const s_tcut = Math.exp(-rateC * tcut);
    return rateE * s_tcut * Math.exp(-rateE * (x - tcut));
  }
}

function inverseErf(x) {
  let a = 0.147;
  let ln = Math.log(1 - x * x);
  let term1 = 2 / (Math.PI * a) + ln / 2;
  let term2 = ln / a;
  return Math.sign(x) * Math.sqrt(Math.sqrt(term1 * term1 - term2) - term1);
}

function normSInv(p) {
  return Math.sqrt(2) * inverseErf(2 * p - 1);
}

Chart.register(window['chartjs-plugin-annotation']);

window.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("power-form");
  form.addEventListener("submit", function(e) {
    e.preventDefault();

    const p = parseFloat(document.getElementById("prob").value);
    const n = parseFloat(document.getElementById("sample-size").value);
    const rateC = parseFloat(document.getElementById("rate-control").value);
    const diff = parseFloat(document.getElementById("diff").value);
    const rateCens = parseFloat(document.getElementById("rate-cens").value);
    const alpha = parseFloat(document.getElementById("alpha").value);
    const tcut = model === 'piecewise' ? parseFloat(document.getElementById("tcut").value) : null;

    const z_critical = Math.abs(normSInv(1 - alpha / 2));

    const quantC = -Math.log(1 - p) / rateC;

    let rateE, quantE, phiE;

    if (model === 'exponential') {
      rateE = -Math.log(1 - p) / (quantC - diff);
      quantE = quantC - diff;
      phiE = rateE / (rateE + rateCens) * (Math.exp((rateE + rateCens) * quantE) - 1);
    } else {
      if (quantC - tcut <= diff) {
        alert("quantC - tcut must be > diff in piecewise model.");
        return;
      }
      const boundary = 1 - Math.exp(-rateC * tcut);
      rateE = (Math.log(1 - p) + rateC * tcut) / (tcut + diff - quantC);
      quantE = (p < boundary)
        ? -Math.log(1 - p) / rateC
        : tcut - ((Math.log(1 - p) + rateC * tcut) / rateE);
      phiE = (rateC / (rateC + rateCens)) * (Math.exp((rateC + rateCens) * tcut) - 1) +
             (rateE / (rateE + rateCens)) * Math.exp((rateC - rateE) * tcut) *
             (Math.exp((rateE + rateCens) * quantE) - Math.exp((rateE + rateCens) * tcut));
    }

    const phiC = rateC / (rateC + rateCens) * (Math.exp((rateC + rateCens) * quantC) - 1);

    let sigma2;
    if (model === 'exponential') {
      sigma2 = Math.pow(1 - p, 2) * (
        phiC / (0.5 * Math.pow(expo_pdf(quantC, rateC), 2)) +
        phiE / (0.5 * Math.pow(expo_pdf(quantE, rateE), 2))
      );
    } else {
      sigma2 = Math.pow(1 - p, 2) * (
        phiC / (0.5 * Math.pow(expo_pdf(quantC, rateC), 2)) +
        phiE / (0.5 * Math.pow(piecewise_pdf(quantE, rateC, rateE, tcut), 2))
      );
    }

    if (isNaN(sigma2) || sigma2 <= 0) {
       alert("Error: invalid parameters.");
      return;
    }

      if (prob <= 0 || prob >= 1) {
      alert("Probability must be between 0 and 1 (exclusive).");
      return;
    }
    if (n <= 0) {
      alert("Sample size must be positive.");
      return;
    }
    if (alpha <= 0 || alpha >= 1) {
      alert("Alpha must be between 0 and 1.");
      return;
    }
    if (rateC < 0 || rateCens < 0) {
      alert("Rates must be non-negative.");
      return;
    }
    if (rateE < 0) {
      alert("Parameters not valid.");
      return;
    }

    const se = Math.sqrt(sigma2 / n);
    const power = 1 - normCDF(z_critical - diff / se) + normCDF(-z_critical - diff / se);

    document.getElementById("result").innerText =
      isNaN(power) ? "Error: invalid calculation." : `Estimated Power: ${(power * 100).toFixed(2)}%`;

    const timeMax = quantC * 1.5;
    const timePoints = Array.from({ length: 100 }, (_, i) => +(timeMax * i / 99).toFixed(2));
    const survivalC = timePoints.map(t => Math.exp(-rateC * t));
    const survivalE = model === 'exponential'
      ? timePoints.map(t => Math.exp(-rateE * t))
      : timePoints.map(t => (t <= tcut ? Math.exp(-rateC * t) : Math.exp(-rateC * tcut) * Math.exp(-rateE * (t - tcut))));

    const ctx = document.getElementById("survival-chart").getContext("2d");
    if (window.survivalChartInstance) window.survivalChartInstance.destroy();
    window.survivalChartInstance = new Chart(ctx, {
      type: "line",
      data: {
        labels: timePoints,
        datasets: [
          { label: "Control Arm", data: survivalC, borderColor: "limegreen", fill: false, tension: 0.3, borderWidth: 2 },
          { label: "Experimental Arm", data: survivalE, borderColor: "darkgreen", fill: false, tension: 0.3, borderWidth: 2 }
        ]
      },
      options: {
        responsive: true,
        plugins: {
          title: { display: true, text: "Survival Functions", font: { size: 18 } },
          legend: { labels: { font: { size: 14 } } },
          annotation: {
            annotations: {
              hLine: {
                type: 'line',
                yMin: 1 - p,
                yMax: 1 - p,
                borderColor: 'green',
                borderWidth: 2,
                borderDash: [6, 6],
                label: {
                  content: `1 - p = ${(1 - p).toFixed(2)}`,
                  enabled: true,
                  position: 'start',
                  backgroundColor: 'rgba(0,0,0,0.7)',
                  color: '#fff',
                  font: { style: 'italic' }
                }
              }
            }
          }
        },
        scales: {
          x: { title: { display: true, text: "Time", font: { size: 16 } } },
          y: {
            min: 0, max: 1,
            title: { display: true, text: "Survival Probability", font: { size: 16 } },
            ticks: { stepSize: 0.2, callback: val => val.toFixed(1) }
          }
        }
      }
    });
  });
});
</script>
{% endraw %}
