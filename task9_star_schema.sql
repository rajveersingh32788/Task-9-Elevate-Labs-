-- Task 9: SQL Data Modeling - Star Schema
-- Database: MySQL
-- Dataset: Retail Sales Dataset

CREATE DATABASE IF NOT EXISTS task9_star_schema;
USE task9_star_schema;

-- ======================
-- Dimension Tables
-- ======================

CREATE TABLE IF NOT EXISTS dim_customer (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100),
    gender VARCHAR(10)
);

CREATE TABLE IF NOT EXISTS dim_product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_category VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS dim_date (
    date_id INT AUTO_INCREMENT PRIMARY KEY,
    sales_date DATE,
    year INT,
    month INT,
    day INT
);

-- ======================
-- Fact Table
-- ======================

CREATE TABLE IF NOT EXISTS fact_sales (
    sales_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    date_id INT,
    quantity INT,
    price DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES dim_customer(customer_id),
    FOREIGN KEY (product_id) REFERENCES dim_product(product_id),
    FOREIGN KEY (date_id) REFERENCES dim_date(date_id)
);

-- ======================
-- Insert Dimension Data
-- ======================

INSERT INTO dim_customer (customer_name, gender)
SELECT DISTINCT Customer, Gender FROM raw_sales;

INSERT INTO dim_product (product_category)
SELECT DISTINCT Product_Category FROM raw_sales;

INSERT INTO dim_date (sales_date, year, month, day)
SELECT DISTINCT Date, YEAR(Date), MONTH(Date), DAY(Date)
FROM raw_sales;

-- ======================
-- Insert Fact Data
-- ======================

INSERT INTO fact_sales (
    customer_id, product_id, date_id, quantity, price, total_amount
)
SELECT
    dc.customer_id,
    dp.product_id,
    dd.date_id,
    rs.Quantity,
    rs.Price,
    rs.Total_Amount
FROM raw_sales rs
JOIN dim_customer dc ON rs.Customer = dc.customer_name
JOIN dim_product dp ON rs.Product_Category = dp.product_category
JOIN dim_date dd ON rs.Date = dd.sales_date;
