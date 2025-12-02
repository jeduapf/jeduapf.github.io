---
layout: page
title: Système de Restaurant
description: Un système de restaurant local full-stack hébergé sur Wi-Fi, conçu pour la rapidité, la simplicité et la confidentialité.
img: assets/img/zeco_simple.png
lang: fr
importance: 1
category: cool
---

## Introduction

Ce projet vise à créer un **système complet de gestion de restaurant** fonctionnant entièrement sur un **réseau Wi-Fi local (LAN)**. 

Lorsqu’un client s’installe, il peut scanner un **QR code** imprimé sur sa table ; s’il ne le souhaite pas, le serveur peut le faire pour lui et apporter un menu papier à la place.

Le QR code se connecte automatiquement à l’application web locale et encode l’**ID de la table**, permettant au système de savoir quelle table passe la commande, sans nécessiter Internet.

Tout — du backend au menu web — fonctionne **dans le réseau local privé du restaurant**.

---

## Aperçu du Système

### 🖥️ Backend (API)

Un backend léger (FastAPI) constitue le cœur du système, hébergé localement sur un mini-PC ou un ordinateur central connecté au routeur du restaurant.

Il gère :
- Les tables, commandes et menus  
- L’authentification du personnel  
- La communication entre clients, serveurs et cuisine  
- Le stockage via une base de données interne (SQLite pour le moment)

---

### 🍽️ Frontend pour Clients

Les clients accèdent au menu via leur navigateur après avoir scanné le QR code (ou via le menu papier si demandé).

Le système charge automatiquement la bonne table et affiche une interface web moderne et adaptée aux mobiles (React), où les clients peuvent :
- Parcourir les plats  
- Personnaliser les options  
- Passer directement leurs commandes  

Aucune installation d’application n’est nécessaire, tout fonctionne instantanément via le LAN.

---

### 👨‍🍳 Communication en Temps Réel

Pour rendre la communication plus rapide et fluide, le système utilise **WebSockets** entre :
- Les appareils des serveurs (téléphones ou tablettes)  
- L’écran de la cuisine  

Cela garantit des mises à jour instantanées : dès qu’une commande est passée, la cuisine la voit immédiatement, et lorsqu’elle est prête, le serveur est notifié en temps réel sans recharger les pages.

---

### 🧩 Déploiement Facile avec Docker

Tout est conteneurisé via **Docker** pour simplifier le déploiement.  

Le propriétaire du restaurant doit simplement :

1. Installer Docker sur un ordinateur local ou un petit serveur.  
2. Exécuter une commande (`docker-compose up`).  
3. Le système configure automatiquement :
   - L’API backend  
   - Le serveur WebSocket  
   - La base de données  
   - L’application web frontend 
4. Insérer les éléments du menu et les articles de base dans la base de données ainsi que les membres du personnel et les tables (les QR codes sont créés automatiquement).

L’objectif est de rendre l’installation **aussi simple que de brancher une machine à café** ☕ entièrement automatisée et prête à l’emploi.

---

## 🧩 Schéma de Base de Données (Diagramme ER)

Ci-dessous le **diagramme Entité–Relation complet** montrant comment les utilisateurs, commandes et articles sont connectés — y compris les extensions analytiques comme les coûts, promotions et journaux d’inventaire.

