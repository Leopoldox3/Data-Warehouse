# Data Warehouse

A three-layer data warehouse built on MySQL, integrating data from CRM and ERP source systems into a dimensional model ready for analytics.

## Project Structure

```
├── datasets/               # Source CSV files (CRM and ERP)
├── docs/
│   ├── data_catalog.md     # Column-level documentation for all tables and views
│   └── init.sql            # Creates the bronze, silver, and gold databases
├── scripts/
│   ├── bronze/
│   │   ├── ddl_bronze.sql           # Creates raw tables
│   │   └── script_load_bronze.sql   # Loads data from CSV into bronze
│   ├── silver/
│   │   ├── ddl_silver.sql           # Creates cleaned tables
│   │   └── script_load_silver.sql   # Transforms and loads bronze → silver
│   └── gold/
│       └── ddl_gold.sql             # Creates dimensional views (dim + fact)
└── tests/                  # Data quality checks
```

## Getting Started

### Prerequisites
- MySQL 8.0+
- A MySQL client (e.g. DBeaver, MySQL Workbench)
- Source CSV files placed in the `datasets/` folder

### Execution Order

Run the scripts in this order:

1. **Initialize databases**
   ```sql
   -- Run: docs/init.sql
   CREATE DATABASE IF NOT EXISTS bronze;
   CREATE DATABASE IF NOT EXISTS silver;
   CREATE DATABASE IF NOT EXISTS gold;
   ```

2. **Bronze layer** — create tables and load raw data
   ```
   scripts/bronze/ddl_bronze.sql
   scripts/bronze/script_load_bronze.sql
   ```

3. **Silver layer** — create tables and load cleaned data
   ```
   scripts/silver/ddl_silver.sql
   scripts/silver/script_load_silver.sql
   ```

4. **Gold layer** — create dimensional views
   ```
   scripts/gold/ddl_gold.sql
   ```

## Data Sources

| System | Tables |
|--------|--------|
| CRM | `crm_cust_info`, `crm_prd_info`, `crm_sales_details` |
| ERP | `erp_cust_az12`, `erp_loc_a101`, `erp_px_cat_g1v2` |

## Architecture

data_arquitecture.svg

## Gold Layer Model

```
gold.dim_customers ──┐
                     ├── gold.fact_sales
gold.dim_products  ──┘
```


For full column-level documentation see [docs/data_catalog.md](docs/data_catalog.md).
