{{ config(distributed_replicated=true) }}

{% set bounds_sql %}
    select
        min(order_date)::text as start_date,
        (max(order_date) + 1)::text as end_date
    from {{ ref('stg_shop__orders') }}
{% endset %}

{% if execute %}
    {% set bounds = run_query(bounds_sql) %}
    {% set start_date = bounds.columns[0].values()[0] or '1970-01-01' %}
    {% set end_date = bounds.columns[1].values()[0] or '1970-01-02' %}
{% else %}
    {% set start_date = '1970-01-01' %}
    {% set end_date = '1970-01-02' %}
{% endif %}

with dates as (
    {{ dbt_utils.date_spine(
        datepart='day',
        start_date="cast('" ~ start_date ~ "' as date)",
        end_date="cast('" ~ end_date ~ "' as date)"
    ) }}
)

select
    date_day::date as date_day,
    extract(year from date_day)::integer as year,
    extract(quarter from date_day)::integer as quarter,
    extract(month from date_day)::integer as month,
    extract(day from date_day)::integer as day_of_month,
    extract(isodow from date_day)::integer as day_of_week,
    extract(isodow from date_day) in (6, 7) as is_weekend
from dates
where date_day::date <= (select max(order_date) from {{ ref('stg_shop__orders') }})
