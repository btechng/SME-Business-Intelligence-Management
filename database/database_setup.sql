-- =========================================================
-- SME BUSINESS INTELLIGENCE PROJECT
-- PostgreSQL Database Setup
-- =========================================================
-- This script creates the main transaction table used for
-- the project and runs a set of data quality validation
-- checks after the cleaned dataset has been loaded.
-- =========================================================


-- =========================================================
-- 1. TABLE CREATION
-- =========================================================

CREATE TABLE IF NOT EXISTS public.sales_transactions (

    transaction_id      TEXT PRIMARY KEY,

    transaction_date    TIMESTAMPTZ,

    product              TEXT,

    category             TEXT,

    customer_type        TEXT,

    quantity             NUMERIC,

    unit_price           NUMERIC,

    unit_cost            NUMERIC,

    revenue              NUMERIC,

    total_cost           NUMERIC,

    profit               NUMERIC
);


-- =========================================================
-- 2. DATA LOADING
-- =========================================================
-- The cleaned dataset (data/processed/sales_cleaned.csv)
-- produced by python/clean_sales.py was loaded into this
-- table using pgAdmin's Import/Export tool, or equivalently
-- via psql:
--
-- \copy public.sales_transactions
--     FROM 'data/processed/sales_cleaned.csv'
--     WITH (FORMAT csv, HEADER true);
-- =========================================================


-- =========================================================
-- 3. DATA VALIDATION
-- =========================================================

-- 3.1 Total number of records loaded
SELECT
    COUNT(*) AS total_rows
FROM public.sales_transactions;


-- 3.2 Check for duplicate transaction IDs
SELECT
    COUNT(*) AS duplicate_transaction_ids
FROM (
    SELECT
        transaction_id
    FROM public.sales_transactions
    GROUP BY transaction_id
    HAVING COUNT(*) > 1
) duplicates;


-- 3.3 Check for missing (null) transaction IDs
SELECT
    COUNT(*) AS null_transaction_ids
FROM public.sales_transactions
WHERE transaction_id IS NULL;


-- 3.4 Check for missing (null) revenue values
SELECT
    COUNT(*) AS null_revenue
FROM public.sales_transactions
WHERE revenue IS NULL;


-- 3.5 Check for missing (null) profit values
SELECT
    COUNT(*) AS null_profit
FROM public.sales_transactions
WHERE profit IS NULL;


-- 3.6 Check for missing (null) quantity values
SELECT
    COUNT(*) AS null_quantity
FROM public.sales_transactions
WHERE quantity IS NULL;


-- 3.7 Sanity check: revenue should equal (quantity * unit_price)
--     Flags any rows where the stored revenue does not match
--     the calculated revenue, allowing for minor rounding.
SELECT
    COUNT(*) AS revenue_calculation_mismatches
FROM public.sales_transactions
WHERE ROUND(revenue, 2) <> ROUND(quantity * unit_price, 2);


-- 3.8 Sanity check: profit should equal (revenue - total_cost)
SELECT
    COUNT(*) AS profit_calculation_mismatches
FROM public.sales_transactions
WHERE ROUND(profit, 2) <> ROUND(revenue - total_cost, 2);


-- =========================================================
-- End of database setup and validation script
-- =========================================================
