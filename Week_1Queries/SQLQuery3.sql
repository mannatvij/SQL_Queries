-- 3. List of all customers who live in Berlin or London
SELECT 
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    c.EmailAddress,
    g.City
FROM dbo.DimCustomer c
INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
WHERE g.City IN ('Berlin', 'London')
ORDER BY g.City, c.LastName;