SELECT
    customer_id,
    name,
    email
FROM {{ ref('stg_customers') }}
