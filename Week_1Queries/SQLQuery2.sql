-- 2. List of all customers where company name ending in N
-- Note: DimCustomer table doesn't have CompanyName column
-- Alternative: Customers where LastName ends in N
SELECT 
    CustomerKey,
    FirstName,
    LastName,
    EmailAddress
FROM dbo.DimCustomer
WHERE LastName LIKE '%N'
ORDER BY LastName;