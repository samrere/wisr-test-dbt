{{ 
  config(
    materialized = 'table'
  ) 
}}

WITH source_data AS (
    SELECT
        emp_no,
        emp_title_id AS title_id,
        TO_NUMBER(TO_CHAR(hire_date, 'YYYYMMDD')) AS hire_date_key
    FROM {{ source('raw', 'employees') }}
),

-- Join with dim_employees, dim_departments, and dim_titles to get skey
emp_dept_title_dim AS (
    SELECT 
        emp_no,
        emp_skey,
        dept_skey,
        title_skey,
        hire_date_key
    FROM source_data
    JOIN {{ source("raw", 'dept_emp') }} USING (emp_no)
    JOIN {{ ref('dim_employees') }} USING (emp_no)
    JOIN {{ ref('dim_departments') }} USING (dept_no)
    JOIN {{ ref('dim_titles') }} USING (title_id)
),

-- Join with dept_manager to determine if the employee is a manager
manager AS (
    SELECT
        *,
        CASE WHEN m.emp_no IS NOT NULL THEN TRUE ELSE FALSE END AS is_manager
    FROM emp_dept_title_dim
    LEFT JOIN {{ source('raw', 'dept_manager') }} m USING (emp_no)
),

-- Join with salaries to get salary information
salary AS (
    SELECT 
        * 
    FROM manager 
    JOIN {{ source('raw', 'salaries') }} USING (emp_no)
)

-- Final fact table with surrogate keys, is_manager flag, and salary
SELECT
    emp_skey,
    dept_skey,
    title_skey,
    hire_date_key,
    is_manager,
    salary,
    CURRENT_TIMESTAMP() AS _write_time
FROM salary

