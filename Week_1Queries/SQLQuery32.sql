-- 32. List of product Names that were shipped to France
SELECT DISTINCT p.EnglishProductName
FROM dbo.FactInternetSales s
JOIN dbo.DimProduct p ON s.ProductKey = p.ProductKey
JOIN dbo.DimCustomer c ON s.CustomerKey = c.CustomerKey
JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
WHERE g.CountryRegionCode = 'FR';