/*
=============================================================
Create Database
=============================================================
Script Purpose:
Create databases for financial data management:
	1. 'financial_transactions_db'   : Database for raw/resource data.
	2. 'financial_data_warehouse'    : Database for data warehouse.


WARNING:
    Running this script will drop the entire 'financial_transactions_db' and 'financial_data_warehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
    Ensure to backup data before using it. 
*/

USE master;
Go

-- Drop and recreate the financial_transactions_db
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'financial_transactions_db')
BEGIN 
	ALTER DATABASE financial_transactions_db
	SET SINGLE_USER 
	WITH ROLLBACK IMMEDIATE;
	DROP DATABASE financial_transactions_db;
END;
GO


-- Drop and recreate the financial_transactions_db
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'financial_data_warehouse')
BEGIN 
	ALTER DATABASE financial_data_warehouse
	SET SINGLE_USER 
	WITH ROLLBACK IMMEDIATE;
	DROP DATABASE financial_data_warehouse;
END;
GO

