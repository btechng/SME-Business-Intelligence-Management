-- PostgreSQL schema for SME Business Intelligence project

CREATE TABLE sales_transactions (
    transaction_id INTEGER PRIMARY KEY,
    transaction_date DATE NOT NULL,
    customer_id VARCHAR(20),
    customer_name VARCHAR(150),
    customer_type VARCHAR(80),
    product VARCHAR(150),
    category VARCHAR(80),
    quantity INTEGER NOT NULL,
    unit_cost NUMERIC(14,2),
    unit_price NUMERIC(14,2),
    revenue NUMERIC(14,2),
    total_cost NUMERIC(14,2),
    profit NUMERIC(14,2),
    profit_margin_pct NUMERIC(8,2),
    month VARCHAR(7),
    quarter VARCHAR(2),
    year INTEGER
);

-- Example management queries

-- 1. Revenue and profit by product
SELECT product,
       SUM(revenue) AS revenue,
       SUM(profit) AS profit,
       ROUND(SUM(profit) / NULLIF(SUM(revenue),0) * 100, 2) AS margin_pct
FROM sales_transactions
GROUP BY product
ORDER BY profit DESC;

-- 2. Monthly business performance
SELECT month,
       SUM(revenue) AS revenue,
       SUM(profit) AS profit
FROM sales_transactions
GROUP BY month
ORDER BY month;

-- 3. Top customer segments
SELECT customer_type,
       SUM(revenue) AS revenue,
       SUM(profit) AS profit
FROM sales_transactions
GROUP BY customer_type
ORDER BY revenue DESC;

-- 4. Products requiring management attention
SELECT product,
       SUM(quantity) AS units_sold,
       SUM(profit) AS profit
FROM sales_transactions
GROUP BY product
ORDER BY profit ASC;
