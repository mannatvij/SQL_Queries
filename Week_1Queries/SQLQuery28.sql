-- 28. List of Orders and ProductNames
SELECT 
    f.SalesOrderNumber,
    f.SalesOrderLineNumber,
    p.EnglishProductName,
    f.OrderQuantity,
    f.SalesAmount
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
ORDER BY f.SalesOrderNumber, f.SalesOrderLineNumber;