{{ config(severity='warn') }}

select order_id, order_amount, paid_amount, net_paid_amount
from {{ ref('fct_orders') }}
where is_confirmed and paid_amount > order_amount
