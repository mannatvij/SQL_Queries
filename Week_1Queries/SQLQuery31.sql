-- 31 List of Postal codes where the product Tofu was shipped

SELECT DISTINCT g.PostalCode
FROM dbo.FactInternetSales s
JOIN dbo.DimProduct p ON s.ProductKey = p.ProductKey
JOIN dbo.DimCustomer c ON s.CustomerKey = c.CustomerKey
JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
WHERE p.EnglishProductName = 'Tofu';