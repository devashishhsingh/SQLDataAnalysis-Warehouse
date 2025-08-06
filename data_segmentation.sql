-- ============================================================================
-- Product Cost Segmentation Analysis
-- ============================================================================
-- Objective:
-- Segment products into defined cost ranges and count how many products
-- fall into each segment. Useful for pricing strategy and inventory planning.
-- ============================================================================

-- Step 1: Assign each product to a cost range
WITH products_segment AS (
    SELECT 
        product_key,
        product_name,
        cost,
        CASE 
            WHEN cost < 100 THEN 'Below 100'
            WHEN cost BETWEEN 100 AND 500 THEN '100-500'
            WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
            ELSE 'Above 1000'
        END AS cost_range
    FROM gold.dim_products
)

-- Step 2: Count total products in each cost segment
SELECT 
    cost_range,
    COUNT(product_key) AS total_products
FROM products_segment
GROUP BY cost_range
ORDER BY total_products;
