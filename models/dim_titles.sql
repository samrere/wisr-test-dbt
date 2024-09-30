{{ config(materialized='table') }}

SELECT 
    ROW_NUMBER() OVER (order by title_id) AS title_skey,
    title_id,
    title,
    CURRENT_TIMESTAMP() AS _write_time
FROM {{ source('raw', 'titles') }}
