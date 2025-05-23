-- 11. Details of first order of the system
SELECT TOP 1
    f.SalesOrderNumber,
    f.SalesOrderLineNumber,
    f.OrderDate,
    c.FirstName,
    c.LastName,
    p.EnglishProductName,
    f.OrderQuantity,
    f.UnitPrice,
    f.SalesAmount
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
INNER JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
ORDER BY f.OrderDate ASC, f.SalesOrderNumber ASC;