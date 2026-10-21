select order_id, net_paid_amount
from {{ ref('fct_orders') }}
where order_status = 'returned' and net_paid_amount <> 0
