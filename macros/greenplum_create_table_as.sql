{% macro postgres__create_table_as(temporary, relation, sql) %}
    {% set distributed_by = config.get('distributed_by') %}
    {% set replicated = config.get('distributed_replicated', false) %}
    {% set orientation = config.get('orientation') %}
    {% if distributed_by and replicated %}
        {{ exceptions.raise_compiler_error('Choose distributed_by or distributed_replicated') }}
    {% endif %}

    {{ config.get('sql_header', '') or '' }}
    create {% if temporary %}temporary{% endif %} table {{ relation }}
    {% if orientation == 'column' %}
        with (appendoptimized=true, orientation=column)
    {% endif %}
    as ({{ sql }})
    {% if replicated %}
        distributed replicated
    {% elif distributed_by %}
        distributed by ({{ adapter.quote(distributed_by) }})
    {% else %}
        distributed randomly
    {% endif %}
    ;
{% endmacro %}
