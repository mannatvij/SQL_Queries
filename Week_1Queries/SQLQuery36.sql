-- 36. List of top 10 countries by sales
SELECT TOP 10
    g.EnglishCountryRegionName as Country,
    SUM(f.SalesAmount) as TotalSales,
    COUNT(f.SalesOrderNumber) as NumberOfOrders
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimCustomer c ON f.CustomerKey = c.CustomerKey
INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
GROUP BY g.EnglishCountryRegionName
ORDER BY TotalSales DESC;