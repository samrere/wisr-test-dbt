{{ 
  config(
    materialized = 'table'
  ) 
}}

SELECT 
    row_number() OVER (ORDER BY dept_no) AS dept_skey,
    dept_no,
    dept_name,
    CURRENT_TIMESTAMP() AS _write_time
FROM 
    {{ source('raw', 'departments') }}

