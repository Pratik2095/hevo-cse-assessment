Hevo Customer Success Engineer – Technical Assessment
Overview

This project demonstrates an end-to-end data pipeline using PostgreSQL → Hevo → Snowflake → dbt, built as part of the Hevo Customer Success Engineer technical assessment.

The objective was to ingest data from a self-hosted PostgreSQL database using Logical Replication, load it into Snowflake, and model a customer-level analytical table using dbt with proper testing.

Architecture

Source → Ingestion → Warehouse → Transformations

PostgreSQL (Docker, Logical Replication)
        ↓
      Hevo
        ↓
   Snowflake (PC_HEVODATA_DB)
        ↓
      dbt

Source Data

Three CSV files were loaded into PostgreSQL as raw tables:

raw_customers.csv

raw_orders.csv

raw_payments.csv

These were ingested into Snowflake via Hevo as:

PG_RAW_CUSTOMERS

PG_RAW_ORDERS

PG_RAW_PAYMENTS

Hevo Pipeline

Source: PostgreSQL (self-hosted)

Destination: Snowflake

Ingestion Mode: Logical Replication (CDC)

Important Note on CDC

Since Logical Replication captures only changes after pipeline creation, only newly inserted records were replicated for the orders table.
This behavior is expected and correctly demonstrates CDC semantics.

dbt Models
Staging Models

stg_customers

stg_orders

stg_payments

These models standardize column names, data types, and prepare data for analytics.

Mart Model – customers

A materialized table built exactly as required in the assessment.

Columns and Logic
Column	Description
customer_id	Unique customer identifier
first_name	Derived from customer name
last_name	Derived from customer name
first_order	Earliest order date
most_recent_order	Latest order date
number_of_orders	Count of customer orders
customer_lifetime_value	Total monetary value
Assumption (Documented)

The raw_payments dataset does not contain an amount column.
Therefore, customer_lifetime_value is calculated using the amount field from orders, which is the only available monetary value in the dataset.

This assumption is explicitly documented and no synthetic data was introduced.

dbt Tests

The project includes both source-level and model-level tests.

Source Tests

PG_RAW_ORDERS.order_id → not_null

PG_RAW_ORDERS.customer_id → not_null

Model Tests

customers.customer_id → not_null

customers.customer_id → unique

All tests pass successfully.

How to Run the Project
Prerequisites

dbt (Snowflake adapter)

Access to Snowflake

Hevo pipeline already configured

Run Models
dbt run

Run Tests
dbt test

Key Learnings / Real-World Scenarios

Demonstrated understanding of CDC via Logical Replication

Handled schema mismatches between documentation and actual data

Avoided fabricating data and documented assumptions transparently

Built analytics models with correct grain and testing

Final Deliverables

dbt project committed to GitHub

Materialized customers table in Snowflake

dbt tests included and passing

Loom walkthrough video explaining:

Architecture

Hevo pipeline

Snowflake tables

dbt models and tests

Edge cases and assumptions

Submission Details

The submission email includes:

GitHub repository link

Loom video link

Hevo Team ID

Hevo Pipeline ID