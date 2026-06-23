# Telco Database Management & Analysis Simulation

This project is a backend database simulation designed to replicate how a telecommunications service provider manages customer profiles, subscription tariffs, and monthly usage records. 

## 🚀 Project Overview

The main objective of this project is to simulate real-world telecom data operations, maintain data integrity, and perform business-critical usage analysis using structured SQL queries.

## 🛠️ Tech Stack & Architecture

*   **Database Engine:** Oracle SQL
*   **Environment:** Containerized using **Docker** for clean deployment and portability.
*   **Data Scale:** Populated with a synthetic dataset of **10,000+ records** to simulate performance under realistic loads.

## 📊 Database Schema

The relational database architecture consists of three core tables:
1.  **TARIFFS:** Stores plan definitions, monthly fees, and limits (Data, Voice, SMS).
2.  **CUSTOMERS:** Manages personal customer data and links them to their active tariffs.
3.  **MONTHLY_STATS:** Tracks actual real-time usage metrics and monthly billing/payment statuses.

## 🔍 Analytical Features & Queries

The project focuses on extracting actionable insights through specialized SQL queries, including:
*   **High-Usage Monitoring:** Automatically identifying customers who have consumed **75% or more of their monthly data limits** (simulating trigger points for automated customer notifications).
*   **Financial Pattern Analysis:** Analyzing the distribution of payment statuses across different tariff tiers to track revenue metrics.
*   **Data Integrity Checks:** Utilizing complex joins to ensure accurate billing records and zero data mismatch.

## ⚙️ How to Run

1. Make sure you have **Docker** installed on your system.
2. Clone this repository.
3. Run the containerized Oracle SQL environment (Insert your specific docker-compose or docker run commands here).
4. Execute the schema script to create tables and populate the 10,000 records.
