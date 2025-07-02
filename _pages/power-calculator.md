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
  window.addEventListener("DOMContentLoaded", function () {
    const form = document.getElementById("power-form");
    console.log("Form element found:", form);
    form.addEventListener("submit", function(e) {
      e.preventDefault();
      console.log("Form submitted!");
      document.getElementById("result").innerText = "Button clicked and JS works!";
    });
  });
</script>
{% endraw %}
