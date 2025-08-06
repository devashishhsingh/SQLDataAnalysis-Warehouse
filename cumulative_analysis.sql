-- ============================================================================
-- Cumulative Sales Analysis Over Time
-- ============================================================================
-- Objective:
-- Analyze cumulative performance of the business using window functions.
-- This helps to identify long-term trends such as consistent growth or decline.
-- ============================================================================

-- The query calculates:
-- 1. Total monthly sales
-- 2. Running total (cumulative) of sales over time
-- 3. Moving average of average price over time

SELECT
    order_date,
    total_sales,
    SUM(total_sales) OVER (ORDER BY order_date) AS running_total_sales,
    AVG(avg_price) OVER (ORDER BY order_date) AS moving_avg_price
FROM (
    SELECT 
        DATE_TRUNC('month', order_date) AS order_date,
        SUM(sales_amount) AS total_sales,
        AVG(price) AS avg_price
    FROM gold.fact_sales
    WHERE order_date IS NOT NULL
    GROUP BY DATE_TRUNC('month', order_date)
) AS monthly_summary;
