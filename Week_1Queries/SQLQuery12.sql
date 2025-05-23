-- 12. Find the details of most expensive order date
WITH OrderTotals AS (
    SELECT 
        OrderDate,
        SUM(SalesAmount) as DayTotal
    FROM dbo.FactInternetSales
    GROUP BY OrderDate
),
MaxOrderDate AS (
    SELECT TOP 1 OrderDate
    FROM OrderTotals
    ORDER BY DayTotal DESC
)
SELECT 
    f.OrderDate,
    f.SalesOrderNumber,
    c.FirstName,
    c.LastName,
    p.EnglishProductName,
    f.OrderQuantity,
    f.UnitPrice,
    f.SalesAmount,
    SUM(f.SalesAmount) OVER (PARTITION BY f.OrderDate) as DayTotal
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
INNER JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
INNER JOIN MaxOrderDate m ON f.OrderDate = m.OrderDate
ORDER BY f.SalesOrderNumber, f.SalesOrderLineNumber;