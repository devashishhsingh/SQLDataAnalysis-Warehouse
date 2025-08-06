-- ============================================================================
-- Yearly Product Sales Performance Analysis
-- ============================================================================
-- Objective:
-- Analyze yearly performance of products by comparing:
--   - Current year's sales
--   - Average sales across all years
--   - Previous year's sales (YoY comparison)
-- ============================================================================
-- Insights:
-- - Detect products performing above or below average
-- - Measure sales growth or decline YoY
-- ============================================================================

-- Step 1: Aggregate yearly sales for each product
WITH yearly_product_sales AS (
    SELECT 
        EXTRACT(YEAR FROM f.order_date) AS order_year,
        p.product_name,
        SUM(f.sales_amount) AS current_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON f.product_key = p.product_key
    WHERE f.order_date IS NOT NULL
    GROUP BY EXTRACT(YEAR FROM f.order_date), p.product_name
)

-- Step 2: Analyze sales vs. average & previous year
SELECT 
    order_year,
    product_name,
    current_sales,

    -- Average sales per product across all years
    AVG(current_sales) OVER (PARTITION BY product_name) AS avg_sales,

    -- Difference between current and average sales
    current_sales - AVG(current_sales) OVER (PARTITION BY product_name) AS diff_avg,

    -- Sales performance label vs. average
    CASE 
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) > 0 THEN 'Above Avg'
        WHEN current_sales - AVG(current_sales) OVER (PARTITION BY product_name) < 0 THEN 'Below Avg'
        ELSE 'Avg'
    END AS avg_change,

    -- Previous year's sales (YoY)
    LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_sales,

    -- Difference from previous year's sales
    current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) AS py_year,

    -- YoY sales change label
    CASE 
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increased'
        WHEN current_sales - LAG(current_sales) OVER (PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decreased'
        ELSE 'No Change'
    END AS py_change

FROM yearly_product_sales
ORDER BY product_name, order_year;
