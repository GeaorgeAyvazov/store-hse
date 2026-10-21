{{ config(distributed_by='order_id', orientation='column') }}

select
    orders.order_id,
    orders.customer_id,
    orders.order_date,
    orders.ordered_at,
    orders.order_status,
    orders.order_amount,
    orders.paid_amount,
    orders.refunded_amount,
    orders.net_paid_amount,
    orders.successful_payments_count,
    orders.first_paid_at,
    orders.is_confirmed,
    coalesce(items.items_count, 0) as items_count
from {{ ref('int_orders_with_payments') }} as orders
left join {{ ref('int_order_items_count') }} as items
    on orders.order_id = items.order_id
where not orders.is_test_order
