/*
===============================================================================
Stored Procedure: to load few data to databases financial_transaction_db
===============================================================================
Script Purpose:
 This stored procedure loads data into the table generated from the script. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
	- this script is for generate few data

How to run : EXEC financial_transaction_db_large
Warning : Before run this script make sure to choose financial_transaction_db,
		  you can use 'USE financial_transaction_db;' before EXEC or choose
		  financial_transaction_db in Available Database.
          This script would delete all data and recreate it again.
===============================================================================
*/
USE financial_transactions_db;
GO

CREATE OR ALTER PROCEDURE financial_transaction_db_fewer AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch DATETIME, @end_batch DATETIME
	BEGIN TRY
		SET @start_batch = GETDATE();
		PRINT '============================================================';
		PRINT 'Loading financial_transaction_db_large database';
		PRINT '============================================================';


		PRINT '------------------------------------------------------------';
		PRINT 'Loading financial_transactions Table';
		PRINT '------------------------------------------------------------';

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : financial_transactions'
		TRUNCATE TABLE financial_transactions;
		PRINT '>> Generate and Insert Data Into : financial_transactions'
		DECLARE @counter INT
		SET NOCOUNT ON;
		INSERT INTO financial_transactions (transaction_id, customer_id, supplier_name, transaction_date, amount, currency)
		VALUES
			(1, 101, 'ABC Corp', '2024-01-15', 1000.00, 'USD'),
			(2, 102, 'XYZ Ltd', '2024-01-20', 1500.50, 'EUR'),
			(3, 103, 'Global Inc', '2024-02-05', 2000.00, 'GBP'),
			(4, 104, 'ABC Corp', '2024-02-10', 500.25, 'USD');
		set @counter = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> TOTAL LOAD ROW : ' + CAST(@counter AS NVARCHAR) + ' rows'
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : customer_details'
		TRUNCATE TABLE customer_details;
		PRINT '>> Generate and Insert Data Into : customer_details'
		DECLARE @customer_details_row INT;
		INSERT INTO customer_details (customer_id, customer_name, email, phone)
		VALUES
			(101, 'John Doe', 'john.doe@example.com', '123-456-7890'),
			(102, 'Jane Smith', 'jane.smith@example.com', '234-567-8901'),
			(103, 'Mike Johnson', 'mike.johnson@example.com', '345-678-9012'),
			(104, 'Emily Davis', 'emily.davis@example.com', '456-789-0123');
		SET @customer_details_row = @@ROWCOUNT;
		SET @end_time = GETDATE();
		PRINT '>> TOTAL LOAD ROW : ' + CAST( @customer_details_row AS NVARCHAR) + ' rows'
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------'

	END TRY

	BEGIN CATCH
		PRINT '====================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message' + ERROR_MESSAGE();
		PRINT 'Error Message' + CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '====================================================================';
	END CATCH

END