with item_totals as (
    select order_id, sum(line_amount) as line_amount
    from {{ ref('fct_order_items') }}
    group by order_id
)

select orders.order_id, orders.order_amount, items.line_amount
from {{ ref('fct_orders') }} as orders
full join item_totals as items on orders.order_id = items.order_id
where orders.order_id is null
   or items.order_id is null
   or orders.order_amount <> items.line_amount
