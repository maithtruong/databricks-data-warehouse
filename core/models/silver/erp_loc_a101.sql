{{
  config(
    materialized = 'table',
    schema = 'silver'
  )
}}

-- Remove hyphens from cid to align with cst_key format.
-- Standardize country values to consistent names.
SELECT
    REPLACE(cid, '-', '')           AS cid,

    CASE
        WHEN cntry IS NULL
          OR TRIM(cntry) = ''       THEN 'n/a'
        WHEN TRIM(cntry) = 'DE'     THEN 'Germany'
        WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
        ELSE TRIM(cntry)
    END                             AS cntry,

    CURRENT_TIMESTAMP()             AS dwh_create_date

FROM {{ source('bronze_erp', 'erp_loc_a101') }}