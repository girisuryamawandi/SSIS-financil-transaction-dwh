/*
===============================================================================
DDL Script: Create Table for financial_transaction_db and financial_data_warehouse
===============================================================================
Script Purpose:
   This script for creating table in financial_transaction_db and financial_data_warehouse, 
   dropping table if the table is exist.
   Run this script to re-define the table
===============================================================================
*/
USE financial_transactions_db;
GO

IF OBJECT_ID('financial_transactions', 'U') IS NOT NULL
    DROP TABLE financial_transactions;
GO

CREATE TABLE financial_transactions (
    transaction_id INT PRIMARY KEY,
    customer_id INT,
    supplier_name VARCHAR(50),
    transaction_date DATE,
    amount DECIMAL(10, 2),
    currency VARCHAR(10)
);

IF OBJECT_ID('customer_details', 'U') IS NOT NULL
    DROP TABLE  customer_details;
GO

CREATE TABLE customer_details (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    email VARCHAR(100),
    phone VARCHAR(20)
);
GO


USE financial_data_warehouse;
Go

IF OBJECT_ID('financial_analysis', 'U') IS NOT NULL
    DROP TABLE financial_analysis;
GO

CREATE TABLE financial_analysis (
    transaction_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    supplier_name VARCHAR(50),
    transaction_date DATE,
    amount_usd DECIMAL(10, 2),
    supplier_phone VARCHAR(20)
);