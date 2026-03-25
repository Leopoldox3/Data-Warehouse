# Data Catalog — Data Warehouse

## Overview

This catalog documents all tables and views across the three layers of the Data Warehouse.

**Architecture:** Bronze → Silver → Gold

| Layer | Type | Purpose |
|-------|------|---------|
| Bronze | Tables | Raw data ingested as-is from source systems |
| Silver | Tables | Cleaned, standardized, and enriched data |
| Gold | Views | Business-ready dimensional model for analytics |

**Source systems:**
- **CRM** — Customer, product, and sales data
- **ERP** — Location, demographic, and category data

---

## Bronze Layer

Raw data loaded directly from source files. No transformations applied.

### `bronze.crm_cust_info`
Customer data from CRM.

| Column | Type | Description |
|--------|------|-------------|
| `cst_id` | INT | Internal customer ID |
| `cst_key` | VARCHAR(50) | Customer business key |
| `cst_firstname` | VARCHAR(50) | First name |
| `cst_lastname` | VARCHAR(50) | Last name |
| `cst_marital_status` | VARCHAR(50) | Marital status |
| `cst_gndr` | VARCHAR(50) | Gender |
| `cst_create_date` | DATE | Record creation date |

---

### `bronze.crm_prd_info`
Product data from CRM.

| Column | Type | Description |
|--------|------|-------------|
| `prd_id` | INT | Internal product ID |
| `prd_key` | VARCHAR(50) | Product business key |
| `prd_nm` | VARCHAR(50) | Product name |
| `prd_cost` | INT | Product cost |
| `prd_line` | VARCHAR(50) | Product line |
| `prd_start_dt` | DATETIME | Product availability start date |
| `prd_end_dt` | DATETIME | Product availability end date (NULL = active) |

---

### `bronze.crm_sales_details`
Sales transaction data from CRM.

| Column | Type | Description |
|--------|------|-------------|
| `sls_ord_num` | VARCHAR(50) | Order number |
| `sls_prd_key` | VARCHAR(50) | Product business key |
| `sls_cust_id` | INT | Customer ID |
| `sls_order_dt` | INT | Order date (raw integer format) |
| `sls_ship_dt` | INT | Shipping date (raw integer format) |
| `sls_due_dt` | INT | Due date (raw integer format) |
| `sls_sales` | INT | Total sales amount |
| `sls_quantity` | INT | Quantity sold |
| `sls_price` | INT | Unit price |

---

### `bronze.erp_loc_a101`
Customer location data from ERP.

| Column | Type | Description |
|--------|------|-------------|
| `cid` | VARCHAR(50) | Customer ID (joins with `crm_cust_info.cst_key`) |
| `cntry` | VARCHAR(50) | Country |

---

### `bronze.erp_cust_az12`
Customer demographic data from ERP.

| Column | Type | Description |
|--------|------|-------------|
| `cid` | VARCHAR(50) | Customer ID (joins with `crm_cust_info.cst_key`) |
| `bdate` | DATE | Birthdate |
| `gen` | VARCHAR(50) | Gender |

---

### `bronze.erp_px_cat_g1v2`
Product category data from ERP.

| Column | Type | Description |
|--------|------|-------------|
| `id` | VARCHAR(50) | Category ID (joins with `crm_prd_info.cat_id`) |
| `cat` | VARCHAR(50) | Category name |
| `subcat` | VARCHAR(50) | Subcategory name |
| `maintenance` | VARCHAR(50) | Maintenance flag |

---

## Silver Layer

Cleaned and standardized data. Dates are normalized, invalid values handled, and a metadata timestamp is added to every table.

> All silver tables include `dwh_create_date DATETIME` — timestamp of when the record was loaded into the warehouse.

### `silver.crm_cust_info`
Cleaned customer data from CRM.

| Column | Type | Description |
|--------|------|-------------|
| `cst_id` | INT | Internal customer ID |
| `cst_key` | VARCHAR(50) | Customer business key |
| `cst_firstname` | VARCHAR(50) | First name |
| `cst_lastname` | VARCHAR(50) | Last name |
| `cst_marital_status` | VARCHAR(50) | Marital status |
| `cst_gndr` | VARCHAR(50) | Gender |
| `cst_create_date` | DATE | Record creation date |
| `dwh_create_date` | DATETIME | Load timestamp |

---

### `silver.crm_prd_info`
Cleaned product data from CRM. Includes `cat_id` derived from the product key.

| Column | Type | Description |
|--------|------|-------------|
| `prd_id` | INT | Internal product ID |
| `cat_id` | VARCHAR(50) | Category ID (derived from product key) |
| `prd_key` | VARCHAR(50) | Product business key |
| `prd_nm` | VARCHAR(50) | Product name |
| `prd_cost` | INT | Product cost |
| `prd_line` | VARCHAR(50) | Product line |
| `prd_start_dt` | DATE | Product availability start date |
| `prd_end_dt` | DATE | Product availability end date (NULL = active) |
| `dwh_create_date` | DATETIME | Load timestamp |

