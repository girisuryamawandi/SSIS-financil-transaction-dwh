/*
===============================================================================
Stored Procedure: Generate data to load to databases financial_transaction_db
===============================================================================
Script Purpose:
 This stored procedure loads data into the table generated from the script. 
    It performs the following actions:
    - Truncates the bronze tables before loading data.
    - Uses looping until declaring number to generate the data.
	- this script is for generate large data

How to run : EXEC financial_transaction_db_large
Warning : Before run this script make sure to choose financial_transaction_db,
		  you can use 'USE financial_transaction_db;' before EXEC or choose
		  financial_transaction_db in Available Database.
          This script would delete all data and recreate it again.
===============================================================================
*/
USE financial_transactions_db;
GO


CREATE OR ALTER PROCEDURE financial_transaction_db_large AS
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

		DECLARE @counter INT = 1;
		set nocount on;
		WHILE @counter <= 1000000
		BEGIN
			INSERT INTO financial_transactions (transaction_id, customer_id, supplier_name, transaction_date, amount, currency)
			VALUES
				(@counter, (101 + (@counter % 1000)), 
				 CASE 
					WHEN @counter % 3 = 0 THEN 'ABC Corp'
					WHEN @counter % 3 = 1 THEN 'XYZ Ltd'
					ELSE 'Global Inc'
				 END,
				 DATEADD(DAY, @counter % 365, '2024-01-01'),
				 ROUND(RAND() * 10000, 2),
				 CASE 
					WHEN @counter % 4 = 0 THEN 'USD'
					WHEN @counter % 4 = 1 THEN 'EUR'
					ELSE 'GBP'
				 END);
			SET @counter = @counter + 1;
		END;

		SET @end_time = GETDATE();
		PRINT '>> TOTAL LOAD ROW : ' + CAST(@counter - 1 AS NVARCHAR) + ' rows'
		PRINT '>> LOAD DURATION : ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '---------------------'

		SET @start_time = GETDATE();
		PRINT '>> Truncating Table : customer_details'
		TRUNCATE TABLE customer_details;
		PRINT '>> Generate and Insert Data Into : customer_details'
		DECLARE @customer_id INT = 101;
		WHILE @customer_id <= 1100
		BEGIN
			INSERT INTO customer_details (customer_id, customer_name, email, phone)
			VALUES
				(@customer_id, CONCAT('Customer ', @customer_id), CONCAT('customer', @customer_id, '@example.com'), 
				CONCAT('123-456-', RIGHT('0000' + CAST(@customer_id AS VARCHAR(4)), 4)));
			SET @customer_id = @customer_id + 1;
		END;
		SET @end_time = GETDATE();
		PRINT '>> TOTAL LOAD ROW : ' + CAST(@customer_id - 101 AS NVARCHAR) + ' rows'
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