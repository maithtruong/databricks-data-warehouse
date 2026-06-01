{{
  config(
    materialized = 'table',
    schema = 'silver'
  )
}}

-- Convert integer date columns (yyyyMMdd) to DATE, nullifying invalid values.
-- Recalculate sls_sales, sls_quantity, and sls_price where they are internally inconsistent.
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    -- Date conversions
    CASE
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE TO_DATE(CAST(sls_order_dt AS STRING), 'yyyyMMdd')
    END AS sls_order_dt,

    CASE
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE TO_DATE(CAST(sls_ship_dt AS STRING), 'yyyyMMdd')
    END AS sls_ship_dt,

    CASE
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE TO_DATE(CAST(sls_due_dt AS STRING), 'yyyyMMdd')
    END AS sls_due_dt,

    -- Derive a consistent price first, then use it to fix sales and quantity
    CASE
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE ABS(sls_price)
    END AS sls_price,

    -- Fix sls_sales: if qty * price gives correct sales, keep; else recalculate
    CASE
        WHEN sls_sales IS NULL
          OR sls_sales <= 0
          OR sls_sales != sls_quantity * (
                CASE WHEN sls_price IS NULL OR sls_price <= 0
                     THEN sls_sales / NULLIF(sls_quantity, 0)
                     ELSE ABS(sls_price) END
             )
        THEN sls_quantity * (
                CASE WHEN sls_price IS NULL OR sls_price <= 0
                     THEN sls_sales / NULLIF(sls_quantity, 0)
                     ELSE ABS(sls_price) END
             )
        ELSE sls_sales
    END AS sls_sales,

    sls_quantity,

    CURRENT_TIMESTAMP() AS dwh_create_date

FROM {{ source('bronze_crm', 'crm_sales_details') }}