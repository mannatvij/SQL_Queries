-- 13. For each order get the OrderID and Average quantity of items in that order
SELECT 
    SalesOrderNumber,
    AVG(CAST(OrderQuantity AS FLOAT)) as AverageQuantity
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber
ORDER BY SalesOrderNumber;