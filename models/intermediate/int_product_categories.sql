with recursive category_tree as (
    select
        category_id,
        parent_category_id,
        category_name,
        null::text as parent_category_name,
        category_name as root_category_name,
        array[category_id] as category_path
    from {{ ref('stg_shop__product_categories') }}
    where parent_category_id is null

    union all

    select
        child.category_id,
        child.parent_category_id,
        child.category_name,
        parent.category_name as parent_category_name,
        parent.root_category_name,
        parent.category_path || child.category_id
    from {{ ref('stg_shop__product_categories') }} as child
    join category_tree as parent
        on child.parent_category_id = parent.category_id
    where not child.category_id = any(parent.category_path)
)

select
    category_id,
    parent_category_id,
    category_name,
    parent_category_name,
    root_category_name
from category_tree
