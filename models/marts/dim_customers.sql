{{ config(distributed_replicated=true) }}

select
    customers.customer_id,
    customers.registered_at,
    customers.registration_date,
    customers.city,
    customers.acquisition_channel,
    purchases.first_confirmed_order_id,
    purchases.first_confirmed_at,
    coalesce(purchases.confirmed_orders_count, 0) as confirmed_orders_count,
    coalesce(purchases.confirmed_revenue, 0) as confirmed_revenue,
    coalesce(purchases.confirmed_orders_count, 0) > 0 as is_buyer
from {{ ref('stg_shop__customers') }} as customers
left join {{ ref('int_customer_purchases') }} as purchases
    on customers.customer_id = purchases.customer_id
