{{
  config(
    materialized = 'table',
    schema = 'silver'
  )
}}

-- Split compound prd_key into cat_id and a clean prd_key.
-- Standardize prd_line values.
-- Default null prd_cost to 0.
-- Derive prd_end_dt from the next prd_start_dt of the same product (SCD Type 2).
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_')             AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key))                     AS prd_key,
    prd_nm,
    COALESCE(prd_cost, 0)                                    AS prd_cost,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END                                                      AS prd_line,
    CAST(prd_start_dt AS DATE)                               AS prd_start_dt,
    CAST(
        DATEADD(
            day, -1,
            LEAD(prd_start_dt) OVER (
                PARTITION BY prd_key
                ORDER BY prd_start_dt ASC
            )
        ) AS DATE
    )                                                        AS prd_end_dt,
    CURRENT_TIMESTAMP()                                      AS dwh_create_date
FROM {{ source('bronze_crm', 'crm_prd_info') }}