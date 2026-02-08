# Hevo Customer Success Engineer – Technical Assessment

## Overview

This project demonstrates an end-to-end data pipeline using PostgreSQL → Hevo → Snowflake → dbt, built as part of the Hevo Customer Success Engineer technical assessment.
The objective was to ingest data from a self-hosted PostgreSQL database using Logical Replication, load it into Snowflake, and model a customer-level analytical table using dbt with proper testing.

## Architecture

Source → Ingestion → Warehouse → Transformations
PostgreSQL (Docker, Logical Replication)
        ↓
      Hevo
        ↓
   Snowflake (PC_HEVODATA_DB)
        ↓
      dbt

## Source Data

Three CSV files were loaded into PostgreSQL as raw tables:
- raw_customers.csv
- raw_orders.csv
- raw_payments.csv
These were ingested into Snowflake via Hevo as:
- PG_RAW_CUSTOMERS
- PG_RAW_ORDERS
- PG_RAW_PAYMENTS

## Hevo Pipeline
- Source: PostgreSQL (self-hosted)
- Destination: Snowflake
- Ingestion Mode: Logical Replication (CDC)

## Important Note on CDC
Since Logical Replication captures only changes after pipeline creation, only newly inserted records were replicated for the orders table.

## dbt Models
### Staging Models
- stg_customers
- stg_orders
- stg_payments

### Mart Model – customers

### Column	              ### Description
customer_id	        Unique customer identifier
first_name	        Derived from customer name
last_name	        Derived from customer name
first_order	        Earliest order date
most_recent_order	Latest order date
number_of_orders	Count of customer orders
customer_lifetime_value	Total monetary value

## Assumption 
The raw_payments dataset does not contain an amount column.
Therefore, customer_lifetime_value is calculated using the amount field from orders, which is the only available monetary value in the dataset.

This assumption is explicitly documented and no synthetic data was introduced.

## dbt Tests

The project includes both source-level and model-level tests.
### Source Tests
PG_RAW_ORDERS.order_id → not_null
PG_RAW_ORDERS.customer_id → not_null

### Model Tests
customers.customer_id → not_null
customers.customer_id → unique

All tests pass successfully.

## Key Learnings

- Demonstrated understanding of CDC via Logical Replication
- Handled schema mismatches between documentation and actual data
- Avoided fabricating data and documented assumptions transparently
- Built analytics models with correct grain and testing

## How to Run the Project
### Prerequisites

- Access to Snowflake
- dbt installed locally with the Snowflake adapter
- Hevo pipeline already configured and running (PostgreSQL → Snowflake via Logical Replication)

⚠️ Note: Data ingestion is handled by Hevo. This project focuses on transformations and modeling using dbt.

### Step 1: Configure dbt Profile
Ensure your profiles.yml is correctly configured for Snowflake with:
- Account
- User
- Role
- Warehouse
- Database: PC_HEVODATA_DB
- Schema: ANALYTICS
Authentication can be password-based or key-pair based (as supported by Snowflake).

### Step 2: Verify dbt Connection
From the dbt project root directory:
dbt debug
This confirms:
Snowflake connectivity
Credentials and permissions
Profile configuration

### Step 3: Run dbt Models
Execute all staging and mart models:
dbt run

This will:
Read raw tables created by Hevo in PC_HEVODATA_DB.PUBLIC
Create transformed models in PC_HEVODATA_DB.ANALYTICS
Materialize the customers table

### Step 4: Run dbt Tests
Run data quality tests:
dbt test

This executes:
Source tests (not-null checks on raw tables)
Model tests (not-null and uniqueness checks on customers.customer_id)

## Output
After successful execution, the following objects will be available in Snowflake:
### Staging Views
- ANALYTICS.STG_CUSTOMERS
- ANALYTICS.STG_ORDERS
- ANALYTICS.STG_PAYMENTS

### Mart Table
- ANALYTICS.CUSTOMERS
