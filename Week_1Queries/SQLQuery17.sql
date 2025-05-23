-- 17. List of all orders placed on or after 1996/12/31
SELECT 
    SalesOrderNumber,
    SalesOrderLineNumber,
    OrderDate,
    CustomerKey,
    ProductKey,
    OrderQuantity,
    SalesAmount
FROM dbo.FactInternetSales
WHERE OrderDate >= '1996-12-31'
ORDER BY OrderDate, SalesOrderNumber;