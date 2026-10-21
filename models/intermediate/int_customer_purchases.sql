with confirmed_orders as (
    select
        order_id,
        customer_id,
        ordered_at,
        order_amount,
        row_number() over (
            partition by customer_id
            order by ordered_at, order_id
        ) as purchase_number
    from {{ ref('int_orders_with_payments') }}
    where is_confirmed and not is_test_order
)

select
    customer_id,
    max(case when purchase_number = 1 then order_id end) as first_confirmed_order_id,
    min(ordered_at) as first_confirmed_at,
    count(*) as confirmed_orders_count,
    sum(order_amount) as confirmed_revenue
from confirmed_orders
group by customer_id
