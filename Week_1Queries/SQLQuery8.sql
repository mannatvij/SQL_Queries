-- 8. List of Customers who live in London and have bought something (placed an order)
SELECT DISTINCT
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    c.EmailAddress,
    g.City
FROM dbo.DimCustomer c
INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
INNER JOIN dbo.FactInternetSales f ON c.CustomerKey = f.CustomerKey
WHERE g.City = 'London'
ORDER BY c.LastName, c.FirstName;