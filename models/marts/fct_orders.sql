SELECT
    o.order_id,
    o.customer_id,
    o.order_date,
    p.payment_id,
    p.payment_method,
    p.status
FROM {{ ref('stg_orders') }} o
LEFT JOIN {{ ref('stg_payments') }} p
    ON o.order_id = p.order_id
