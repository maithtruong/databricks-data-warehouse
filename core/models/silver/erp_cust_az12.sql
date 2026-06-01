{{
  config(
    materialized = 'table',
    schema = 'silver'
  )
}}

-- Strip NAS prefix from cid values to align with cst_key format.
-- Nullify future birth dates.
-- Standardize gender values.
SELECT
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4)
        ELSE cid
    END                         AS cid,

    CASE
        WHEN bdate > CURRENT_DATE() THEN NULL
        ELSE bdate
    END                         AS bdate,

    CASE
        WHEN TRIM(gen) IS NULL OR TRIM(gen) = '' THEN 'n/a'
        WHEN TRIM(gen) = 'F'                     THEN 'Female'
        WHEN TRIM(gen) = 'M'                     THEN 'Male'
        ELSE TRIM(gen)
    END                         AS gen,

    CURRENT_TIMESTAMP()         AS dwh_create_date

FROM {{ source('bronze_erp', 'erp_cust_az12') }}