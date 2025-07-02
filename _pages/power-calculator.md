---
layout: default
permalink: /power/
title: power calculator
nav: true
nav_order: 7
---

<h2>power for test of equality of quantiles</h2>

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

<canvas id="survivalChart" style="max-width:600px; max-height:400px;"></canvas>

{% raw %}
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<script src="https://cdn.jsdelivr.net/npm/chartjs-plugin-annotation@1.1.0/dist/chartjs-plugin-annotation.min.js"></script>

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

window.addEventListener("DOMContentLoaded", function () {
  const form = document.getElementById("power-form");
  const ctx = document.getElementById("survivalChart").getContext("2d");

  // Initialize empty chart first
  let survivalChart = new Chart(ctx, {
    type: 'line',
    data: {
      labels: [], 
      datasets: [
        {
          label: 'Survival Control',
          borderColor: 'blue',
          fill: false,
          data: []
        },
        {
          label: 'Survival Experimental',
          borderColor: 'red',
          fill: false,
          data: []
        }
      ]
    },
    options: {
      scales: {
        x: {
          title: { display: true, text: 'Time' },
          min: 0,
          max: 10
        },
        y: {
          title: { display: true, text: 'Survival Probability' },
          min: 0,
          max: 1,
          ticks: { stepSize: 0.1 }
        }
      },
      plugins: {
        annotation: {
          annotations: {
            line1: {
              type: 'line',
              yMin: 0, yMax: 1,
              xMin: 0, xMax: 10,
              borderColor: 'green',
              borderWidth: 2,
              label: {
                content: '',
                enabled: true,
                position: 'start',
                backgroundColor: 'green',
                color: 'white',
                font: { weight: 'bold' }
              }
            }
          }
        }
      }
    },
  });

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
      (phiC / ((1 / 2) * Math.pow(expo_pdf(quantC, rateC),2)) +
       phiE / ((1 / 2) * Math.pow(expo_pdf(quantE, rateE),2) ));

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

    // Plot survival functions from time=0 to 10 (you can adjust max time)
    const maxTime = 10;
    const steps = 100;
    const timePoints = [];
    const survivalControl = [];
    const survivalExp = [];

    for(let i = 0; i <= steps; i++) {
      const t = (i / steps) * maxTime;
      timePoints.push(t);
      survivalControl.push(Math.exp(-rateC * t));
      survivalExp.push(Math.exp(-rateE * t));
    }

    // Update the chart data
    survivalChart.data.labels = timePoints;
    survivalChart.data.datasets[0].data = survivalControl;
    survivalChart.data.datasets[1].data = survivalExp;

    // Update horizontal line annotation at y = 1 - p with label '1 - p'
    survivalChart.options.plugins.annotation.annotations.line1.yMin = 1 - prob;
    survivalChart.options.plugins.annotation.annotations.line1.yMax = 1 - prob;
    survivalChart.options.plugins.annotation.annotations.line1.label.content = `1 - p = ${(1 - prob).toFixed(2)}`;

    survivalChart.update();
  });
});
</script>
{% endraw %}
