with stg_stock_items as (
    select
        *
    from {{source('warehouse', 'stock_items')}}
)

select 
    {{dbt_utils.generate_surrogate_key(['stg_stock_items.stock_item_id'])}} as product_key,
    stg_stock_items.stock_item_id as id,
    stg_stock_items.stock_item_name as product_name
from stg_stock_items

