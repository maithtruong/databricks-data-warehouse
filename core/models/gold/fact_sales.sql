{{
  config(
    materialized = 'view',
    schema = 'gold'
  )
}}

SELECT
    sls_ord_num     AS order_number,
    t2.product_key,
    t3.customer_key,
    sls_order_dt    AS order_date,
    sls_ship_dt     AS ship_date,
    sls_due_dt      AS due_date,
    sls_sales       AS sales_amount,
    sls_quantity    AS quantity,
    sls_price       AS price

FROM {{ ref('crm_sales_details') }}     AS t1
LEFT JOIN {{ ref('dim_products') }}     AS t2 ON t1.sls_prd_key  = t2.product_number
LEFT JOIN {{ ref('dim_customers') }}    AS t3 ON t1.sls_cust_id  = t3.customer_id