with src as (
    select
        customer_id,
        name,
        email,
        created_at
    from {{ source('hevo_pg', 'PG_RAW_CUSTOMERS') }}
)

select * from src
