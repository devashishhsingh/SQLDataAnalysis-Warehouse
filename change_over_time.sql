-- ============================================================================
-- 1. Data Analysis – Sales Over Time / Trend Analysis
-- ============================================================================
-- This section analyzes how sales performance changes over time by evaluating
-- total sales, customer activity, and quantity sold on a monthly and yearly basis.
-- It helps identify business trends, seasonality, and customer behavior patterns.
-- ============================================================================


-- ============================================================================
-- a. Yearly & Monthly Trend Analysis using EXTRACT()
-- Extracts numeric year and month values from order_date
-- ============================================================================
SELECT 
    EXTRACT(YEAR FROM order_date) AS order_year,
    EXTRACT(MONTH FROM order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY 1, 2
ORDER BY order_year, order_month;



-- ============================================================================
-- b. Monthly Trend Analysis using DATE_TRUNC()
-- Truncates order_date to the first day of the month (timestamp output)
-- ============================================================================
SELECT 
    DATE_TRUNC('month', order_date) AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATE_TRUNC('month', order_date)
ORDER BY DATE_TRUNC('month', order_date);



-- ============================================================================
-- c. Monthly Trend Analysis using TO_CHAR()
-- Formats order_date to 'YYYY-Mon' string (text output)
-- ============================================================================
SELECT 
    TO_CHAR(order_date, 'YYYY-Mon') AS order_month,
    SUM(sales_amount) AS total_sales,
    COUNT(DISTINCT customer_key) AS total_customers,
    SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY TO_CHAR(order_date, 'YYYY-Mon')
ORDER BY TO_CHAR(order_date, 'YYYY-Mon');
