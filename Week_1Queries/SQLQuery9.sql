-- 9. List of customers who never placed an order
SELECT 
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    c.EmailAddress
FROM dbo.DimCustomer c
LEFT JOIN dbo.FactInternetSales f ON c.CustomerKey = f.CustomerKey
WHERE f.CustomerKey IS NULL
  AND c.CustomerKey != 0  
ORDER BY c.LastName, c.FirstName;