---
layout: page
title: Restaurant System
description: A local full-stack restaurant system hosted over Wi-Fi, built for speed, simplicity, and privacy.
img: assets/img/zeco_simple.png
lang: en
importance: 1
category: cool
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
- Storage via an internal database (SQLite inside a Docker container)

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

## 🗺️ System Architecture Illustration

*Diagram showing data flow between the client phone, waiter tablet, kitchen display, and local server.*

> **Suggested diagram:**  
> - Clients connect via Wi-Fi to the local server (QR code)  
> - Waiters and kitchen connect through WebSockets  
> - Central computer runs Docker stack and database  

![Architecture placeholder](assets/img/restaurant_system_architecture.png)

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

👉 **[ZeCo Backend on GitHub](https://github.com/jeduapf/ZeCo_backend)**

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
