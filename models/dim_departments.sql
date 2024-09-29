{{ config(materialized='table') }}

SELECT 
    row_number() over (order by dept_no) as dept_skey,
    dept_no,
    dept_name,
    CURRENT_TIMESTAMP() AS _write_time
FROM {{ source('raw', 'departments') }}
