-- 19. List of all orders with order total > 200
SELECT 
    SalesOrderNumber,
    SUM(SalesAmount) as OrderTotal,
    COUNT(*) as LineCount
FROM dbo.FactInternetSales
GROUP BY SalesOrderNumber
HAVING SUM(SalesAmount) > 200
ORDER BY OrderTotal DESC;