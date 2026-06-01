{{
  config(
    materialized = 'view',
    schema = 'gold'
  )
}}

SELECT
    ROW_NUMBER() OVER (ORDER BY cst_id)     AS customer_key,
    cst_id                                  AS customer_id,
    cst_key                                 AS customer_number,
    cst_firstname                           AS first_name,
    cst_lastname                            AS last_name,
    cntry                                   AS country,
    cst_marital_status                      AS marital_status,
    -- Prefer CRM gender; fall back to ERP gender when CRM is unknown
    CASE
        WHEN gen      = 'n/a' AND cst_gndr != 'n/a' THEN cst_gndr
        WHEN cst_gndr = 'n/a' AND gen      != 'n/a' THEN gen
        ELSE cst_gndr
    END                                     AS gender,
    bdate                                   AS birth_date,
    cst_create_date                         AS create_date

FROM {{ ref('crm_cust_info') }}         AS t1
LEFT JOIN {{ ref('erp_cust_az12') }}    AS t2 ON t1.cst_key = t2.cid
LEFT JOIN {{ ref('erp_loc_a101') }}     AS t3 ON t1.cst_key = t3.cid