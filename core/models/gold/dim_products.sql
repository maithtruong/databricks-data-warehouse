{{
  config(
    materialized = 'view',
    schema = 'gold'
  )
}}

-- Only the current (open-ended) version of each product is exposed in gold.
SELECT
    ROW_NUMBER() OVER (ORDER BY prd_start_dt, prd_key) AS product_key,
    prd_id          AS product_id,
    prd_key         AS product_number,
    prd_nm          AS product_name,
    cat_id          AS category_id,
    cat             AS category_name,
    subcat          AS subcategory_name,
    maintenance,
    prd_cost        AS product_cost,
    prd_line        AS product_line,
    prd_start_dt    AS start_date

FROM {{ ref('crm_prd_info') }}          AS t1
LEFT JOIN {{ ref('erp_px_cat_g1v2') }} AS t2 ON t1.cat_id = t2.id
WHERE prd_end_dt IS NULL