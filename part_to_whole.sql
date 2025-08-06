-- ============================================================================
-- Part-to-Whole Analysis: Category Contribution to Total Sales
-- ============================================================================
-- Objective:
-- Identify which product categories contribute the most to overall sales.
-- Uses window functions to calculate the proportion of each category's sales.
-- ============================================================================

-- Step 1: Aggregate total sales per category
WITH category_sales AS (
    SELECT 
        p.category,
        SUM(f.sales_amount) AS total_sales
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
        ON p.product_key = f.product_key
    GROUP BY p.category
)

-- Step 2: Calculate percentage contribution of each category
SELECT 
    category,
    total_sales,
    SUM(total_sales) OVER () AS overall_sales,

    -- Calculate and format category's contribution as a percentage of total
    CONCAT(
        ROUND(
            (total_sales::NUMERIC / SUM(total_sales) OVER ()::NUMERIC) * 100, 
        2), '%'
    ) AS percentage_of_total

FROM category_sales;
