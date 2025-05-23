-- 10. List of customers who ordered Tofu (assuming product name contains 'Tofu')
SELECT DISTINCT
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    c.EmailAddress,
    p.EnglishProductName
FROM dbo.DimCustomer c
INNER JOIN dbo.FactInternetSales f ON c.CustomerKey = f.CustomerKey
INNER JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
WHERE p.EnglishProductName LIKE '%Tofu%'
ORDER BY c.LastName, c.FirstName;