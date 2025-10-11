---
layout: page
title: Projets
lang: fr
key: projects
permalink: /fr/projects/
translations:
  en: /en/projects/
  pt: /pt/projects/
description: Une collection de quelques projets intéressants.
nav: false
nav_order: 2
display_categories: [travail, cool]
horizontal: false
---

<!-- pages/projects.md -->
<div class="projects">
{%- assign lang_projects = site.projects | where: "lang", page.lang -%}

{%- if site.enable_project_categories and page.display_categories %}
  <!-- Exibir projetos categorizados -->
  {%- for category in page.display_categories %}
  <h2 class="category">{{ category }}</h2>
  {%- assign categorized_projects = lang_projects | where: "category", category -%}
  {%- assign sorted_projects = categorized_projects | sort: "importance" %}
  <!-- Gerar cards para cada projeto -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for project in sorted_projects -%}
      {% include projects_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for project in sorted_projects -%}
      {% include projects.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
  {% endfor %}

{%- else -%}
<!-- Exibir projetos sem categorias -->
  {%- assign sorted_projects = lang_projects | sort: "importance" -%}
  <!-- Gerar cards para cada projeto -->
  {% if page.horizontal -%}
  <div class="container">
    <div class="row row-cols-2">
    {%- for project in sorted_projects -%}
      {% include projects_horizontal.html %}
    {%- endfor %}
    </div>
  </div>
  {%- else -%}
  <div class="grid">
    {%- for project in sorted_projects -%}
      {% include projects.html %}
    {%- endfor %}
  </div>
  {%- endif -%}
{%- endif -%}
</div>
