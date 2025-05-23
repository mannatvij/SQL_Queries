-- 42. What is the total revenue of the company
SELECT 
    SUM(SalesAmount) as TotalCompanyRevenue,
    COUNT(DISTINCT SalesOrderNumber) as TotalOrders,
    COUNT(*) as TotalLineItems
FROM dbo.FactInternetSales;
