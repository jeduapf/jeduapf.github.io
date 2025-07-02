---
layout: default
permalink: /power/
title: power calculator
nav: true
nav_order: 7
---

<h2>power for test of equality of quantiles</h2>

Power calculator based on the test of equality of quantiles as described in the paper ["Univariate and multivariate tests of equality of quantiles with right-censored data"](https://arxiv.org/abs/2505.03234).
This calculator assumes exponential distributions for control, experimental, and censoring times, with balanced groups.  
Enter your parameters and click **Calculate Power** to view the analytical power alongside the survival curves :)


<form id="power-form">
  <label>Probability: <input type="number" id="prob" step="any" required></label><br>
  <label>Difference: <input type="number" id="diff" step="any" required></label><br>
  <label>Total Sample Size: <input type="number" id="sample-size" required></label><br>
  <label>Rate of Control Arm: <input type="number" id="rate-control" step="any" required></label><br>
  <label>Rate of Censoring: <input type="number" id="rate-cens" step="any" required></label><br>
  <label>Significance Level (alpha): <input type="number" id="alpha" step="any" required></label><br>
  <button type="submit">Calculate Power</button>
</form>

<p id="result"></p>

<canvas id="survival-chart" width="800" height="400"></canvas>

<!-- Chart.js and Annotation Plugin -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.4.0"></script>

{% raw %}
<script>
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

// Register the annotation plugin with Chart.js
Chart.register(window['chartjs-plugin-annotation']);

window.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("power-form");

  form.addEventListener("submit", function(e) {
    e.preventDefault();

    const prob = parseFloat(document.getElementById("prob").value);
    const n = parseFloat(document.getElementById("sample-size").value);
    const rateC = parseFloat(document.getElementById("rate-control").value);
    const diff = parseFloat(document.getElementById("diff").value);
    const rateCens = parseFloat(document.getElementById("rate-cens").value);
    const alpha = parseFloat(document.getElementById("alpha").value);

    const z_critical = Math.abs(normSInv(1 - alpha / 2));
    const quantC = -Math.log(1 - prob) / rateC;
    const rateE = -Math.log(1 - prob) / (quantC - diff);
    const quantE = quantC - diff;

    const phiC = rateC / (rateC + rateCens) * (Math.exp((rateC + rateCens) * quantC) - 1);
    const phiE = rateE / (rateE + rateCens) * (Math.exp((rateE + rateCens) * quantE) - 1);

    const sigma2 = Math.pow(1 - prob, 2) *
      (phiC / ((1 / 2) * Math.pow(expo_pdf(quantC, rateC), 2)) +
       phiE / ((1 / 2) * Math.pow(expo_pdf(quantE, rateE), 2)));

    const se = Math.sqrt(sigma2 / n);

    const power =
      1 - normCDF(z_critical - diff / se) +
          normCDF(-z_critical - diff / se);

    if (isNaN(power)) {
      document.getElementById("result").innerText = "Error: invalid calculation.";
    } else {
      document.getElementById("result").innerText =
        "Estimated Power: " + (power * 100).toFixed(2) + "%";
    }

    // --- Survival Function Plot ---
    const timeMax = quantC * 1.5; // extend a bit beyond quantile
    const timePoints = Array.from({ length: 100 }, (_, i) => +(timeMax * i / 99).toFixed(2)); // 2 decimals

    const survivalC = timePoints.map(t => Math.exp(-rateC * t));
    const survivalE = timePoints.map(t => Math.exp(-rateE * t));

    const ctx = document.getElementById("survival-chart").getContext("2d");

    // Destroy old chart if exists
    if (window.survivalChartInstance) {
      window.survivalChartInstance.destroy();
    }

    window.survivalChartInstance = new Chart(ctx, {
      type: "line",
      data: {
        labels: timePoints,
        datasets: [
          {
            label: "Control Arm",
            data: survivalC,
            borderColor: "blue",
            fill: false,
          },
          {
            label: "Experimental Arm",
            data: survivalE,
            borderColor: "red",
            fill: false,
          }
        ],
      },
      options: {
        responsive: true,
        plugins: {
          title: {
            display: true,
            text: "Survival Functions",
            font: { size: 18 }
          },
          legend: {
            labels: {
              font: { size: 14 }
            }
          },
          annotation: {
            annotations: {
              hLine: {
                type: 'line',
                yMin: 1 - prob,
                yMax: 1 - prob,
                borderColor: 'green',
                borderWidth: 2,
                borderDash: [6, 6],
                label: {
                  content: `1 - p = ${(1 - prob).toFixed(2)}`,
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
          x: {
            title: {
              display: true,
              text: "Time"
            },
            ticks: {
              callback: val => +val.toFixed(2)
            }
          },
          y: {
            min: 0,
            max: 1,
            title: {
              display: true,
              text: "Survival Probability"
            },
            ticks: {
              stepSize: 0.2,
              callback: val => val.toFixed(1)
            }
          }
        }
      }
    });
  });
});
</script>
{% endraw %}
