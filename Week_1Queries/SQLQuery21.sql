-- 21. List of Customer ContactName and number of orders they placed
-- NOTE: DimCustomer doesn't have ContactName, using FirstName + LastName
SELECT 
    c.CustomerKey,
    c.FirstName + ' ' + c.LastName as CustomerName,
    COUNT(f.SalesOrderNumber) as NumberOfOrders
FROM dbo.DimCustomer c
INNER JOIN dbo.FactInternetSales f ON c.CustomerKey = f.CustomerKey
GROUP BY c.CustomerKey, c.FirstName, c.LastName
ORDER BY NumberOfOrders DESC;