# Technical Documentation

## SME Business Intelligence & Management Decision Support Project

---

## Table of Contents

1. [Introduction](#1-introduction)
2. [Project Objective](#2-project-objective)
3. [Data Cleaning](#3-data-cleaning)
4. [Database Engineering](#4-database-engineering)
5. [SQL Analysis](#5-sql-analysis)
6. [Power BI Dashboard](#6-power-bi-dashboard)
7. [DAX Measures](#7-dax-measures)
8. [Key Findings](#8-key-findings)
9. [Management Interpretation](#9-management-interpretation)
10. [Data Quality & Validation Summary](#10-data-quality--validation-summary)
11. [Development Evidence](#11-development-evidence)
12. [Design Decisions & Rationale](#12-design-decisions--rationale)
13. [Limitations & Future Work](#13-limitations--future-work)
14. [Conclusion](#14-conclusion)

---

## 1. Introduction

This project demonstrates an end-to-end Business Intelligence workflow for transforming transactional data into information that supports management decision-making. It integrates several disciplines that are often treated separately in analytics work:

- Data cleaning
- Data engineering
- Relational database management
- SQL analysis
- Data visualization
- Business interpretation
- Management recommendation-writing

The complete workflow is:

```text
Raw Data
   ↓
Python / Pandas
   ↓
Data Cleaning
   ↓
PostgreSQL
   ↓
SQL Analysis
   ↓
Power BI
   ↓
Management Insights
```

The project was built to reflect how a business intelligence analyst would realistically approach a dataset from a small or medium-sized enterprise: starting with unstructured raw data and ending with a decision-ready dashboard.

## 2. Project Objective

The objective is to demonstrate how business transaction data can be transformed into information that management can use for:

- Planning
- Organising
- Performance evaluation
- Customer analysis
- Product analysis
- Resource allocation
- Business growth strategy
- Evidence-based decision-making

The project treats each stage of the pipeline as a deliberate engineering decision rather than a mechanical step — for example, choosing which fields to validate, which KPIs matter to management, and which visuals best communicate a given insight.

## 3. Data Cleaning

Python and Pandas were used to prepare the transaction dataset before it was loaded into the database.

**Process:**

1. Loaded the raw CSV dataset.
2. Standardised column names (lowercase, underscores, whitespace stripped).
3. Removed duplicate records using `drop_duplicates()`.
4. Cleaned text fields by trimming whitespace on all object-type columns.
5. Converted the transaction date column to a proper `datetime` type using `pd.to_datetime()` with error coercion.
6. Converted numeric fields — quantity, unit price, unit cost, revenue, total cost, profit — using `pd.to_numeric()` with error coercion, ensuring invalid values become `NaN` rather than silently corrupting calculations.
7. Validated important fields (checked for null transaction IDs and null revenue values).
8. Exported the cleaned dataset to `data/processed/sales_cleaned.csv`.

**Script:** `python/clean_sales.py`

**Validation results:**

| Check | Result |
|---|---|
| Expected / loaded records | 500 |
| Duplicate transaction IDs | 0 |
| Null transaction IDs | 0 |
| Null revenue values | 0 |

## 4. Database Engineering

The cleaned dataset was loaded into PostgreSQL to provide a structured, relational environment for analysis rather than working directly off a flat file.

**Main table:** `public.sales_transactions`

**Schema:**

| Column | Type | Description |
|---|---|---|
| `transaction_id` | `TEXT` (Primary Key) | Unique identifier for each transaction |
| `transaction_date` | `TIMESTAMPTZ` | Date and time of the transaction |
| `product` | `TEXT` | Product sold |
| `category` | `TEXT` | Product category |
| `customer_type` | `TEXT` | Customer segment |
| `quantity` | `NUMERIC` | Units sold |
| `unit_price` | `NUMERIC` | Price per unit |
| `unit_cost` | `NUMERIC` | Cost per unit |
| `revenue` | `NUMERIC` | Total revenue for the transaction |
| `total_cost` | `NUMERIC` | Total cost for the transaction |
| `profit` | `NUMERIC` | Revenue minus total cost |

A relational structure with a defined primary key (`transaction_id`) was chosen specifically so duplicate-record integrity could be enforced at the database level, not just during the Python cleaning stage — providing a second layer of data quality assurance.

**Script:** `database/database_setup.sql`

## 5. SQL Analysis

SQL queries were developed to analyse the dataset from a management perspective. The analysis was designed around business questions rather than simply retrieving raw records.

**Areas covered:**

- Overall business KPIs
- Customer performance (revenue, profit, margin by customer type)
- Product performance (revenue, profit, margin by product)
- Category performance
- Monthly performance and trend analysis
- Profit margin calculations
- Revenue concentration analysis
- Top products and top customer types by profit

**Script:** `sql/sql_analysis.sql`

### Key Query — Overall KPIs

```sql
SELECT
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(revenue) AS total_revenue,
    SUM(total_cost) AS total_cost,
    SUM(profit) AS total_profit,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM public.sales_transactions;
```

### Key Query — Customer Performance

```sql
SELECT
    customer_type,
    COUNT(*) AS transactions,
    SUM(quantity) AS units_sold,
    SUM(revenue) AS revenue,
    SUM(profit) AS profit,
    ROUND(SUM(profit) / NULLIF(SUM(revenue), 0) * 100, 2) AS profit_margin_pct
FROM public.sales_transactions
GROUP BY customer_type
ORDER BY revenue DESC;
```

Note the consistent use of `NULLIF(..., 0)` to guard against division-by-zero errors when computing margins — a defensive SQL pattern applied throughout the analysis.

## 6. Power BI Dashboard

Power BI was used to convert the analytical results into an executive dashboard aimed at a management audience rather than a technical one.

**KPI Cards:**

- Total Revenue
- Total Profit
- Profit Margin
- Total Transactions

**Charts:**

- Monthly Revenue & Profit Performance (combo chart with trend line)
- Revenue by Customer Type (horizontal bar chart)
- Revenue by Product (horizontal bar chart)
- Profit Margin by Category (horizontal bar chart)

**Design rationale:** KPI cards are placed at the top for at-a-glance executive scanning, followed by trend and comparison visuals that support the KPIs with underlying detail. A written insights panel accompanies the visuals so the dashboard tells a story rather than presenting numbers without context.

## 7. DAX Measures

A Profit Margin measure was created to ensure the ratio is always calculated dynamically against whatever filter context is applied on the dashboard (e.g. filtering by month or customer type), rather than being a static pre-computed value:

```dax
Profit Margin =
DIVIDE(
    SUM('public sales_transactions'[profit]),
    SUM('public sales_transactions'[revenue]),
    0
)
```

`DIVIDE()` is used instead of the `/` operator specifically to handle division-by-zero gracefully within Power BI, returning `0` instead of an error.

## 8. Key Findings

### Customer Performance

Real Estate customers generated ₦282,338,449 in revenue; Construction Company customers generated ₦240,545,069.50. These were the two largest customer-type revenue contributors in the analysis.

### Product Performance

Granite 20 Tons generated ₦465,302,500 in revenue, and Sharp Sand generated ₦168,448,500. Granite 20 Tons represented approximately **66.89%** of total product revenue.

### Category Performance

Aggregates generated ₦633,751,000 in revenue, representing the largest category contribution in the analysis, followed by Steel, Plumbing, Cement, Roofing, and Blocks.

### Margin vs Revenue

While Granite 20 Tons dominates revenue, it does not have the highest margin. PVC Pipe 1in recorded the highest product-level profit margin at 27.86%, illustrating that revenue leaders and margin leaders are not always the same product.

## 9. Management Interpretation

The project demonstrates that data analysis can move beyond reporting historical numbers into actionable guidance. The findings support management decisions in the following areas:

**Product Strategy**
Management can monitor products that generate significant revenue while also considering their profit margins, avoiding decisions based on revenue volume alone.

**Customer Strategy**
Major customer segments (Real Estate, Construction Companies) can be monitored to support retention and relationship management, since losing either would materially affect total revenue.

**Revenue Diversification**
High revenue concentration in a single product (Granite 20 Tons) or category (Aggregates) can be monitored as a business risk, prompting consideration of diversification strategies.

**Performance Planning**
Monthly analysis helps management identify periods of stronger or weaker performance — such as the March revenue dip — and investigate the operational or market factors behind them.

## 10. Data Quality & Validation Summary

Data quality was validated at two separate stages of the pipeline, providing redundancy:

| Stage | Check | Result |
|---|---|---|
| Python / Pandas | Duplicate transaction IDs | 0 |
| Python / Pandas | Null transaction IDs | 0 |
| Python / Pandas | Null revenue values | 0 |
| PostgreSQL | Total row count | 500 / 500 |
| PostgreSQL | Duplicate transaction IDs | 0 |
| PostgreSQL | Null transaction IDs | 0 |
| PostgreSQL | Null revenue | 0 |
| PostgreSQL | Null profit | 0 |

## 11. Development Evidence

The project includes screenshots documenting the actual development process, organised by stage:

**Python**
- Cleaning script execution
- Before/after dataset shape
- Validation checks output

**PostgreSQL**
- Database table/schema
- Loaded transaction data
- SQL query results (pgAdmin)

**Power BI**
- Data/model view
- DAX measure definition
- Visual-building workspace
- Final executive dashboard

All screenshots reflect the actual development environment used to build the project and are stored in `documentation/screenshots/`.

## 12. Design Decisions & Rationale

- **Why PostgreSQL over a flat-file workflow:** A relational database enforces a primary key constraint on `transaction_id`, giving a second independent check against duplicate records beyond the Pandas cleaning step.
- **Why SQL for analysis rather than doing it all in Pandas:** SQL aggregation was chosen to mirror how analysis is typically performed against a live business database, and to demonstrate proficiency with GROUP BY, window-style aggregation, and safe division patterns (`NULLIF`).
- **Why Power BI for the final layer:** Power BI was chosen because it connects live to PostgreSQL, supports DAX for dynamic calculations, and produces a dashboard format that is directly usable by a non-technical management audience.
- **Why a written insights panel is embedded in the dashboard:** Numbers alone do not drive decisions — the insights panel translates each chart into a specific, actionable management observation.

## 13. Limitations & Future Work

- The current analysis is based on a fixed snapshot of transaction data (January–July 2026); a production version would refresh on a schedule.
- Forecasting and trend prediction were out of scope for this phase but would be a natural next step (e.g. using time-series modelling on the monthly revenue/profit series).
- Customer-level (rather than customer-type-level) analysis could be added for more granular relationship management insight.
- Automated data quality alerts (e.g. via a scheduled validation script) would strengthen the pipeline for ongoing production use.

## 14. Conclusion

This project demonstrates an end-to-end Business Intelligence workflow combining data engineering, database management, analytical SQL, and visualization. The central professional objective is to demonstrate the ability to transform raw business data into information that supports planning, organisation, and evidence-based management decisions — the full path from a raw CSV file to a decision-ready executive dashboard.
