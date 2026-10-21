with source_revenue as (
    select coalesce(sum(orders.total_amount), 0) as revenue
    from {{ source('shop', 'orders') }} as orders
    where orders.status = 'paid'
      and exists (
          select 1
          from {{ source('shop', 'payments') }} as payments
          where payments.order_id = orders.order_id
            and payments.payment_status = 'success'
            and payments.amount >= 0
      )
),
mart_revenue as (
    select coalesce(sum(order_amount), 0) as revenue
    from {{ ref('fct_orders') }}
    where is_confirmed
)

select source_revenue.revenue as source_revenue, mart_revenue.revenue as mart_revenue
from source_revenue cross join mart_revenue
where source_revenue.revenue <> mart_revenue.revenue
