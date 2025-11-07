---
layout: page
title: Restaurant System
description: A local full-stack restaurant system hosted over Wi-Fi, built for speed, simplicity, and privacy.
img: assets/img/zeco_simple.png
lang: en
importance: 1
category: fun
---

## Introduction

This project aims to build a **complete restaurant management system** that runs entirely on a **local Wi-Fi network (LAN)**.  
When a client sits down, they can scan a **QR code** printed on their table, if they don't want, the waiter can do it for them and bring a paper menu instead.  
The QR code automatically connects to the local web app and encodes the **table ID**, allowing the system to know which table is placing the order, no internet required.

Everything — from the backend to the web menu — runs **inside the restaurant’s private local network**.

---

## System Overview

### 🖥️ Backend (API)

A lightweight backend (FastAPI) serves as the core of the system, hosted locally on a mini-PC or central computer connected to the restaurant’s router.

It manages:
- Tables, orders, and menus  
- Staff authentication  
- Communication between clients, waiters, and the kitchen  
- Storage via an internal database (SQLite for the moment)

---

### 🍽️ Frontend for Clients

Clients access the menu through their browser after scanning the QR code (or paper menu if asked)
The system automatically loads the correct table and displays a modern, mobile-friendly web interface where clients can:
- Browse dishes  
- Customize options  
- Place orders directly  

No need to install an app, everything runs instantly through the LAN.

---

### 👨‍🍳 Real-Time Communication

To make communication faster and smoother, the system uses **WebSockets** between:
- The waiters’ devices (phones or tablets)  
- The kitchen display  

This ensures instant updates: as soon as an order is placed, the kitchen sees it immediately, and when it’s ready, the waiter gets notified in real time without reloading pages.

---

### 🧩 Easy Deployment with Docker

Everything is containerized using **Docker** for simplicity.  
The restaurant owner just needs to:
1. Install Docker on a local computer or small server.  
2. Run one command (`docker-compose up`).  
3. The system automatically sets up:
   - Backend API  
   - WebSocket server  
   - Database  
   - Frontend web app  

The goal is to make installation **as easy as plugging in a coffee machine** ☕ fully automated and ready to go.

---

## 🧩 Database Schema (ER Diagram)

Below is the complete **Entity–Relationship Diagram** showing how users, orders, and items connect — including analytical extensions like costs, promotions, and inventory logs.

