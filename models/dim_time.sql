{{ config(materialized='table') }}


WITH date_range AS (
    SELECT 
        MIN(hire_date) AS start_date, 
        DATEADD(year, 5, CURRENT_DATE) AS end_date
    FROM {{ source('raw', 'employees') }}
),

date_series AS (
    SELECT 
        DATEADD(day, seq4(), (SELECT start_date FROM date_range)) AS full_date
    FROM table(generator(rowcount => 365 * 50))  -- Generate sufficient rows for ~50 years
    WHERE DATEADD(day, seq4(), (SELECT start_date FROM date_range)) <= (SELECT end_date FROM date_range)
)

SELECT
    TO_NUMBER(TO_CHAR(full_date, 'YYYYMMDD')) AS date_key,
    full_date,
    EXTRACT(year FROM full_date) AS year,
    EXTRACT(month FROM full_date) AS month,
    EXTRACT(day FROM full_date) AS day
FROM date_series
