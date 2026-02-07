{{ config(materialized='table') }}

with customers as (
    select
        customer_id,
        -- split NAME into first_name + last_name (safe even if only one word)
        split_part(name, ' ', 1) as first_name,
        split_part(name, ' ', 2) as last_name
    from {{ source('hevo_pg', 'PG_RAW_CUSTOMERS') }}
),

orders as (
    select
        order_id,
        customer_id,
        order_date
    from {{ ref('stg_orders') }}
),

payments as (
    -- Payments table doesn't contain amount in this dataset,
    -- so CLV will be computed using order amount instead.
    select
        order_id
    from {{ source('hevo_pg', 'PG_RAW_PAYMENTS') }}
),


orders_agg as (
    select
        customer_id,
        min(order_date) as first_order,
        max(order_date) as most_recent_order,
        count(*)        as number_of_orders
    from orders
    group by customer_id
),

clv as (
    select
        o.customer_id,
        sum(o.amount) as customer_lifetime_value
    from {{ ref('stg_orders') }} o
    group by o.customer_id
)

select
    c.customer_id,
    c.first_name,
    c.last_name,
    oa.first_order,
    oa.most_recent_order,
    coalesce(oa.number_of_orders, 0) as number_of_orders,
    coalesce(cl.customer_lifetime_value, 0) as customer_lifetime_value
from customers c
left join orders_agg oa
    on c.customer_id = oa.customer_id
left join clv cl
    on c.customer_id = cl.customer_id