<div class="mermaid">
erDiagram
    %% === USERS ===
    USERS {
        int id PK
        string username UK
        string hashed_password
        string email UK
        int age
        bool gender "nullable"
        enum role "admin, kitchen, client, waiter"
        int table_id FK "nullable"
    }

    %% === TABLES ===
    TABLES {
        int id PK
        int number UK "physical table number"
        int capacity
        enum status "available, occupied, reserved, cleaning"
        enum location_zone "indoor, outdoor, terrace, bar, vip"
        datetime reservation_start "nullable"
    }

    %% === BASIC ITEMS ===
    BASIC_ITEMS {
        int id PK
        string name
        float stock
        string unit "kg, liters, pieces"
        float base_cost
        float tax_rate
        datetime expiration_date
        datetime last_updated
        int last_updated_by FK
        text description "nullable"
    }

    %% === MENU ITEMS ===
    MENU_ITEMS {
        int id PK
        string name UK
        float price
        int stock
        enum category "entry, main_course, dessert, beverage"
        bool available
        datetime created_at
        text description "nullable"
    }

    %% === MENU ITEM COMPONENTS ===
    MENU_ITEM_COMPONENTS {
        int menu_item_id PK,FK
        int basic_item_id PK,FK
        float quantity_required
    }

    %% === ORDERS ===
    ORDERS {
        int id PK
        int user_id FK "nullable for guest orders"
        int table_id FK
        enum status "pending, confirmed, preparing, ready, served, completed, cancelled"
        datetime created_at
        datetime finished_at "nullable"
        text specifications "nullable"
        float total_amount
        float discount_applied
        enum payment_method "cash, card, mobile, voucher, pending"
        string promo_code FK "nullable"
        int num_customers "number of people for this order"
    }

    %% === ORDER ITEMS ===
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

    %% === INVENTORY LOGS ===
    INVENTORY_LOGS {
        int id PK
        int user_id FK
        int item_id FK
        datetime timestamp
        float stock_change
        enum reason "initial_stock, restock, sale, waste, theft, correction, return, sample"
        string notes "nullable"
    }

    %% === STAFF SHIFTS ===
    STAFF_SHIFTS {
        int id PK
        int user_id FK
        datetime shift_start
        datetime shift_end
        enum role "waiter, kitchen"
    }

    %% === DAILY LOGS ===
    DAILY_LOGS {
        int id PK
        date log_date UK
        int total_customers
        float total_revenue
        float total_expenses
        float worked_time
    }

    %% === MONTHLY OVERVIEW ===
    MONTHLY_OVERVIEW {
        int id PK
        date month_start "e.g., 2025-11-01"
        string category "revenue, food_cost, staff_cost, electricity, rent, taxes, etc."
        float amount "positive for income, negative for expense"
        text notes "optional"
    }

    %% === MONTHLY ITEM STATS ===
    MONTHLY_ITEM_STATS {
        int id PK
        int menu_item_id FK
        date month_start
        int quantity_sold
        float revenue_generated
        float total_item_cost
        float avg_margin
    }

    %% === RELATIONSHIPS ===
    USERS ||--o{ ORDERS : "places/manages"
    TABLES ||--o{ USERS : "seats"
    TABLES ||--o{ ORDERS : "serves at"

    ORDERS ||--|{ ORDER_ITEMS : "contains"
    MENU_ITEMS ||--o{ ORDER_ITEMS : "ordered as"

    MENU_ITEMS ||--|{ MENU_ITEM_COMPONENTS : "composed of"
    BASIC_ITEMS ||--o{ MENU_ITEM_COMPONENTS : "ingredient in"

    USERS ||--o{ BASIC_ITEMS : "last updated by"
    USERS ||--o{ INVENTORY_LOGS : "performs change"
    BASIC_ITEMS ||--o{ INVENTORY_LOGS : "tracked in"

    PROMOTIONS ||--o{ ORDERS : "applied to"

    DAILY_LOGS ||--o{ STAFF_SHIFTS : "includes staff shifts"
    DAILY_LOGS ||--o{ ORDERS : "summarizes orders of the day"

    MONTHLY_ITEM_STATS ||--|| MENU_ITEMS : "analyzes"
    MONTHLY_ITEM_STATS ||--|| MONTHLY_OVERVIEW : "belongs to month"
    DAILY_LOGS ||--o{ MONTHLY_OVERVIEW : "aggregated into"

</div>

---

## 🔄 System Dataflow

Below is the **request and role-based dataflow** for both public clients and authenticated users.

<div class="mermaid">
   flowchart TD
      %% === Public client flow ===
      subgraph GuestClient["Guest Client (no login)"]
         GC["Client (Guest)"] -->|"GET /menu"| PublicAPI
         GC -->|"POST /orders"| PublicAPI
      end

      %% === Unified Authenticated flow ===
      subgraph AuthFlow["Authenticated Users (Client or Staff)"]
         Login["User logs in (Client / Waiter / Kitchen / Admin) -> POST /token"] --> AuthEndpoint["Auth Endpoint"]
         AuthEndpoint --> UsersDB["Users Table"]
         AuthEndpoint --> JWT["JWT Token Created"]
         JWT --> API["Authenticated API (profile, orders, management, etc.)"]
         API --> RoleCheck["Role-based Access"]
         RoleCheck --> Client["Client: access personal data & order history"]
         RoleCheck --> Waiter["Waiter: manage orders & receive WS updates"]
         RoleCheck --> Kitchen["Kitchen: update order statuses"]
         RoleCheck --> Admin["Admin: manage menu & users"]
      end

      %% === Database ===
      DB["(Orders, Items, Tables, Users)"]
      SPDB["(Items, Tables)"]

      %% === Roles branching ===
      RoleCheck --> DB
      
      %% === Shared backend access ===
      PublicAPI --> SPDB
</div>

---

## 🔒 Security and Open Questions

Even though the system runs locally, several important security questions arise:

1. **Payment Integration:**  
   Should payments be handled within the same local system, or should they be **decoupled** (handled by an external terminal or service)?  
   - If decoupled, how can we securely record the payment status in the local database?  
   - Would an API endpoint for “payment success” be enough, or is a more robust protocol needed?  

2. **Network Isolation:**  
   Is it truly safe to host the backend on a local Wi-Fi network accessible to clients?  
   - Should the network be split into two VLANs, one for staff and one for customers?  
   - How can we prevent malicious access or API abuse if a client tries to inspect network traffic?

3. **Data Integrity and Reliability:**  
   What happens if the local server restarts during peak hours?  
   - Should there be automatic data backup or replication to a small cloud service?  
   - How to keep everything purely local but still safe?

4. **API Design:**  
   The API structure currently separates routes for `/products`, `/orders`, `/kitchen`, and `/waiters`.  
   - Is this modular structure appropriate, or should all roles share a common `/orders` endpoint with role-based filtering?  
   - How could WebSocket channels be organized? Per role, per table, or globally?  

I’d love to hear feedback from developers and system designers on these architectural and security choices.  
Your insights could help refine this concept into a production-ready, open-source solution for small restaurants. Thank you guys :D

---

## Source Code

👉 **[ZeCo Backend on GitHub](https://github.com/jeduapf/ZeCo)**
👉 **[ZeCo Dashboard on Streamlit](https://zecodashboarddcf.streamlit.app/)**

---

## Comments

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
        data-lang="en"
        data-loading="lazy"
        crossorigin="anonymous"
        async>
</script>

---

<div class="caption">
José ALVES, 2025.
</div>
