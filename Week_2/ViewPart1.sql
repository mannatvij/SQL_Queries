DROP VIEW IF EXISTS vwCustomerOrders;
GO
CREATE VIEW vwCustomerOrders AS
SELECT 
    dc.FirstName + ' ' + dc.LastName AS CompanyName,  -- Using customer name as company name
    fis.SalesOrderNumber AS OrderID,
    fis.OrderDate,
    fis.ProductKey AS ProductID,
    dp.EnglishProductName AS ProductName,
    fis.OrderQuantity AS Quantity,
    fis.UnitPrice,
    fis.OrderQuantity * fis.UnitPrice AS ExtendedPrice
FROM dbo.FactInternetSales fis
INNER JOIN dbo.DimCustomer dc ON fis.CustomerKey = dc.CustomerKey
INNER JOIN dbo.DimProduct dp ON fis.ProductKey = dp.ProductKey;