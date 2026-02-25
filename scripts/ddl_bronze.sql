-- =========================================
-- DDL Script: Create Bronze Tables (MySQL)
-- Drops and recreates bronze tables
-- =========================================

-- (Opcional) asegurar encoding por defecto de la sesión
SET NAMES utf8mb4;

DROP TABLE IF EXISTS bronze.crm_cust_info;

CREATE TABLE bronze.crm_cust_info (
    cst_id INT NULL,
    cst_key VARCHAR(50) NULL,
    cst_firstname VARCHAR(50) NULL,
    cst_lastname VARCHAR(50) NULL,
    cst_marital_status VARCHAR(50) NULL,
    cst_gndr VARCHAR(50) NULL,
    cst_create_date DATE NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS bronze.crm_prd_info;

CREATE TABLE bronze.crm_prd_info (
    prd_id INT NULL,
    prd_key VARCHAR(50) NULL,
    prd_nm VARCHAR(50) NULL,
    prd_cost INT NULL,
    prd_line VARCHAR(50) NULL,
    prd_start_dt DATETIME NULL,
    prd_end_dt DATETIME NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS bronze.crm_sales_details;

CREATE TABLE bronze.crm_sales_details (
    sls_ord_num VARCHAR(50) NULL,
    sls_prd_key VARCHAR(50) NULL,
    sls_cust_id INT NULL,
    sls_order_dt INT NULL,
    sls_ship_dt INT NULL,
    sls_due_dt INT NULL,
    sls_sales INT NULL,
    sls_quantity INT NULL,
    sls_price INT NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS bronze.erp_loc_a101;

CREATE TABLE bronze.erp_loc_a101 (
    cid VARCHAR(50) NULL,
    cntry VARCHAR(50) NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS bronze.erp_cust_az12;

CREATE TABLE bronze.erp_cust_az12 (
    cid VARCHAR(50) NULL,
    bdate DATE NULL,
    gen VARCHAR(50) NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;

DROP TABLE IF EXISTS bronze.erp_px_cat_g1v2;

CREATE TABLE bronze.erp_px_cat_g1v2 (
    id VARCHAR(50) NULL,
    cat VARCHAR(50) NULL,
    subcat VARCHAR(50) NULL,
    maintenance VARCHAR(50) NULL
) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;