-- 20. List of countries and sales made in each country
SELECT 
    g.EnglishCountryRegionName as Country,
    COUNT(f.SalesOrderNumber) as NumberOfOrders,
    SUM(f.SalesAmount) as TotalSales
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName
ORDER BY TotalSales DESC;