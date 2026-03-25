-- =============================================================================
-- Init Script: Create Databases
-- Description: Creates the three-layer databases for the Data Warehouse.
--              Run this script once before executing any DDL or load scripts.
-- Order: bronze → silver → gold
-- =============================================================================

CREATE DATABASE IF NOT EXISTS bronze;  -- Raw data ingested from source systems
CREATE DATABASE IF NOT EXISTS silver;  -- Cleaned and standardized data
CREATE DATABASE IF NOT EXISTS gold;    -- Business-ready dimensional model
