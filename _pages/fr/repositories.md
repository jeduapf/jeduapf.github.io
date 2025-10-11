---
layout: page
permalink: /fr/repositories/
title: GitHub
key: repositories
description: Un aperçu rapide de mes contributions open-source.
nav: false
lang: fr
translations:
  en: /en/repositories/
  pt: /pt/repositories/
nav_order: 3
---

## Utilisateurs GitHub

{% if site.data.repositories.github_users %}
<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for user in site.data.repositories.github_users %}
    {% include repository/repo_user.html username=user %}
  {% endfor %}
</div>
{% endif %}

---

## Référentiels GitHub

{% if site.data.repositories.github_repos %}
<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for repo in site.data.repositories.github_repos %}
    {% include repository/repo.html repository=repo %}
  {% endfor %}
</div>
{% endif %}
