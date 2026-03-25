-- =========================================
-- 01_load_bronze.sql (MySQL)
-- Logs to bronze.etl_log (like PRINT)
-- =========================================

-- ----------------------------------------------------------------------------------------
-- START BATCH
-- ----------------------------------------------------------------------------------------

SET @batch_id = UUID();

SET @batch_start = NOW();

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'START',
        '================================================'
    ),
    (
        @batch_id,
        'START',
        'Loading Bronze Layer'
    ),
    (
        @batch_id,
        'START',
        '================================================'
    );

SET autocommit = 0;

START TRANSACTION;

-- ----------------------------------------------------------------------------------------
-- CRM - cust_info
-- ----------------------------------------------------------------------------------------

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'CRM',
        '>> Truncating Table: bronze.crm_cust_info'
    );

TRUNCATE TABLE bronze.crm_cust_info;

SET @start = NOW();

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'CRM',
        '>> Inserting Data Into: bronze.crm_cust_info'
    );

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_crm/cust_info.csv' INTO
TABLE bronze.crm_cust_info CHARACTER SET utf8mb4 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SET @secs = TIMESTAMPDIFF(SECOND, @start, NOW());

INSERT INTO
    bronze.etl_log (
        batch_id,
        step,
        message,
        seconds_taken
    )
VALUES (
        @batch_id,
        'CRM',
        CONCAT(
            '>> Load Duration: ',
            @secs,
            ' seconds'
        ),
        @secs
    );

-- ----------------------------------------------------------------------------------------
-- CRM - prd_info
-- ----------------------------------------------------------------------------------------

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'CRM',
        '>> Truncating Table: bronze.crm_prd_info'
    );

TRUNCATE TABLE bronze.crm_prd_info;

SET @start = NOW();

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'CRM',
        '>> Inserting Data Into: bronze.crm_prd_info'
    );

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_crm/prd_info.csv' INTO
TABLE bronze.crm_prd_info FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SET @secs = TIMESTAMPDIFF(SECOND, @start, NOW());

INSERT INTO
    bronze.etl_log (
        batch_id,
        step,
        message,
        seconds_taken
    )
VALUES (
        @batch_id,
        'CRM',
        CONCAT(
            '>> Load Duration: ',
            @secs,
            ' seconds'
        ),
        @secs
    );

-- ----------------------------------------------------------------------------------------
-- CRM - sales_details
-- ----------------------------------------------------------------------------------------

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'CRM',
        '>> Truncating Table: bronze.crm_sales_details'
    );

TRUNCATE TABLE bronze.crm_sales_details;

SET @start = NOW();

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'CRM',
        '>> Inserting Data Into: bronze.crm_sales_details'
    );

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_crm/sales_details.csv' INTO
TABLE bronze.crm_sales_details FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SET @secs = TIMESTAMPDIFF(SECOND, @start, NOW());

INSERT INTO
    bronze.etl_log (
        batch_id,
        step,
        message,
        seconds_taken
    )
VALUES (
        @batch_id,
        'CRM',
        CONCAT(
            '>> Load Duration: ',
            @secs,
            ' seconds'
        ),
        @secs
    );

-- ----------------------------------------------------------------------------------------
-- ERP - px_cat_g1v2
-- ----------------------------------------------------------------------------------------

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'ERP',
        '>> Truncating Table: bronze.erp_px_cat_g1v2'
    );

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

SET @start = NOW();

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'ERP',
        '>> Inserting Data Into: bronze.erp_px_cat_g1v2'
    );

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_erp/PX_CAT_G1V2.csv' INTO
TABLE bronze.erp_px_cat_g1v2 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SET @secs = TIMESTAMPDIFF(SECOND, @start, NOW());

INSERT INTO
    bronze.etl_log (
        batch_id,
        step,
        message,
        seconds_taken
    )
VALUES (
        @batch_id,
        'ERP',
        CONCAT(
            '>> Load Duration: ',
            @secs,
            ' seconds'
        ),
        @secs
    );

-- ----------------------------------------------------------------------------------------
-- ERP - loc_a101
-- ----------------------------------------------------------------------------------------

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'ERP',
        '>> Truncating Table: bronze.erp_loc_a101'
    );

TRUNCATE TABLE bronze.erp_loc_a101;

SET @start = NOW();

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'ERP',
        '>> Inserting Data Into: bronze.erp_loc_a101'
    );

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_erp/LOC_A101.csv' INTO
TABLE bronze.erp_loc_a101 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SET @secs = TIMESTAMPDIFF(SECOND, @start, NOW());

INSERT INTO
    bronze.etl_log (
        batch_id,
        step,
        message,
        seconds_taken
    )
VALUES (
        @batch_id,
        'ERP',
        CONCAT(
            '>> Load Duration: ',
            @secs,
            ' seconds'
        ),
        @secs
    );

-- ----------------------------------------------------------------------------------------
-- ERP - cust_az12
-- ----------------------------------------------------------------------------------------

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'ERP',
        '>> Truncating Table: bronze.erp_cust_az12'
    );

TRUNCATE TABLE bronze.erp_cust_az12;

SET @start = NOW();

INSERT INTO
    bronze.etl_log (batch_id, step, message)
VALUES (
        @batch_id,
        'ERP',
        '>> Inserting Data Into: bronze.erp_cust_az12'
    );

LOAD DATA LOCAL INFILE '/Users/leopoldo/Downloads/sql-data-warehouse-project/datasets/source_erp/CUST_AZ12.csv' INTO
TABLE bronze.erp_cust_az12 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\r\n' IGNORE 1 ROWS;

SET @secs = TIMESTAMPDIFF(SECOND, @start, NOW());

INSERT INTO
    bronze.etl_log (
        batch_id,
        step,
        message,
        seconds_taken
    )
VALUES (
        @batch_id,
        'ERP',
        CONCAT(
            '>> Load Duration: ',
            @secs,
            ' seconds'
        ),
        @secs
    );

COMMIT;

-- ----------------------------------------------------------------------------------------
-- END BATCH
-- ----------------------------------------------------------------------------------------

SET @batch_secs = TIMESTAMPDIFF(SECOND, @batch_start, NOW());

INSERT INTO
    bronze.etl_log (
        batch_id,
        step,
        message,
        seconds_taken
    )
VALUES (
        @batch_id,
        'END',
        '==========================================',
        NULL
    ),
    (
        @batch_id,
        'END',
        'Loading Bronze Layer is Completed',
        NULL
    ),
    (
        @batch_id,
        'END',
        CONCAT(
            ' - Total Load Duration: ',
            @batch_secs,
            ' seconds'
        ),
        @batch_secs
    ),
    (
        @batch_id,
        'END',
        '==========================================',
        NULL
    );

-- ----------------------------------------------------------------------------------------
-- FINAL LOG OUTPUT
-- ----------------------------------------------------------------------------------------

SELECT
    log_time,
    step,
    message,
    seconds_taken
FROM bronze.etl_log
WHERE
    batch_id = @batch_id
ORDER BY id;