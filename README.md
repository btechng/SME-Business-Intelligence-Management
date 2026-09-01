# SME Business Intelligence & Management Decision Support System

## Project Overview
This project demonstrates an end-to-end business intelligence workflow that transforms transactional business data into management insights and actionable recommendations.

The project combines:
- Python and Pandas for data cleaning and transformation
- PostgreSQL for structured data storage and analysis
- SQL for KPI, product, customer and time-based analysis
- Power BI for executive visualization (next stage)

## Business Objective
The objective is not only to process and visualize data, but to demonstrate how data can support management decisions involving planning, resource allocation, product performance, customer analysis and profitability.

## Data Pipeline

Raw Transaction Data
→ Python + Pandas
→ Data Cleaning
→ PostgreSQL
→ SQL Analysis
→ Power BI
→ Management Insights
→ Business Recommendations

## Dataset
- 500 transaction records
- 10,904 units sold
- 10 product lines
- 6 customer types
- 6 product categories
- Reporting period: January–July 2026

## Data Quality Validation
The loaded dataset passed the following checks:
- Required-field completeness: 500/500
- Duplicate transaction IDs: 0
- Invalid quantities: 0
- Revenue/cost/profit calculation inconsistencies: 0

## Current KPI Results

| KPI | Result |
|---|---:|
| Transactions | 500 |
| Units sold | 10,904 |
| Revenue | ₦695,582,508.00 |
| Total cost | ₦561,713,050.00 |
| Total profit | ₦133,869,458.00 |
| Profit margin | 19.25% |

## Key Findings

### Product concentration
Granite 20 Tons generated ₦465,302,500 in revenue, representing 66.89% of total revenue. This indicates substantial revenue concentration in one product line and creates an important management question around product dependency and diversification.

### Margin performance
PVC Pipe 1in recorded the highest product-level profit margin at 27.86%, while Granite 20 Tons generated the largest absolute profit at ₦89,342,500.

### Category performance
- Aggregates: ₦633,751,000 revenue; ₦120,271,000 profit; 18.98% margin
- Steel: ₦25,118,387 revenue; ₦5,228,787 profit; 20.82% margin
- Plumbing: ₦13,716,219 revenue; ₦3,477,219 profit; 25.35% margin
- Cement: ₦11,570,875 revenue; ₦2,300,075 profit; 19.88% margin
- Roofing: ₦9,732,506 revenue; ₦2,164,106 profit; 22.24% margin
- Blocks: ₦1,693,521 revenue; ₦428,271 profit; 25.29% margin

### Customer analysis
Real Estate customers generated the highest revenue at ₦282,338,449 and profit of ₦55,497,399. Construction Companies followed with ₦240,545,069.50 revenue and ₦45,600,369.50 profit.

## Management Interpretation
The analysis demonstrates why business intelligence should go beyond reporting. Revenue concentration, margin differences and customer contribution can inform inventory planning, product strategy, customer prioritisation and profitability management.

## Project Status
Completed:
- Python/Pandas data cleaning
- PostgreSQL database loading
- Data quality validation
- SQL KPI analysis
- Product/category/customer/time analysis

Next:
- Power BI executive dashboard
- Final management recommendations
- Dashboard screenshots
- Final project presentation

## Technical Documentation
See `TECHNICAL_DOCUMENTATION.md` for the detailed methodology and findings.

> Note: This repository documents a portfolio/demonstration business intelligence project. Dataset figures are used to demonstrate the analytical workflow and should not be presented as audited financial records of a real company.
