-- 22. List of Customer lastnames who have placed more than 10 orders
SELECT 
    c.LastName,
    COUNT(DISTINCT f.SalesOrderNumber) as NumberOfOrders
FROM dbo.DimCustomer c
INNER JOIN dbo.FactInternetSales f ON c.CustomerKey = f.CustomerKey
GROUP BY c.LastName
HAVING COUNT(DISTINCT f.SalesOrderNumber) > 10
ORDER BY NumberOfOrders DESC;