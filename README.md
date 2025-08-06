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



