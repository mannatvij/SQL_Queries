-- 18. List of all orders shipped to Canada
SELECT 
    f.SalesOrderNumber,
    f.OrderDate,
    f.ShipDate,
    c.FirstName,
    c.LastName,
    g.EnglishCountryRegionName
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
WHERE g.EnglishCountryRegionName = 'Canada'
ORDER BY f.OrderDate;