{{ config(distributed_replicated=true) }}

select
    products.product_id,
    products.product_name,
    products.brand,
    products.category_name,
    categories.parent_category_name,
    categories.root_category_name
from {{ ref('stg_shop__products') }} as products
left join {{ ref('int_product_categories') }} as categories
    on products.category_name = categories.category_name
