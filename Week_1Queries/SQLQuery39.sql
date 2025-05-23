-- 39. Product name and total revenue from that product
SELECT 
    p.EnglishProductName,
    SUM(f.SalesAmount) as TotalRevenue,
    SUM(f.OrderQuantity) as TotalQuantitySold
FROM dbo.FactInternetSales f
INNER JOIN dbo.DimProduct p ON f.ProductKey = p.ProductKey
GROUP BY p.EnglishProductName
ORDER BY TotalRevenue DESC;
