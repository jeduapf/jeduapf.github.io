---
layout: default
permalink: /power/
title: Power Calculator
nav: true
nav_order: 6
---

<h2>Power for test of Equality of Quantiles</h2>

<form id="power-form">
  <label>Probability (p): <input type="number" id="prob" step="any" required></label><br>
  <label>Difference (d): <input type="number" id="diff" step="any" required></label><br>
  <label>Total sample Size (n): <input type="number" id="sample-size" required></label><br>
  <label>Rate of control arm: <input type="number" id="rate-control" step="any" required></label><br>
  <label>Rate of censoring: <input type="number" id="rate-cens" step="any" required></label><br>
  <label>Significance Level (alpha): <input type="number" id="alpha" step="any" required></label><br>
  <button type="submit">Calculate Power</button>
</form>

<p id="result"></p>

<script>
  function normCDF(x) {
    return (1 - Math.erf(-x / Math.sqrt(2))) / 2;
  }

    function expo_pdf(x, lambda) {
    return lambda*Math.exp(-lambda*x);
  }

   function normSInv(p) {
    // Inverse CDF of standard normal
    return Math.sqrt(2) * inverseErf(2 * p - 1);
  }

  function inverseErf(x) {
    // Approximate inverse error function
    let a = 0.147;
    let ln = Math.log(1 - x * x);
    let term1 = 2 / (Math.PI * a) + ln / 2;
    let term2 = ln / a;
    return Math.sign(x) * Math.sqrt(Math.sqrt(term1 * term1 - term2) - term1);
  }

  document.getElementById("power-form").addEventListener("submit", function(e) {
    e.preventDefault();

    const prob = parseFloat(document.getElementById("prob").value);
    const n = parseFloat(document.getElementById("sample-size").value);
    const rateC = parseFloat(document.getElementById("rate-control").value);
    const diff = parseFloat(document.getElementById("diff").value);
    const rateCens = parseFloat(document.getElementById("rate-cens").value);
    const alpha = parseFloat(document.getElementById("alpha").value);

    const z_alpha = Math.abs(normSInv(1 - alpha));
    const quantC = -Math.log(1-prob)/rateC;
    const rateE = -Math.log(1-prob)/(quantC - diff);
    const quantE = quantC - diff;
    const phiC = rateC/(rateC+rateCens) * (Math.exp((rateC+rateCens)*quantC) - 1);
    const phiE = rateE/(rateE+rateCens) * (Math.exp((rateE+rateCens)*quantE) - 1);
    const sigma2 = Math.pow(1 - prob, 2) * (phiC/((1/2)*expo_pdf(quantC, rateC)) +  phiE/((1/2)*expo_pdf(quantE, rateE)) );
    const z_critical = normSInv(1 - alpha / 2);
    const power = 1-normCDF(z_critical - Math.sqrt(n)*diff/(Math.sqrt(sigma2 )) +  normCDF(-z_critical - Math.sqrt(n)*diff/(Math.sqrt(sigma2 )) ;

    document.getElementById("result").innerText = "Estimated Power: " + (power * 100).toFixed(2) + "%";
  });

  // Approximation of inverse normal CDF
  function normSInv(p) {
    const a1 = -39.696830, a2 = 220.946098, a3 = -275.928510;
    const b1 = -54.476098, b2 = 161.585836, b3 = -155.698979;
    const c1 = 0.00048204;
    let x = p - 0.5, r;

    if (Math.abs(x) < 0.42) {
      r = x * x;
      return x * (((a3 * r + a2) * r + a1) * r + 1) /
                 ((((b3 * r + b2) * r + b1) * r + 1));
    }

    r = p < 0.5 ? p : 1 - p;
    r = Math.sqrt(-Math.log(r));
    r = (((c1 * r + 2.515517) * r + 0.802853) * r + 0.010328) /
        (((1.432788 * r + 0.189269) * r + 0.001308) * r + 1);
    return p < 0.5 ? -r : r;
  }
</script>
