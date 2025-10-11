---
layout: page
permalink: /pt/repositories/
title: GitHub
lang: pt
key: repositories
translations:
  en: /en/repositories/
  fr: /fr/repositories/
description: Uma visão geral rápida das minhas contribuições open-source.
nav: false
nav_order: 3
---

## Usuários do GitHub

{% if site.data.repositories.github_users %}
<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for user in site.data.repositories.github_users %}
    {% include repository/repo_user.html username=user %}
  {% endfor %}
</div>
{% endif %}

---

## Repositórios do GitHub

{% if site.data.repositories.github_repos %}
<div class="repositories d-flex flex-wrap flex-md-row flex-column justify-content-between align-items-center">
  {% for repo in site.data.repositories.github_repos %}
    {% include repository/repo.html repository=repo %}
  {% endfor %}
</div>
{% endif %}
