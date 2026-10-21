{{ config(distributed_by='order_id', orientation='column') }}

select
    items.order_item_id,
    items.order_id,
    items.product_id,
    orders.customer_id,
    orders.order_date,
    items.quantity,
    items.unit_price,
    items.discount_amount,
    items.line_amount,
    orders.order_status,
    orders.is_confirmed
from {{ ref('stg_shop__order_items') }} as items
join {{ ref('int_orders_with_payments') }} as orders
    on items.order_id = orders.order_id
where not orders.is_test_order
