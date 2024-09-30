{{ config(materialized='table') }}

SELECT 
    ROW_NUMBER() OVER (order by emp_no) AS emp_skey,
    emp_no,
    first_name,
    last_name,
    birth_date,
    sex,
    CURRENT_TIMESTAMP() AS _write_time
FROM {{ source('raw', 'employees') }}
