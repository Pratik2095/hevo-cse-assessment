select
    order_id,
    customer_id,
    order_date,
    amount
from {{ source('hevo_pg', 'PG_RAW_ORDERS') }}
