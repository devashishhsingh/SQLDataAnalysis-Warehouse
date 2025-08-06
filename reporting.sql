/*
===============================================================================
Customer Report View
===============================================================================
Purpose:
- This report consolidates key customer metrics and behavioral insights.

Highlights:
1. Gathers essential fields such as names, ages, and transaction details.
2. Segments customers into categories (VIP, Regular, New) and age groups.
3. Aggregates customer-level metrics:
   - Total Orders
   - Total Sales
   - Total Quantity Purchased
   - Total Products Purchased
   - Lifespan (in months)
4. Calculates valuable KPIs:
   - Recency (months since last order)
   - Average Order Value (AOV)
   - Average Monthly Spend
===============================================================================
*/

CREATE VIEW gold_report_customers AS 

-- Step 1: Gather essential fields and join transactions with customer data
WITH base_query AS (
    SELECT 
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        EXTRACT(YEAR FROM AGE(NOW(), c.birthdate)) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c
        ON c.customer_key = f.customer_key
    WHERE f.order_date IS NOT NULL
),

-- Step 2: Aggregate metrics at customer level
customer_aggregation AS (
    SELECT 
        customer_key,
        customer_number,
        customer_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        EXTRACT(YEAR FROM AGE(MAX(order_date), MIN(order_date))) * 12 +
        EXTRACT(MONTH FROM AGE(MAX(order_date), MIN(order_date))) AS life_span_months
    FROM base_query
    GROUP BY customer_key, customer_number, customer_name, age
)

-- Step 3: Final Report with Segmentation and KPIs
SELECT 
    customer_key,
    customer_number,
    customer_name,
    age,

    -- Age group segmentation
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        ELSE '50 and above'
    END AS age_group,

    -- Customer segmentation based on sales and lifespan
    CASE 
        WHEN life_span_months >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN life_span_months >= 12 AND total_sales <= 5000 THEN 'REGULAR'
        ELSE 'NEW'
    END AS customer_segment,

    last_order_date,

    -- Recency in months (months since last order)
    EXTRACT(YEAR FROM AGE(NOW(), last_order_date)) * 12 +
    EXTRACT(MONTH FROM AGE(NOW(), last_order_date)) AS recency,

    total_orders,
    total_sales,
    total_quantity,
    total_products,
    life_span_months,

    -- Average Order Value (AOV)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders 
    END AS avg_order_value,

    -- Average Monthly Spend
    CASE 
        WHEN life_span_months = 0 THEN total_sales
        ELSE total_sales / life_span_months 
    END AS monthly_spent

FROM customer_aggregation;
