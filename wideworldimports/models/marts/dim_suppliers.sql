with stg_suppliers as (
    select
        *
    from {{source('purchasing', 'suppliers')}}
),

stg_supplier_categories as (
    select 
        *
    from {{source('purchasing', 'supplier_categories')}}
),

stg_people as (
    select
        *
    from {{source('application', 'people')}}
),

stg_delivery_methods as (
    select
        *
    from {{source('application', 'delivery_methods')}}
),

stg_cities as (
    select
        *
    from {{source('application', 'cities')}}
)

select
    {{dbt_utils.generate_surrogate_key(['stg_suppliers.supplier_id'])}} as supplier_key,
    stg_suppliers.supplier_id as id,
    stg_suppliers.supplier_name as supplier_name,
    stg_supplier_categories.supplier_category_name as category,
    stg_people_1.full_name as primary_contact_person,
    stg_people_2.full_name as alternate_contact_person,
    stg_delivery_methods.delivery_method_name as delivery_method,
    stg_cities_1.city_name as delivery_city,
    stg_suppliers.supplier_reference as reference,
    stg_people_3.full_name as last_edited_by
from stg_suppliers
left join stg_supplier_categories on stg_suppliers.supplier_category_id=stg_supplier_categories.supplier_category_id
left join stg_people as stg_people_1 on stg_suppliers.primary_contact_person_id=stg_people_1.person_id
left join stg_people as stg_people_2 on stg_suppliers.alternate_contact_person_id=stg_people_2.person_id
left join stg_people as stg_people_3 on stg_suppliers.last_edited_by=stg_people_3.person_id
left join stg_delivery_methods on stg_suppliers.delivery_method_id=stg_delivery_methods.delivery_method_id
left join stg_cities  as stg_cities_1 on stg_suppliers.delivery_city_id=stg_cities_1.city_id