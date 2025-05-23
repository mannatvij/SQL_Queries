-- 16. Get the OrderID and total quantity for each order that has a total quantity greater than 300
SELECT 
    SalesOrderNumber,
    SUM(OrderQuantity) as TotalQuantity
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber
HAVING SUM(OrderQuantity) > 300
ORDER BY TotalQuantity DESC;