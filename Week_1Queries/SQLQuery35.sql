-- 35. List of products where units in stock is less than 10 and units on order are 0
-- NOTE: Need to check if DimProduct has stock columns
SELECT 
    ProductKey,
    EnglishProductName,
    'Need to verify stock columns in DimProduct' as Note
FROM dbo.DimProduct;