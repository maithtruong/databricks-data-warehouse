{{
  config(
    materialized = 'table',
    schema = 'silver'
  )
}}

-- Load category reference data as-is, then union any cat_ids present in
-- crm_prd_info that are missing here (handles outdated reference table).
SELECT
    id,
    cat,
    subcat,
    maintenance,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ source('bronze_erp', 'erp_px_cat_g1v2') }}

UNION ALL

-- Back-fill missing category ids discovered from the product table
SELECT DISTINCT
    p.cat_id    AS id,
    NULL        AS cat,
    NULL        AS subcat,
    NULL        AS maintenance,
    CURRENT_TIMESTAMP() AS dwh_create_date
FROM {{ ref('crm_prd_info') }} p
WHERE NOT EXISTS (
    SELECT 1
    FROM {{ source('bronze_erp', 'erp_px_cat_g1v2') }} t
    WHERE t.id = p.cat_id
)