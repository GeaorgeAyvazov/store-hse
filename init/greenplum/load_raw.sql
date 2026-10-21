create schema if not exists raw;

create table if not exists raw.customers (
    customer_id integer,
    registered_at timestamp,
    city text,
    acquisition_channel text
) distributed by (customer_id);

create table if not exists raw.products (
    product_id integer,
    category text,
    brand text,
    product_name text
) distributed by (product_id);

create table if not exists raw.product_categories (
    category_id integer,
    parent_category_id integer,
    category_name text
) distributed by (category_id);

create table if not exists raw.orders (
    order_id integer,
    customer_id integer,
    order_created_at timestamp,
    status text,
    total_amount numeric(12, 2)
) distributed by (order_id);

create table if not exists raw.order_items (
    order_id integer,
    product_id integer,
    quantity integer,
    unit_price numeric(12, 2),
    discount_amount numeric(12, 2)
) distributed by (order_id);

create table if not exists raw.payments (
    payment_id integer,
    order_id integer,
    paid_at timestamp,
    payment_status text,
    amount numeric(12, 2)
) distributed by (order_id);
