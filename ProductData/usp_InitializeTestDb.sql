-- Reset test data stored proc
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Used to load the database
CREATE OR ALTER  Proc [dbo].[usp_InitializeTestDb]
as
BEGIN
    BEGIN TRAN
        BEGIN TRY            

            Delete from Production.Product;            

            DBCC CHECKIDENT ("Production.Product", RESEED, 0);                    

            -- Production.Product
			SET IDENTITY_INSERT Production.Product ON;
			INSERT INTO Production.Product
				([ProductID],[Name],[ProductNumber],[MakeFlag],[FinishedGoodsFlag],[Color],[SafetyStockLevel],[ReorderPoint],[StandardCost],[ListPrice],[Size],[SizeUnitMeasureCode],[WeightUnitMeasureCode],[Weight],[DaysToManufacture],[ProductLine],[Class],[Style],[ProductSubcategoryID],[ProductModelID],[SellStartDate],[SellEndDate],[DiscontinuedDate],[rowguid],[ModifiedDate])
			SELECT TOP (25)
				[ProductID],[Name],[ProductNumber],[MakeFlag],[FinishedGoodsFlag],[Color],[SafetyStockLevel],[ReorderPoint],[StandardCost],[ListPrice],[Size],[SizeUnitMeasureCode],[WeightUnitMeasureCode],[Weight],[DaysToManufacture],[ProductLine],[Class],[Style],[ProductSubcategoryID],[ProductModelID],[SellStartDate],[SellEndDate],[DiscontinuedDate],[rowguid],[ModifiedDate]
			FROM AdventureWorks2019.Production.Product;
			SET IDENTITY_INSERT Production.Product OFF;

			INSERT INTO Production.Product
				([Name],[ProductNumber],[MakeFlag],[FinishedGoodsFlag],[Color],[SafetyStockLevel],[ReorderPoint],[StandardCost],[ListPrice],[Size],[SizeUnitMeasureCode],[WeightUnitMeasureCode],[Weight],[DaysToManufacture],[ProductLine],[Class],[Style],[ProductSubcategoryID],[ProductModelID],[SellStartDate],[SellEndDate],[DiscontinuedDate])
			VALUES ('Non-adjustable Race', 'NR-5381',0,0,null,1000,750,0.00,0.00,null,null,null,null,0,null,null,null,null,null, '2008-04-30',null,null);

            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
                -- if error, roll back any chanegs done by any of the sql statements
                ROLLBACK TRANSACTION

                SELECT
                    ERROR_NUMBER() AS ErrorNumber,
                    -- ERROR_STATE() AS ErrorState,
                    -- ERROR_SEVERITY() AS ErrorSeverity,
                    -- ERROR_PROCEDURE() AS ErrorProcedure,
                    ERROR_LINE() AS ErrorLine,
                    ERROR_MESSAGE() AS ErrorMessage;                
        END CATCH    
END
GO
