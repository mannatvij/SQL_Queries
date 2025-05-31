IF OBJECT_ID('dbo.vwCustomerOrdersYesterday', 'V') IS NOT NULL
    DROP VIEW dbo.vwCustomerOrdersYesterday;
GO
CREATE VIEW vwCustomerOrdersYesterday AS
SELECT 
    dc.FirstName + ' ' + dc.LastName AS CompanyName,
    fis.SalesOrderNumber AS OrderID,
    fis.OrderDate,
    fis.ProductKey AS ProductID,
    dp.EnglishProductName AS ProductName,
    fis.OrderQuantity AS Quantity,
    fis.UnitPrice,
    fis.OrderQuantity * fis.UnitPrice AS ExtendedPrice
FROM dbo.FactInternetSales fis
INNER JOIN dbo.DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
INNER JOIN dbo.DimProduct dp ON fis.ProductKey = dp.ProductKey
WHERE CAST(fis.OrderDate AS DATE) = CAST(DATEADD(DAY, -1, GETDATE()) AS DATE);
GO