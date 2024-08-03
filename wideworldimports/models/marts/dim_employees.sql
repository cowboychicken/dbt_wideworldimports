with stg_people as (
    select
        *
    from {{source('application', 'people')}}
) 

select
    {{dbt_utils.generate_surrogate_key(['stg_people_1.person_id'])}} as employee_key,
    stg_people_1.person_id as employee_id,
    stg_people_1.full_name,
    stg_people_1.is_employee,
    stg_people_1.is_salesperson,
    stg_people_1.email_address,
    stg_people_2.full_name as last_edited_by
from stg_people as stg_people_1
left join stg_people as stg_people_2 on stg_people_1.last_edited_by=stg_people_2.person_id
