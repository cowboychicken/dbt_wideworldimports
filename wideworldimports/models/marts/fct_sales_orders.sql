with stg_orders as (
    select
        *
    from {{source('sales', 'orders')}}
),

stg_order_lines as (
    select
        *
    from {{source('sales', 'order_lines')}}
),

stg_stock_items as (
    select
        stock_item_id,
        supplier_id
    from {{source('warehouse', 'stock_items')}}
)

select
    {{dbt_utils.generate_surrogate_key(['stg_order_lines.order_id', 'order_line_id'])}} as sales_order_key,
    stg_order_lines.order_id,
    stg_order_lines.order_line_id,
    {{dbt_utils.generate_surrogate_key(['stg_orders.customer_id'])}} as customer,
    {{dbt_utils.generate_surrogate_key(['stg_order_lines.stock_item_id'])}} as product,
    {{dbt_utils.generate_surrogate_key(['stg_orders.salesperson_person_id'])}} as sales_person,
    {{dbt_utils.generate_surrogate_key((['stg_stock_items.supplier_id']))}} as supplier,
    stg_order_lines.quantity,
    stg_order_lines.unit_price,
    stg_order_lines.description,
    stg_orders.customer_purchase_order_number,
    stg_orders.order_date,
    stg_orders.expected_delivery_date
from stg_order_lines
left join stg_orders on stg_order_lines.order_id=stg_orders.order_id
left join stg_stock_items on stg_order_lines.stock_item_id=stg_stock_items.stock_item_id