---
layout: default
permalink: /power/
title: power Calculator
nav: true
nav_order: 6
---

<h2>power for test of equality of quantiles</h2>

<form id="power-form">
  <label>Probability (p): <input type="number" id="prob" step="any" required></label><br>
  <label>Difference (d): <input type="number" id="diff" step="any" required></label><br>
  <label>Total Sample Size (n): <input type="number" id="sample-size" required></label><br>
  <label>Rate of Control Arm: <input type="number" id="rate-control" step="any" required></label><br>
  <label>Rate of Censoring: <input type="number" id="rate-cens" step="any" required></label><br>
  <label>Significance Level (alpha): <input type="number" id="alpha" step="any" required></label><br>
  <button type="submit">Calculate Power</button>
</form>

<p id="result"></p>

{% raw %}
<script>
  function normCDF(x) {
    return (1 - Math.erf(-x / Math.sqrt(2))) / 2;
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
    document.getElementById("power-form").addEventListener("submit", function(e) {
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
        (phiC / ((1 / 2) * expo_pdf(quantC, rateC)) +
         phiE / ((1 / 2) * expo_pdf(quantE, rateE)));

      const se = Math.sqrt(sigma2 / n);

      const power =
        1 - normCDF(z_critical - diff / se) +
            normCDF(-z_critical - diff / se);

      console.log("Power computed:", power);

      if (isNaN(power)) {
        document.getElementById("result").innerText = "Error: invalid calculation.";
      } else {
        document.getElementById("result").innerText =
          "Estimated Power: " + (power * 100).toFixed(2) + "%";
      }
    });
  });
</script>
{% endraw %}
