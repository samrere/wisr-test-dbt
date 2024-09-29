{{ config(materialized='table') }}

SELECT 
    ROW_NUMBER() OVER (order by title_id) AS title_skey,
    title_id,
    title,
    CURRENT_DATE AS _write_date
FROM {{ source('raw', 'titles') }}
