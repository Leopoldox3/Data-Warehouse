/*
===============================================================================
Script: 01_load_bronze.sql (MySQL)
Layer : BRONZE (Source CSV -> Bronze Tables)
===============================================================================
Purpose:
Cargar datos “raw” (tal cual vienen) desde archivos CSV a las tablas BRONZE.
En BRONZE no transformamos ni limpiamos: solo ingesta + validación básica.

What it does:
1) Desactiva autocommit e inicia una transacción.
2) TRUNCATE de tablas BRONZE (full refresh).
3) LOAD DATA LOCAL INFILE para cargar CSVs en tablas.
4) COMMIT al finalizar.
5) Validación final: muestra el conteo de filas por tabla (1 result set).

Notes:
- Este script usa nombres fully-qualified (bronze.tabla) para no depender
del “database” activo en la conexión de DBeaver.
- LOCAL INFILE significa que los CSV están en tu máquina (Mac) y el driver
los envía al servidor MySQL.
- Si tus CSV vienen con saltos de línea tipo Mac/Linux, prueba cambiar:
LINES TERMINATED BY '\r\n'  -->  '\n'

Usage:
- Abrir este archivo en DBeaver
- Ejecutar con: Execute Script (Alt + X)
===============================================================================
*/

-- ---------------------------------------------------------------------------
-- Transaction control
-- ---------------------------------------------------------------------------
SET autocommit = 0;

START TRANSACTION;

-- ===========================================================================
-- CRM SOURCE (cust_info, prd_info, sales_details)
-- ===========================================================================
-- Full refresh: borramos todo y recargamos desde CSV

-- ---------------------------------------------------------------------------
-- Table: bronze.crm_cust_info
-- Source: datasets/source_crm/cust_info.csv
-- ---------------------------------------------------------------------------
TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' INTO
TABLE bronze.crm_cust_info CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- ---------------------------------------------------------------------------
-- Table: bronze.crm_prd_info
-- Source: datasets/source_crm/prd_info.csv
-- ---------------------------------------------------------------------------
TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' INTO
TABLE bronze.crm_prd_info FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- ---------------------------------------------------------------------------
-- Table: bronze.crm_sales_details
-- Source: datasets/source_crm/sales_details.csv
-- ---------------------------------------------------------------------------
TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' INTO
TABLE bronze.crm_sales_details FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- ===========================================================================
-- ERP SOURCE (PX_CAT_G1V2, LOC_A101, CUST_AZ12)
-- ===========================================================================
-- Full refresh: borramos todo y recargamos desde CSV

-- ---------------------------------------------------------------------------
-- Table: bronze.erp_px_cat_g1v2
-- Source: datasets/source_erp/PX_CAT_G1V2.csv
-- ---------------------------------------------------------------------------
TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' INTO
TABLE bronze.erp_px_cat_g1v2 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- ---------------------------------------------------------------------------
-- Table: bronze.erp_loc_a101
-- Source: datasets/source_erp/LOC_A101.csv
-- ---------------------------------------------------------------------------
TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' INTO
TABLE bronze.erp_loc_a101 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- ---------------------------------------------------------------------------
-- Table: bronze.erp_cust_az12
-- Source: datasets/source_erp/CUST_AZ12.csv
-- ---------------------------------------------------------------------------
TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' INTO
TABLE bronze.erp_cust_az12 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

-- ---------------------------------------------------------------------------
-- Commit changes
-- ---------------------------------------------------------------------------
COMMIT;

-- ===========================================================================
-- Validation: row counts (single result set)
-- ===========================================================================
SELECT 'bronze.crm_cust_info' AS table_name, (
        SELECT COUNT(*)
        FROM bronze.crm_cust_info
    ) AS rows_loaded
UNION ALL
SELECT 'bronze.crm_prd_info', (
        SELECT COUNT(*)
        FROM bronze.crm_prd_info
    )
UNION ALL
SELECT 'bronze.crm_sales_details', (
        SELECT COUNT(*)
        FROM bronze.crm_sales_details
    )
UNION ALL
SELECT 'bronze.erp_px_cat_g1v2', (
        SELECT COUNT(*)
        FROM bronze.erp_px_cat_g1v2
    )
UNION ALL
SELECT 'bronze.erp_loc_a101', (
        SELECT COUNT(*)
        FROM bronze.erp_loc_a101
    )
UNION ALL
SELECT 'bronze.erp_cust_az12', (
        SELECT COUNT(*)
        FROM bronze.erp_cust_az12
    );