---

### `silver.crm_sales_details`
Cleaned sales data from CRM. Dates converted from raw integers to DATE.

| Column | Type | Description |
|--------|------|-------------|
| `sls_ord_num` | VARCHAR(50) | Order number |
| `sls_prd_key` | VARCHAR(50) | Product business key |
| `sls_cust_id` | INT | Customer ID |
| `sls_order_dt` | DATE | Order date |
| `sls_ship_dt` | DATE | Shipping date |
| `sls_due_dt` | DATE | Due date |
| `sls_sales` | INT | Total sales amount |
| `sls_quantity` | INT | Quantity sold |
| `sls_price` | INT | Unit price |
| `dwh_create_date` | DATETIME | Load timestamp |

---

### `silver.erp_loc_a101`
Cleaned customer location data from ERP.

| Column | Type | Description |
|--------|------|-------------|
| `cid` | VARCHAR(50) | Customer ID |
| `cntry` | VARCHAR(50) | Country (standardized) |
| `dwh_create_date` | DATETIME | Load timestamp |

---

### `silver.erp_cust_az12`
Cleaned customer demographic data from ERP.

| Column | Type | Description |
|--------|------|-------------|
| `cid` | VARCHAR(50) | Customer ID |
| `bdate` | DATE | Birthdate |
| `gen` | VARCHAR(50) | Gender (standardized) |
| `dwh_create_date` | DATETIME | Load timestamp |

---

### `silver.erp_px_cat_g1v2`
Cleaned product category data from ERP.

| Column | Type | Description |
|--------|------|-------------|
| `id` | VARCHAR(50) | Category ID |
| `cat` | VARCHAR(50) | Category name |
| `subcat` | VARCHAR(50) | Subcategory name |
| `maintenance` | VARCHAR(50) | Maintenance flag |
| `dwh_create_date` | DATETIME | Load timestamp |

---

## Gold Layer

Business-ready dimensional model. Exposed as views built on top of the silver layer.

### `gold.dim_customers` *(view)*
Customer dimension. Unified from CRM and ERP sources.

**Sources:** `silver.crm_cust_info`, `silver.erp_cust_az12`, `silver.erp_loc_a101`

| Column | Type | Description |
|--------|------|-------------|
| `customer_key` | INT | Surrogate key (generated) |
| `customer_id` | INT | Internal customer ID from CRM |
| `customer_number` | VARCHAR(50) | Customer business key |
| `first_name` | VARCHAR(50) | First name |
| `last_name` | VARCHAR(50) | Last name |
| `country` | VARCHAR(50) | Country (from ERP) |
| `marital_status` | VARCHAR(50) | Marital status |
| `new_gen` | VARCHAR(50) | Gender — CRM priority, falls back to ERP |
| `birthdate` | DATE | Birthdate (from ERP) |
| `create_date` | DATE | Customer record creation date |

---

### `gold.dim_products` *(view)*
Product dimension. Active products only, enriched with category data.

**Sources:** `silver.crm_prd_info`, `silver.erp_px_cat_g1v2`

| Column | Type | Description |
|--------|------|-------------|
| `product_key` | INT | Surrogate key (generated) |
| `product_id` | INT | Internal product ID |
| `product_number` | VARCHAR(50) | Product business key |
| `product_name` | VARCHAR(50) | Product name |
| `category_id` | VARCHAR(50) | Category ID |
| `category` | VARCHAR(50) | Category name (from ERP) |
| `subcategory` | VARCHAR(50) | Subcategory name (from ERP) |
| `maintenance` | VARCHAR(50) | Maintenance flag (from ERP) |
| `cost` | INT | Product cost |
| `product_line` | VARCHAR(50) | Product line |
| `start_date` | DATE | Product availability start date |

---

### `gold.fact_sales` *(view)*
Sales fact table. One row per sales order line.

**Sources:** `silver.crm_sales_details`, `gold.dim_products`, `gold.dim_customers`

| Column | Type | Description |
|--------|------|-------------|
| `order_number` | VARCHAR(50) | Order number (business key) |
| `product_key` | INT | FK → `gold.dim_products` |
| `customer_key` | INT | FK → `gold.dim_customers` |
| `order_date` | DATE | Order date |
| `shipping_date` | DATE | Shipping date |
| `due_date` | DATE | Due date |
| `sales_amount` | INT | Total sales amount |
| `quantity` | INT | Quantity sold |
| `price` | INT | Unit price |

---

## Data Lineage

```
CRM Sources          ERP Sources
─────────────        ─────────────
crm_cust_info        erp_cust_az12
crm_prd_info    →    erp_px_cat_g1v2
crm_sales_details    erp_loc_a101
      │                    │
      ▼                    ▼
   [ Bronze Layer ]   (raw tables)
      │
      ▼
   [ Silver Layer ]   (cleaned & standardized)
      │
      ▼
   [ Gold Layer  ]    (dim_customers, dim_products, fact_sales)
```
