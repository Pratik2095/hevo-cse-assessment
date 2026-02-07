with src as (
    select
        payment_id,
        order_id,
        payment_method,
        status,
        payment_date
    from {{ source('hevo_pg', 'PG_RAW_PAYMENTS') }}
)

select * from src

