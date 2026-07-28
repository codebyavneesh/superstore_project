-- =================
-- Create Database
-- ================
CREATE DATABASE superStoreDB;

-- =============
-- Use Database
-- =============
USE superStoreDB;

-- ==============
-- Create Tables
-- ==============
CREATE TABLE sales(
    Row_ID INT PRIMARY KEY AUTO_INCREMENT,
    Order_ID VARCHAR(20),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(20),
    Customer_ID VARCHAR(20),
    Customer_Name VARCHAR(100),
    Segment VARCHAR(20),
    Country VARCHAR(30),
    City VARCHAR(40),
    State VARCHAR(40),
    Postal_Code VARCHAR(50),
    Region VARCHAR(50),
    Product_ID VARCHAR(40),
    Category VARCHAR(50),
    Sub_Category VARCHAR(50),
    Product_Name VARCHAR(50),
    Sales DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(5, 2),
    Profit DECIMAL(10, 2)
);

-- ============
-- Show Tables
-- ============
SELECT
    *
FROM sales 
LIMIT 10;

