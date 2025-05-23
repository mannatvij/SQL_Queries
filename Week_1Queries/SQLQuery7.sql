-- 7. List of customers who ever placed an order
SELECT DISTINCT
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    c.EmailAddress
FROM dbo.DimCustomer c
INNER JOIN dbo.FactInternetSales f ON c.CustomerKey = f.CustomerKey
ORDER BY c.LastName, c.FirstName;