# SQLDataAnalysis-Warehouse
This project includes in-depth analysis and explains the true meaning behind each query.


##  Data Warehouse Analytics Setup Guide

###  Step 1: Create Database

You can use **PostgreSQL** or **MySQL**—whichever server you're working with. The process remains the same.

You have **two options** for creating and loading the project database:

#### Option 1: Run SQL Script

Create the project database by executing the provided SQL scripts.

#### Option 2: Direct Import

Import `.sql` or `.csv` files directly into your database using a database GUI or CLI tool.

Before proceeding, check if the database already exists and drop it to avoid conflicts:

```sql
-- Drop the database if it exists (PostgreSQL syntax shown)
DROP DATABASE IF EXISTS "DataWarehouseAnalytics";
```

---

###  Step 2: Create Schema and Tables

Switch to the newly created database and run the following:

```sql
-- Create schema
CREATE SCHEMA gold;

-- Create dimension and fact tables
CREATE TABLE gold.dim_customers (
    customer_key INT,
    customer_id INT,
    customer_number VARCHAR(50),
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    country VARCHAR(50),
    marital_status VARCHAR(50),
    gender VARCHAR(50),
    birthdate DATE,
    create_date DATE
);

CREATE TABLE gold.dim_products (
    product_key INT,
    product_id INT,
    product_number VARCHAR(50),
    product_name VARCHAR(50),
    category_id VARCHAR(50),
    category VARCHAR(50),
    subcategory VARCHAR(50),
    maintenance VARCHAR(50),
    cost INT,
    product_line VARCHAR(50),
    start_date DATE
);

CREATE TABLE gold.fact_sales (
    order_number VARCHAR(50),
    product_key INT,
    customer_key INT,
    order_date DATE,
    shipping_date DATE,
    due_date DATE,
    sales_amount INT,
    quantity SMALLINT,
    price INT
);
```
### 2. Import CSV Data

* Right-click on the `dim_sustomer` or `dim_products` or `facts_sales`  table → Import/Export.
* **General Tab**:

  * File Name: /gold.fact_sales.csv
  * Format: `CSV`
  * Encoding: `UTF8`
 src="<img width="871" height="674" alt="image" src="https://github.com/user-attachments/assets/483f7c6a-8075-43f3-862d-a7bb4b2bcae4" />

---

This project employs **six core SQL analytical techniques** to extract insights from sales, customer, and product data. Each method serves a unique purpose in understanding trends, behavior, and segmentation for better decision-making.

---

## 1.  **Sales Trend Analysis (Time Series)**

###  Purpose:

Understand how sales performance evolves over time by analyzing monthly and yearly sales, customer activity, and quantity sold.

###  Techniques Used:

* `EXTRACT(YEAR | MONTH FROM date)`
* `DATE_TRUNC('month', date)`
* `TO_CHAR(date, 'YYYY-Mon')`

### 🛠 Key Metrics:

* Total Sales per Month/Year
* Total Unique Customers
* Total Quantity Sold

###  Use Case:

Visualizing time-based patterns, seasonal effects, or year-over-year performance for dashboards and planning.

---

## 2.  **Cumulative Sales Analysis**

###  Purpose:

Track how sales accumulate over time and observe trends in average price.

###  Techniques Used:

* `SUM(...) OVER (ORDER BY date)`
* `AVG(...) OVER (ORDER BY date)`
* Nested subqueries with `DATE_TRUNC`

###  Key Metrics:

* Running Total of Sales
* Moving Average of Product Prices

###  Use Case:

Measuring consistent growth or decline, evaluating promotions or long-term strategies.

---

## 3.  **Year-Over-Year Product Performance**

###  Purpose:

Compare each product's sales to its historical average and previous year's sales to evaluate growth, decline, or stagnation.

###  Techniques Used:

* Window functions: `LAG()`, `AVG() OVER (PARTITION BY ...)`
* Yearly grouping with `EXTRACT(YEAR FROM date)`

###  Key Metrics:

* Current Year Sales
* Average Sales Across Years
* Sales Change vs. Previous Year
* Segmentation: Increased, Decreased, No Change

###  Use Case:

Performance reviews, inventory planning, trend forecasting.

---

## 4.  **Part-to-Whole Analysis (Category Contribution)**

###  Purpose:

Analyze the proportion of total sales contributed by each product category.

###  Techniques Used:

* `SUM(...) OVER ()`
* Ratio calculation and formatting with `ROUND()` + `CONCAT()`

### 🛠 Key Metrics:

* Category-wise Sales
* % Share of Total Sales

###  Use Case:

Highlighting high-performing categories and identifying underperformers for strategy alignment.

---

## 5.  **Product Segmentation by Cost Ranges**

###  Purpose:

Segment products into defined cost brackets to understand pricing tiers and product distribution.

###  Techniques Used:

* `CASE WHEN` logic for bucket segmentation

###  Key Metrics:

* Number of Products per Cost Range

###  Use Case:

Price band analysis, inventory categorization, targeting based on cost sensitivity.

---

## 6.  **Customer Behavioral and Segment Report**

###  Purpose:

Create a comprehensive customer profile by analyzing demographics, purchase history, and behavior.

###  Techniques Used:

* Joins between sales and customer data
* `AGE()`, `NOW()`, `EXTRACT()`, `CASE WHEN`
* `GROUP BY` customer-level
* Metrics derived from lifespan, recency, AOV, and frequency

###  Key Metrics:

* Total Orders, Sales, Quantity, Products
* Lifespan in Months
* Recency (Months since last order)
* AOV (Average Order Value)
* Monthly Spend
* Customer Segments: VIP, Regular, New
* Age Groups

###  Use Case:

CRM strategies, targeted marketing, loyalty programs, and lifetime value modeling.

---


