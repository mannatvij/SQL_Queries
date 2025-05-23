-- 23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
SELECT DISTINCT
    p.ProductKey,
    p.EnglishProductName,
    p.Status,
    COUNT(f.SalesOrderNumber) as TimesOrdered
FROM dbo.DimProduct p
INNER JOIN dbo.FactInternetSales f ON p.ProductKey = f.ProductKey
WHERE p.Status = 'Discontinued'
  AND f.OrderDate >= '1997-01-01'
  AND f.OrderDate < '1998-01-01'
GROUP BY p.ProductKey, p.EnglishProductName, p.Status
ORDER BY TimesOrdered DESC;
