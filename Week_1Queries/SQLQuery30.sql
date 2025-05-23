-- 30. List of orders placed by customers who do not have a Fax number

SELECT 
    f.SalesOrderNumber,
    f.OrderDate,
    c.FirstName,
    c.LastName,
    f.SalesAmount
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
WHERE c.Phone IS NULL OR c.Phone = '' 
ORDER BY f.OrderDate;

