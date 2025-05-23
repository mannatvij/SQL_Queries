-- 38. Orderdate of most expensive order
SELECT TOP 1
    OrderDate,
    SalesOrderNumber,
    SUM(SalesAmount) as OrderTotal
FROM dbo.FactInternetSales
GROUP BY OrderDate, SalesOrderNumber
ORDER BY OrderTotal DESC;
