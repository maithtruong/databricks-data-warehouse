{{
  config(
    materialized = 'table',
    schema = 'silver'
  )
}}

-- Remove null ids, deduplicate by keeping the newest version per (cst_key, cst_id),
-- trim string columns, and standardize marital status and gender values.
SELECT
    cst_id,
    cst_key,
    TRIM(cst_firstname)                          AS cst_firstname,
    TRIM(cst_lastname)                           AS cst_lastname,
    CASE UPPER(TRIM(cst_marital_status))
        WHEN 'S' THEN 'Single'
        WHEN 'M' THEN 'Married'
        ELSE 'n/a'
    END                                          AS cst_marital_status,
    CASE UPPER(TRIM(cst_gndr))
        WHEN 'F' THEN 'Female'
        WHEN 'M' THEN 'Male'
        ELSE 'n/a'
    END                                          AS cst_gndr,
    cst_create_date,
    CURRENT_TIMESTAMP()                          AS dwh_create_date
FROM (
    SELECT
        *,
        RANK() OVER (
            PARTITION BY cst_key, cst_id
            ORDER BY cst_create_date DESC
        ) AS ver_rank
    FROM {{ source('bronze_crm', 'crm_cust_info') }}
    WHERE cst_id IS NOT NULL
) t
WHERE ver_rank = 1