-- 41. Top ten customers based on their business
SELECT TOP 10
    c.CustomerKey,
    c.FirstName + ' ' + c.LastName as CustomerName,
    SUM(f.SalesAmount) as TotalBusiness,
    COUNT(DISTINCT f.SalesOrderNumber) as NumberOfOrders
FROM dbo.DimCustomer c
INNER JOIN dbo.FactInternetSales f ON c.CustomerKey = f.CustomerKey
GROUP BY c.CustomerKey, c.FirstName, c.LastName
ORDER BY TotalBusiness DESC;
