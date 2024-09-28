{{ config(materialized='table') }}

SELECT 
    dept_no,
    dept_name,
    CURRENT_TIMESTAMP() AS _write_time
FROM {{ source('transformation_project', 'departments') }}
