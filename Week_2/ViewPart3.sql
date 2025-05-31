IF OBJECT_ID('dbo.MyProducts', 'V') IS NOT NULL
    DROP VIEW dbo.MyProducts;
GO
CREATE VIEW MyProducts AS
SELECT 
    dp.ProductKey AS ProductID,
    dp.EnglishProductName AS ProductName,
    dp.Size AS QuantityPerUnit,
    dp.ListPrice AS UnitPrice,
    dpc.EnglishProductCategoryName AS CategoryName
FROM dbo.DimProduct dp
INNER JOIN dbo.DimProductSubcategory dps ON dp.ProductSubcategoryKey = dps.ProductSubcategoryKey
INNER JOIN dbo.DimProductCategory dpc ON dps.ProductCategoryKey = dpc.ProductCategoryKey
WHERE dp.Status IS NULL OR dp.Status <> 'Discontinued';
GO