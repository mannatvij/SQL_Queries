-- 14. For each order get the orderID, minimum quantity and maximum quantity for that order
SELECT 
    SalesOrderNumber,
    MIN(OrderQuantity) as MinimumQuantity,
    MAX(OrderQuantity) as MaximumQuantity
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber
ORDER BY SalesOrderNumber;