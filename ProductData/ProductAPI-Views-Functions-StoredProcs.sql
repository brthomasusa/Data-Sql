-- Function Production.GetUnitOfMeasureName
if OBJECT_ID('Production.GetUnitOfMeasureName') is not NULL
    DROP FUNCTION Production.GetUnitOfMeasureName
GO

CREATE FUNCTION Production.GetUnitOfMeasureName
(
    @unitMeasureCode  NCHAR(3)
)
RETURNS NVARCHAR(50) AS
BEGIN
    DECLARE @name AS NVARCHAR(50);

    SELECT @name= Name FROM Production.UnitMeasure WHERE UnitMeasureCode = @unitMeasureCode;

    RETURN @name;
END
GO

-- View Production.vProductDetailViewModel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [Production].[vProductDetailViewModel] 
AS 
	SELECT 
		prod.ProductID, 
		prod.Name, 
		prod.ProductNumber, 
		prod.MakeFlag, 
		prod.FinishedGoodsFlag, 
		prod.Color, 
		prod.SafetyStockLevel, 
		prod.ReorderPoint, 
		prod.StandardCost,
		prod.ListPrice, 
		prod.Size, 
		Production.GetUnitOfMeasureName(prod.SizeUnitMeasureCode) AS SizeUnitOfMeasurement, 
		Production.GetUnitOfMeasureName(prod.WeightUnitMeasureCode) AS WeightUnitOfMeasurement, 
		prod.Weight, 
		prod.DaysToManufacture, 
		prod.ProductLine, 
		prod.Class,
		prod.Style, 
		subcat.Name AS ProductSubCategory, 
		model.Name AS ProductModel, 
		prod.SellStartDate, 
		prod.SellEndDate, 
		prod.DiscontinuedDate
	FROM Production.Product prod
	LEFT JOIN Production.ProductSubCategory subcat ON prod.ProductSubcategoryID = subcat.ProductSubcategoryID
	LEFT JOIN Production.ProductModel model ON prod.ProductModelID = model.ProductModelID;
GO

-- View Production.vProductListItemViewModel
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE OR ALTER VIEW [Production].[vProductListItemViewModel] 
AS 
	SELECT 
		prod.ProductID, 
		prod.Name, 
		prod.ProductNumber, 
		prod.MakeFlag, 
		prod.FinishedGoodsFlag, 
		prod.StandardCost,
		prod.ListPrice, 
		prod.DaysToManufacture, 
		subcat.Name AS ProductSubCategory, 
		model.Name AS ProductModel, 
		prod.SellStartDate, 
		prod.SellEndDate, 
		prod.DiscontinuedDate
	FROM Production.Product prod
	LEFT JOIN Production.ProductSubCategory subcat ON prod.ProductSubcategoryID = subcat.ProductSubcategoryID
	LEFT JOIN Production.ProductModel model ON prod.ProductModelID = model.ProductModelID;
GO

-- Production.spGetProductListIemsByName
CREATE OR ALTER PROCEDURE [Production].[spGetProductListIemsByName] 
	@searchCriteria NVARCHAR(30),
	@skip int,
	@take int
AS 
SET NOCOUNT ON
BEGIN 
    SELECT 
		ProductID, 
		[Name], 
		ProductNumber, 
		MakeFlag, 
		FinishedGoodsFlag, 
		StandardCost,
		ListPrice,  
		DaysToManufacture,  
		ProductSubCategory, 
		ProductModel, 
		SellStartDate, 
		SellEndDate, 
		DiscontinuedDate 
	from Production.vProductListItemViewModel
	WHERE [Name] LIKE '%'+IsNull(@searchCriteria,[Name])+'%'
    ORDER BY [Name]     
	OFFSET @skip ROWS FETCH NEXT @take ROWS ONLY;
END
GO
