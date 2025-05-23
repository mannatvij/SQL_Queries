-- 35. List of products where units in stock is less than 10 and units on order are 0
SELECT 
    ProductKey,
    EnglishProductName,
    'Need to verify stock columns in DimProduct' as Note
FROM dbo.DimProduct;