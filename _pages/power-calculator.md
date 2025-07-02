---
layout: default
permalink: /power/
title: power calculator
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
  // Approximation of the standard normal CDF using the Abramowitz and Stegun formula
  var sign = x < 0 ? -1 : 1;
  x = Math.abs(x) / Math.sqrt(2);

  // Constants
  var a1 = 0.254829592,
      a2 = -0.284496736,
      a3 = 1.421413741,
      a4 = -1.453152027,
      a5 = 1.061405429,
      p = 0.3275911;

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
    console.log("Form element found: form-id: power-form");

    form.addEventListener("submit", function(e) {
      e.preventDefault();
      console.log("Form submitted!");

      const prob = parseFloat(document.getElementById("prob").value);
      const n = parseFloat(document.getElementById("sample-size").value);
      const rateC = parseFloat(document.getElementById("rate-control").value);
      const diff = parseFloat(document.getElementById("diff").value);
      const rateCens = parseFloat(document.getElementById("rate-cens").value);
      const alpha = parseFloat(document.getElementById("alpha").value);
      console.log({ prob, n, rateC, diff, rateCens, alpha });

      const z_critical = Math.abs(normSInv(1 - alpha / 2));
      const quantC = -Math.log(1 - prob) / rateC;
      const rateE = -Math.log(1 - prob) / (quantC - diff);
      const quantE = quantC - diff;
      console.log({ z_critical, quantC, rateE, quantE });

      const phiC = rateC / (rateC + rateCens) * (Math.exp((rateC + rateCens) * quantC) - 1);
      const phiE = rateE / (rateE + rateCens) * (Math.exp((rateE + rateCens) * quantE) - 1);
      console.log({ phiC, phiE });

      const sigma2 = Math.pow(1 - prob, 2) *
        (phiC / ((1 / 2) * Math.pow(expo_pdf(quantC, rateC),2)) +
         phiE / ((1 / 2) * Math.pow(expo_pdf(quantE, rateE),2) ));
      console.log("sigma2 =", sigma2);

      const se = Math.sqrt(sigma2 / n);
      console.log("se =", se);

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