<div class="mermaid">
erDiagram
    %% === UTILISATEURS ===
    USERS {
        int id PK
        string username UK
        string hashed_password
        string email UK
        int age
        bool gender "nullable"
        enum role "admin, cuisine, client, serveur"
        int table_id FK "nullable"
    }

    %% === TABLES ===
    TABLES {
        int id PK
        int number UK "numéro physique de table"
        int capacity
        enum status "disponible, occupée, réservée, nettoyage"
        enum location_zone "intérieur, extérieur, terrasse, bar, vip"
        datetime reservation_start "nullable"
    }

    %% === ARTICLES DE BASE ===
    BASIC_ITEMS {
        int id PK
        string name
        float stock
        string unit "kg, litres, pièces"
        float base_cost
        float tax_rate
        datetime expiration_date
        datetime last_updated
        int last_updated_by FK
        text description "nullable"
    }

    %% === ARTICLES DU MENU ===
    MENU_ITEMS {
        int id PK
        string name UK
        float price
        int stock
        enum category "entrée, plat_principal, dessert, boisson"
        bool available
        datetime created_at
        text description "nullable"
    }

    %% === COMPOSANTS D’ARTICLE DU MENU ===
    MENU_ITEM_COMPONENTS {
        int menu_item_id PK,FK
        int basic_item_id PK,FK
        float quantity_required
    }

    %% === COMMANDES ===
    ORDERS {
        int id PK
        int user_id FK "nullable pour commandes invité"
        int table_id FK
        enum status "en_attente, confirmée, préparation, prête, servie, terminée, annulée"
        datetime created_at
        datetime finished_at "nullable"
        text specifications "nullable"
        float total_amount
        float discount_applied
        enum payment_method "espèces, carte, mobile, bon, en_attente"
        string promo_code FK "nullable"
        int num_customers "nombre de personnes pour cette commande"
    }

    %% === ARTICLES DE COMMANDE ===
    ORDER_ITEMS {
        int order_id PK,FK
        int item_id PK,FK
        int quantity
        float item_price
        float item_cost
    }

    %% === PROMOTIONS ===
    PROMOTIONS {
        int id PK
        string code UK
        text description
        float discount_percentage
        enum target_category "nullable"
        int target_menu_item "nullable"
        datetime start_date
        datetime end_date
    }

    %% === JOURNAUX D’INVENTAIRE ===
    INVENTORY_LOGS {
        int id PK
        int user_id FK
        int item_id FK
        datetime timestamp
        float stock_change
        enum reason "stock_initial, réapprovisionnement, vente, gaspillage, vol, correction, retour, échantillon"
        string notes "nullable"
    }

    %% === HORAIRES DU PERSONNEL ===
    STAFF_SHIFTS {
        int id PK
        int user_id FK
        datetime shift_start
        datetime shift_end
        enum role "serveur, cuisine"
    }

    %% === JOURNAUX QUOTIDIENS ===
    DAILY_LOGS {
        int id PK
        date log_date UK
        int total_customers
        float total_revenue
        float total_expenses
        float worked_time
    }

    %% === VUE MENSUELLE ===
    MONTHLY_OVERVIEW {
        int id PK
        date month_start "ex: 2025-11-01"
        string category "revenus, coût_alimentation, coût_personnel, électricité, loyer, taxes, etc."
        float amount "positif pour revenu, négatif pour dépense"
        text notes "optionnel"
    }

    %% === STATS MENSUELLES PAR ARTICLE ===
    MONTHLY_ITEM_STATS {
        int id PK
        int menu_item_id FK
        date month_start
        int quantity_sold
        float revenue_generated
        float total_item_cost
        float avg_margin
    }

    %% === RELATIONS ===
    USERS ||--o{ ORDERS : "passe/gère"
    TABLES ||--o{ USERS : "assoit"
    TABLES ||--o{ ORDERS : "sert à"

    ORDERS ||--|{ ORDER_ITEMS : "contient"
    MENU_ITEMS ||--o{ ORDER_ITEMS : "commandé en tant que"

    MENU_ITEMS ||--|{ MENU_ITEM_COMPONENTS : "composé de"
    BASIC_ITEMS ||--o{ MENU_ITEM_COMPONENTS : "ingrédient dans"

    USERS ||--o{ BASIC_ITEMS : "dernière mise à jour par"
    USERS ||--o{ INVENTORY_LOGS : "effectue le changement"
    BASIC_ITEMS ||--o{ INVENTORY_LOGS : "suivi dans"

    PROMOTIONS ||--o{ ORDERS : "appliqué à"

    DAILY_LOGS ||--o{ STAFF_SHIFTS : "comprend les horaires du personnel"
    DAILY_LOGS ||--o{ ORDERS : "résume les commandes du jour"

    MONTHLY_ITEM_STATS ||--|| MENU_ITEMS : "analyse"
    MONTHLY_ITEM_STATS ||--|| MONTHLY_OVERVIEW : "appartient au mois"
    DAILY_LOGS ||--o{ MONTHLY_OVERVIEW : "agrégé dans"

</div>

---

## 🔄 Flux de Données du Système

Ci-dessous le **flux de données basé sur les rôles et requêtes** pour les clients publics et utilisateurs authentifiés.

<div class="mermaid">
   flowchart TD
      %% === Flux client invité ===
      subgraph GuestClient["Client Invité (pas de login)"]
         GC["Client (Invité)"] -->|"GET /menu"| PublicAPI
         GC -->|"POST /orders"| PublicAPI
      end

      %% === Flux unifié authentifié ===
      subgraph AuthFlow["Utilisateurs Authentifiés (Client ou Personnel)"]
         Login["L'utilisateur se connecte (Client / Serveur / Cuisine / Admin) -> POST /token"] --> AuthEndpoint["Point d’authentification"]
         AuthEndpoint --> UsersDB["Table des Utilisateurs"]
         AuthEndpoint --> JWT["JWT Token créé"]
         JWT --> API["API Authentifiée (profil, commandes, gestion, etc.)"]
         API --> RoleCheck["Contrôle basé sur le rôle"]
         RoleCheck --> Client["Client : accès aux données personnelles & historique des commandes"]
         RoleCheck --> Waiter["Serveur : gérer les commandes & recevoir mises à jour WS"]
         RoleCheck --> Kitchen["Cuisine : mettre à jour le statut des commandes"]
         RoleCheck --> Admin["Admin : gérer le menu & les utilisateurs"]
      end

      %% === Base de données ===
      DB["(Commandes, Articles, Tables, Utilisateurs)"]
      SPDB["(Articles, Tables)"]

      %% === Branchements par rôle ===
      RoleCheck --> DB
     
      %% === Accès partagé backend ===
      PublicAPI --> SPDB
</div>

---

## 🔒 Sécurité et Questions Ouvertes

Même si le système fonctionne localement, plusieurs questions importantes de sécurité se posent :

1. **Intégration des Paiements :**  
   Les paiements doivent-ils être gérés dans le même système local ou **découplés** (traités par un terminal ou service externe) ? 
   - Si découpés, comment enregistrer en toute sécurité le statut du paiement dans la base locale ? 
   - Un point de terminaison API “paiement réussi” est-il suffisant, ou un protocole plus robuste est nécessaire ?  

2. **Isolation Réseau :**  
   Est-il vraiment sûr d’héberger le backend sur un réseau Wi-Fi local accessible aux clients ? 
   - Faut-il séparer le réseau en deux VLANs, un pour le personnel et un pour les clients ? 
   - Comment prévenir les accès malveillants ou abus d’API si un client tente d’inspecter le trafic réseau (attaque MITM) ?

3. **Intégrité et Fiabilité des Données :**  
   Que se passe-t-il si le serveur local redémarre aux heures de pointe ?  
   - Faut-il une sauvegarde automatique ou une réplication vers un petit service cloud ?  
   - Comment garder tout purement local tout en restant sécurisé ?

4. **Conception de l’API :**  
   La structure actuelle de l’API sépare les routes `/products`, `/orders`, `/kitchen` et `/waiters`.  
   - Cette structure modulaire est-elle appropriée ou tous les rôles devraient-ils partager un point `/orders` commun avec filtrage basé sur le rôle ?  
   - Comment organiser les canaux WebSocket ? Par rôle, par table ou globalement ?  

J’aimerais avoir des retours de développeurs et architectes système sur ces choix architecturaux et de sécurité.  
Vos idées pourraient aider à transformer ce concept en une solution open-source prête pour la production pour les petits restaurants. Merci à tous :D

---

## Code Source

👉 **[ZeCo Backend sur GitHub](https://github.com/jeduapf/ZeCo)**  
👉 **[ZeCo Dashboard sur Streamlit](https://zecodashboarddcf.streamlit.app/)**

---

## Commentaires

<div class="giscus"></div>

<script src="https://giscus.app/client.js"
        data-repo="jeduapf/jeduapf.github.io"
        data-repo-id="R_kgDOP6j8Zw"
        data-category="Ideas"
        data-category-id="DIC_kwDOP6j8Z84CxQe-"
        data-mapping="url"
        data-strict="0"
        data-reactions-enabled="1"
        data-emit-metadata="0"
        data-input-position="top"
        data-theme="preferred_color_scheme"
        data-lang="fr"
        data-loading="lazy"
        crossorigin="anonymous"
        async>
</script>

---

<div class="caption">
José ALVES, 2025.
</div>
