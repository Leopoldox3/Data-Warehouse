DROP PROCEDURE IF EXISTS silver.load_silver;

DELIMITER $$

CREATE PROCEDURE silver.load_silver()
BEGIN

-- ----------------------------------------------------------------------------------------
-- LOAD CUSTOMER INFO
-- ----------------------------------------------------------------------------------------

INSERT INTO silver.crm_cust_info (
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    t.cst_id,
    t.cst_key,
    TRIM(t.cst_firstname) AS cst_firstname,
    TRIM(t.cst_lastname) AS cst_lastname,
    CASE
        WHEN UPPER(TRIM(t.cst_marital_status)) = 'S' THEN 'Single'
        WHEN UPPER(TRIM(t.cst_marital_status)) = 'M' THEN 'Married'
        ELSE 'n/a'
    END AS cst_marital_status,
    CASE
        WHEN UPPER(TRIM(t.cst_gndr)) = 'F' THEN 'Female'
        WHEN UPPER(TRIM(t.cst_gndr)) = 'M' THEN 'Male'
        ELSE 'n/a'
    END AS cst_gndr,
    t.cst_create_date
FROM (
    SELECT 
        b.*,
        ROW_NUMBER() OVER (
            PARTITION BY b.cst_id
            ORDER BY b.cst_create_date DESC
        ) AS flag_last
    FROM bronze.crm_cust_info b
    WHERE
        b.cst_id IS NOT NULL
        AND b.cst_create_date IS NOT NULL
        AND CAST(b.cst_create_date AS CHAR) <> '0000-00-00'
) t
WHERE t.flag_last = 1;

-- ----------------------------------------------------------------------------------------
-- LOAD PRODUCT INFO
-- ----------------------------------------------------------------------------------------

INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
    prd_id,
    REPLACE(SUBSTRING(prd_key,1,5),'-','_') AS cat_id, -- Extract category ID
    SUBSTRING(prd_key,7) AS prd_key, -- Extract product key
    prd_nm,
    prd_cost,
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a'
    END AS prd_line, -- Map product line codes
    DATE(prd_start_dt) AS prd_start_dt,
    DATE(
        LEAD(prd_start_dt) OVER (
            PARTITION BY prd_key
            ORDER BY prd_start_dt
        ) - INTERVAL 1 DAY
    ) AS prd_end_dt
FROM bronze.crm_prd_info
WHERE SUBSTRING(prd_key,7) IN (
    SELECT sls_prd_key
    FROM bronze.crm_sales_details
);

-- ----------------------------------------------------------------------------------------
-- LOAD SALES DETAILS
-- ----------------------------------------------------------------------------------------

TRUNCATE TABLE silver.crm_sales_details;

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    CASE
        WHEN sls_order_dt = 0 OR LENGTH(sls_order_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_order_dt,'%Y%m%d')
    END AS sls_order_dt,
    CASE
        WHEN sls_ship_dt = 0 OR LENGTH(sls_ship_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_ship_dt,'%Y%m%d')
    END AS sls_ship_dt,
    CASE
        WHEN sls_due_dt = 0 OR LENGTH(sls_due_dt) != 8 THEN NULL
        ELSE STR_TO_DATE(sls_due_dt,'%Y%m%d')
    END AS sls_due_dt,
    CASE
        WHEN sls_sales IS NULL
        OR sls_sales <= 0
        OR (
            sls_price IS NOT NULL
            AND sls_price > 0
            AND sls_sales != sls_quantity * ABS(sls_price)
        )
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    sls_quantity,
    CASE
        WHEN sls_price IS NULL
        OR sls_price <= 0 THEN sls_sales / NULLIF(sls_quantity,0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details;

-- ----------------------------------------------------------------------------------------
-- LOAD ERP CUSTOMER
-- ----------------------------------------------------------------------------------------

TRUNCATE TABLE silver.erp_cust_az12;

INSERT INTO silver.erp_cust_az12 (cid,bdate,gen)
SELECT
    CASE
        WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4)
        ELSE cid
    END AS cid,
    CASE
        WHEN bdate > NOW() THEN NULL
        ELSE bdate
    END AS bdate,
    CASE
        WHEN UPPER(TRIM(gen)) IN ('F','FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M','MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen
FROM bronze.erp_cust_az12;

-- ----------------------------------------------------------------------------------------
-- LOAD ERP LOCATION
-- ----------------------------------------------------------------------------------------

TRUNCATE TABLE silver.erp_loc_a101;

INSERT INTO silver.erp_loc_a101 (cid,cntry)
SELECT
    REPLACE(cid,'-','') cid,
    CASE
        WHEN TRIM(cntry) = 'DE' THEN 'Germany'
        WHEN TRIM(cntry) IN ('US','USA') THEN 'United States'
        WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
        ELSE TRIM(cntry)
    END AS cntry
FROM bronze.erp_loc_a101;

-- ----------------------------------------------------------------------------------------
-- LOAD PRODUCT CATEGORY
-- ----------------------------------------------------------------------------------------

TRUNCATE TABLE silver.erp_px_cat_g1v2;

INSERT INTO silver.erp_px_cat_g1v2 (id,cat,subcat,maintenance)
SELECT
    id,
    cat,
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;

END $$

DELIMITER;