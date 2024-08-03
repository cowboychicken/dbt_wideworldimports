with stg_customers as (
    select
        *
    from {{source('sales', 'customers')}}
),

stg_customer_categories as (
    select
        *
    from {{source('sales', 'customer_categories')}}
),

stg_buying_groups as (
    select
        *
    from {{source('sales', 'buying_groups')}}
),

stg_delivery_methods as (
    select
        *
    from {{source('application', 'delivery_methods')}}
),

stg_people as (
    select
        *
    from {{source('application', 'people')}}
),

stg_cities as (
    select
        *
    from {{source('application', 'cities')}}
),

stg_state_provinces as (
    select
        *
    from {{source('application', 'state_provinces')}}
),

stg_countries as (
    select
        *
    from {{source('application', 'countries')}}
)

select
    {{ dbt_utils.generate_surrogate_key(['stg_customers.customer_id'])}} as customer_key,
    stg_customers.customer_id,
    stg_customers.customer_name,
    stg_customer_categories.customer_category_name as customer_category,
    stg_buying_groups.buying_group_name as buying_group,
    stg_people_1.full_name as primary_contact_person,
    stg_people_1.email_address as primary_contact_person_email,
    stg_people_2.full_name as alternate_contact_person,
    stg_people_2.email_address as alternate_contact_person_email,
    stg_delivery_methods.delivery_method_name as delivery_method,
    stg_customers.delivery_address_line_1,
    stg_customers.delivery_address_line_2,
    stg_customers.delivery_postal_code,
    stg_cities_1.city_name as delivery_city,
    stg_state_provinces_1.state_province_name as delivery_state,
    stg_countries_1.country_name    as delivery_country,
    stg_countries_1.region as delivery_country_region,
    stg_countries_1.subregion as delivery_country_subregion,
    stg_customers.website_url,
    stg_people_3.full_name as last_edited_by

from stg_customers
left join stg_customer_categories on stg_customers.customer_category_id = stg_customer_categories.customer_category_id
left join stg_buying_groups on stg_customers.buying_group_id = stg_buying_groups.buying_group_id
left join stg_delivery_methods on stg_customers.delivery_method_id = stg_delivery_methods.delivery_method_id
left join stg_people as stg_people_1 on stg_customers.primary_contact_person_id = stg_people_1.person_id
left join stg_people as stg_people_2 on stg_customers.alternate_contact_person_id = stg_people_2.person_id
left join stg_people as stg_people_3 on stg_customers.last_edited_by = stg_people_3.person_id
left join stg_cities as stg_cities_1 on stg_customers.delivery_city_id = stg_cities_1.city_id
left join stg_state_provinces as stg_state_provinces_1 on stg_cities_1.state_province_id = stg_state_provinces_1.state_province_id
left join stg_countries as stg_countries_1 on stg_state_provinces_1.country_id = stg_countries_1.country_id