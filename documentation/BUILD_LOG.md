# Project Build Log

A chronological record of the development process for the SME Business Intelligence & Management Decision Support project.

---

## Phase 1 — Python / Pandas (Data Cleaning)

### Activities

- Loaded the raw transaction dataset (CSV).
- Inspected dataset structure and initial shape.
- Standardised column names (lowercase, underscores, whitespace stripped).
- Removed exact duplicate records using `drop_duplicates()`.
- Cleaned text fields by trimming whitespace on all object-type columns.
- Converted the transaction date field to proper `datetime` format, coercing invalid values to `NaN` rather than failing silently.
- Converted numerical fields (quantity, unit price, unit cost, revenue, total cost, profit) to numeric types with the same error-coercion approach.
- Exported the cleaned dataset to `data/processed/sales_cleaned.csv`.
- Performed validation checks on the cleaned output.

### Result

```text
500 cleaned rows
0 duplicate transaction IDs
0 null transaction IDs
0 null revenue values
```

### Notes

Error coercion (`errors="coerce"`) was used deliberately on both date and numeric conversions so that any malformed values would surface as `NaN` and be caught by the validation step, rather than crashing the pipeline or silently producing wrong calculations downstream.

---

## Phase 2 — PostgreSQL (Database Engineering)

### Activities

- Created the `public.sales_transactions` table with an explicit schema and `transaction_id` as the primary key.
- Loaded the cleaned CSV output into the table.
- Verified the total record count matched the cleaned dataset (500 rows).
- Checked for duplicate and missing transaction IDs at the database level.
- Checked for missing revenue and profit values at the database level.
- Developed the relational structure needed to support the SQL analysis phase.

### Main table

```text
public.sales_transactions
```

### Result

```text
Table created successfully
500 / 500 records loaded
0 duplicate transaction IDs
0 null transaction IDs
0 null revenue
0 null profit
```

### Notes

Enforcing `transaction_id` as a primary key at the database layer provided a second, independent integrity check beyond the Pandas-level duplicate check performed in Phase 1 — if any duplicate had slipped through, the table load itself would have failed.

---

## Phase 3 — SQL Analysis

### Analysis developed

- Overall business KPIs (transactions, units sold, revenue, cost, profit, profit margin)
- Revenue and profit by customer type
- Profit by customer type (ranked)
- Monthly performance (revenue, profit, margin trend across Jan–Jul 2026)
- Product performance (revenue, profit, margin by product)
- Category performance (revenue, profit, margin by category)
- Top 10 products by revenue
- Top customer types by profit
- Revenue concentration analysis (product share of total revenue)

### Queries written

All queries are stored in `sql/sql_analysis.sql`, organised into numbered, labelled sections for readability:

1. Overall Business KPIs
2. Revenue and Profit by Customer Type
3. Monthly Performance
4. Product Performance
5. Category Performance
6. Top 10 Products by Revenue
7. Top Customer Types by Profit

### Notes

Every margin calculation used `NULLIF(SUM(revenue), 0)` in the denominator to guard against division-by-zero errors, since a grouped category or month with zero revenue would otherwise break the query.

---

## Phase 4 — Power BI

### Activities

- Connected Power BI to the PostgreSQL database.
- Created KPI cards for Total Revenue, Total Profit, Profit Margin, and Total Transactions.
- Created a `Profit Margin` DAX measure using `DIVIDE()` for safe division.
- Built a Monthly Revenue & Profit combo visual with a trend line.
- Built a Revenue by Customer Type horizontal bar chart.
- Built a Revenue by Product horizontal bar chart.
- Built a Profit Margin by Category horizontal bar chart.
- Added a written Management Insights & Recommendations panel alongside the visuals.

### DAX Measure

```dax
Profit Margin =
DIVIDE(
    SUM('public sales_transactions'[profit]),
    SUM('public sales_transactions'[revenue]),
    0
)
```

### Notes

The dashboard was deliberately laid out with KPI cards at the top for executive scanning, followed by trend and comparison visuals, with the insights panel positioned last so the page reads as a narrative rather than a grid of disconnected charts.

---

## Phase 5 — Documentation

### Activities

- Organised the Python cleaning script under `python/`.
- Organised the SQL scripts under `sql/` and `database/`.
- Documented the database structure and schema.
- Documented the Power BI development process and DAX logic.
- Wrote the full technical documentation (`documentation/TECHNICAL_DOCUMENTATION.md`).
- Wrote this build log (`documentation/BUILD_LOG.md`).
- Prepared the project structure for GitHub.
- Organised development evidence (screenshots) into `documentation/screenshots/`.

---

## Final Workflow

```text
Python
   ↓
Pandas
   ↓
PostgreSQL
   ↓
SQL
   ↓
Power BI
   ↓
Business Intelligence
   ↓
Management Decision Support
```
