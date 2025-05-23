-- 29. List of orders placed by the best customer (highest total sales)
WITH BestCustomer AS (
    SELECT TOP 1 
        CustomerKey,
        SUM(SalesAmount) as TotalSales
    FROM dbo.FactInternetSales
    GROUP BY CustomerKey
    ORDER BY SUM(SalesAmount) DESC
)
SELECT 
    f.SalesOrderNumber,
    f.OrderDate,
    c.FirstName,
    c.LastName,
    p.EnglishProductName,
    f.OrderQuantity,
    f.SalesAmount
FROM dbo.FactInternetSales f
INNER JOIN BestCustomer bc ON f.CustomerKey = bc.CustomerKey
INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
INNER JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
ORDER BY f.OrderDate, f.SalesOrderNumber;