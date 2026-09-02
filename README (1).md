# SME Business Intelligence & Management Decision Support System

An end-to-end Business Intelligence project demonstrating how raw transactional data can be cleaned, engineered, analysed, and transformed into an executive dashboard and management recommendations.

![Status](https://img.shields.io/badge/status-complete-brightgreen)
![Python](https://img.shields.io/badge/Python-Pandas-blue)
![Database](https://img.shields.io/badge/Database-PostgreSQL-336791)
![BI](https://img.shields.io/badge/Dashboard-Power%20BI-F2C811)

---

## Table of Contents

- [Project Objective](#project-objective)
- [Business Problem](#business-problem)
- [Technology Stack](#technology-stack)
- [Project Workflow](#project-workflow)
- [Repository Structure](#repository-structure)
- [Phase 1 — Data Cleaning (Python / Pandas)](#phase-1--data-cleaning-python--pandas)
- [Phase 2 — Database Engineering (PostgreSQL)](#phase-2--database-engineering-postgresql)
- [Phase 3 — SQL Business Analysis](#phase-3--sql-business-analysis)
- [Phase 4 — Power BI Executive Dashboard](#phase-4--power-bi-executive-dashboard)
- [Key Findings](#key-findings)
- [Management Insights & Recommendations](#management-insights--recommendations)
- [Skills Demonstrated](#skills-demonstrated)
- [How to Reproduce This Project](#how-to-reproduce-this-project)
- [Documentation](#documentation)
- [Project Outcome](#project-outcome)
- [Author](#author)

---

## Project Objective

The objective of this project is to demonstrate the complete process of transforming raw business transaction data into structured, reliable information that supports management decision-making.

The project covers the full analytics lifecycle:

**Data Cleaning → Database Engineering → SQL Analysis → Data Visualization → Management Recommendations**

It is designed to reflect how a real business analytics function operates: starting from messy raw data and ending with a decision-ready executive dashboard and a set of actionable management recommendations.

## Business Problem

Small and medium-sized businesses generate large volumes of transactional data but often lack structured systems for converting that data into useful management decisions. This project demonstrates how data can be used to:

- Monitor revenue and profit
- Analyse customer segments
- Identify high-performing products
- Track monthly performance
- Compare profit margins across categories
- Identify revenue concentration risk
- Support business planning
- Develop evidence-based management recommendations

## Technology Stack

| Stage | Technology |
|---|---|
| Data Cleaning | Python |
| Data Manipulation | Pandas |
| Database | PostgreSQL |
| Database Management | pgAdmin |
| Data Analysis | SQL |
| Visualization | Microsoft Power BI |
| Calculations | DAX |
| Version Control | GitHub |

## Project Workflow

```text
Raw Transaction Data
        ↓
Python / Pandas
        ↓
Data Cleaning & Validation
        ↓
PostgreSQL Database
        ↓
SQL Business Analysis
        ↓
Power BI
        ↓
Executive Dashboard
        ↓
Management Insights
        ↓
Business Recommendations
```

## Repository Structure

```text
SME-Business-Intelligence-Management/
│
├── data/
│   ├── raw/
│   └── processed/
│
├── python/
│   └── clean_sales.py
│
├── database/
│   └── database_setup.sql
│
├── sql/
│   └── sql_analysis.sql
│
├── powerbi/
│   ├── SME_Business_Intelligence.pbix
│   └── README.md
│
└── documentation/
    ├── TECHNICAL_DOCUMENTATION.md
    ├── BUILD_LOG.md
    └── screenshots/
```

---

## Phase 1 — Data Cleaning (Python / Pandas)

The raw transaction dataset was processed using Python and Pandas before being loaded into the database.

**Activities:**

- Loaded the raw CSV dataset
- Standardised column names (lowercase, underscores)
- Removed exact duplicate records
- Cleaned text fields (trimmed whitespace)
- Converted transaction dates to proper datetime format
- Converted numerical fields (quantity, unit price, unit cost, revenue, total cost, profit)
- Validated the cleaned dataset (checked for nulls and duplicate IDs)
- Exported the cleaned dataset for database loading

**Script:** [`python/clean_sales.py`](python/clean_sales.py)

**Result:**

```text
500 cleaned rows
0 duplicate transaction IDs
0 null transaction IDs
0 null revenue values
```

## Phase 2 — Database Engineering (PostgreSQL)

The cleaned dataset was loaded into a PostgreSQL relational database to provide a structured environment for analysis.

**Main table:** `public.sales_transactions`

The table stores fields relating to transaction ID, transaction date, product, category, customer type, quantity, unit price, unit cost, revenue, total cost, and profit.

**Script:** [`database/database_setup.sql`](database/database_setup.sql)

**Validation performed:**

- Total record count check
- Duplicate transaction ID check
- Null transaction ID check
- Null revenue check
- Null profit check

**Result:** 500 / 500 records loaded successfully, with zero data quality issues detected.

## Phase 3 — SQL Business Analysis

SQL was used to analyse the dataset from a management perspective rather than simply retrieving records. The analysis covers:

- Overall business KPIs (transactions, units sold, revenue, cost, profit, profit margin)
- Revenue and profit by customer type
- Monthly performance (revenue, profit, margin trends)
- Product performance (revenue, profit, margin)
- Category performance
- Top products and top customer types by profit
- Revenue concentration analysis

**Script:** [`sql/sql_analysis.sql`](sql/sql_analysis.sql)

### Example Query — Executive KPIs

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

## Phase 4 — Power BI Executive Dashboard

The cleaned and analysed data was connected to Microsoft Power BI to build an executive dashboard translating the SQL analysis into a visual management report.

**Dashboard components:**

- **KPI Cards:** Total Revenue, Total Profit, Profit Margin, Total Transactions
- **Monthly Revenue & Profit Performance** trend chart
- **Revenue by Customer Type**
- **Revenue by Product**
- **Profit Margin by Category**
- **Management Insights & Recommendations** panel

**DAX Measure — Profit Margin:**

```dax
Profit Margin =
DIVIDE(
    SUM('public sales_transactions'[profit]),
    SUM('public sales_transactions'[revenue]),
    0
)
```

---

## Key Findings

### Customer Performance

| Customer Type | Revenue |
|---|---|
| Real Estate | ₦282,338,449.00 |
| Construction Company | ₦240,545,069.50 |
| Institution | ₦47,488,088.50 |
| Retail | ₦43,713,663.50 |
| Individual | ₦42,656,587.50 |
| Contractor | ₦38,840,650.00 |

### Product Performance

| Product | Revenue |
|---|---|
| Granite 20 Tons | ₦465,302,500 |
| Sharp Sand | ₦168,448,500 |
| Iron Rod 16mm | ₦16,530,860 |
| Cement 50kg | ₦11,570,875 |
| Roofing Sheet | ₦9,732,506 |

Granite 20 Tons represented approximately **66.89%** of total product revenue. PVC Pipe 1in recorded the highest product-level profit margin at **27.86%**.

### Category Performance

| Category | Revenue |
|---|---|
| Aggregates | ₦633,751,000 |
| Steel | ₦25,118,387 |
| Plumbing | ₦13,716,219 |
| Cement | ₦11,570,875 |
| Roofing | ₦9,732,506 |
| Blocks | ₦1,693,521 |

### Monthly Performance

The analysis covers **January–July 2026**. January recorded the highest monthly revenue and profit; March recorded the lowest revenue and margin; June recorded the highest profit margin.

---

## Management Insights & Recommendations

**1. Revenue Concentration**
A significant proportion of revenue is concentrated in Granite 20 Tons and the Aggregates category. Management should monitor this dependence and consider product diversification.

**2. Customer Segmentation**
Real Estate and Construction Company customers are major revenue contributors. Customer retention and relationship management should be prioritised for these segments.

**3. Product Profitability**
Products should be evaluated using both revenue contribution and profit margin, rather than revenue alone, when making product decisions.

**4. Monthly Performance**
Monthly analysis allows management to identify periods of strong or weak performance (e.g. the March dip) and investigate the underlying causes.

**5. Decision Support**
The purpose of this project is not simply to produce charts — it is to demonstrate how technical data skills can support core management activities: planning, organising, performance evaluation, resource allocation, customer strategy, product strategy, and evidence-based decision-making.

---

## Skills Demonstrated

| Skill Area | Tools / Techniques |
|---|---|
| Data Engineering | Python, Pandas — cleaning, validation, transformation |
| Database Management | PostgreSQL, pgAdmin — schema design, data loading |
| Data Analysis | SQL — aggregation, grouping, KPI derivation |
| Business Intelligence | Power BI — dashboard design, DAX measures |
| Analytical Interpretation | Translating query results into management insight |
| Documentation | Structured technical writing, version control (Git/GitHub) |

## How to Reproduce This Project

1. Clone this repository.
2. Place the raw transaction CSV in `data/raw/`.
3. Run `python/clean_sales.py` to produce the cleaned dataset in `data/processed/`.
4. Execute `database/database_setup.sql` in PostgreSQL to create the `sales_transactions` table.
5. Load the cleaned CSV into the table (e.g. via pgAdmin's import tool or `psql \copy`).
6. Run the queries in `sql/sql_analysis.sql` to generate the business analysis.
7. Open `powerbi/SME_Business_Intelligence.pbix` in Power BI Desktop, connect it to the PostgreSQL database, and refresh.

## Documentation

- Full technical write-up: [`documentation/TECHNICAL_DOCUMENTATION.md`](documentation/TECHNICAL_DOCUMENTATION.md)
- Chronological build log: [`documentation/BUILD_LOG.md`](documentation/BUILD_LOG.md)
- Development screenshots: [`documentation/screenshots/`](documentation/screenshots/)

## Project Outcome

This project demonstrates an end-to-end approach to Business Intelligence, combining data engineering, data analysis, and visualization with management-oriented interpretation. It illustrates the transition from:

**Technical Data Processing → Business Intelligence → Management Decision Support**

## Author

Built and documented as an independent data analytics project covering the full BI pipeline from raw data to executive dashboard.

**Repository:** [github.com/btechng/SME-Business-Intelligence-Management](https://github.com/btechng/SME-Business-Intelligence-Management)
