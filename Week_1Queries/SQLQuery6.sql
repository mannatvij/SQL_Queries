-- 6. List of all products where product name starts with an A
SELECT 
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    Color,
    Size,
    ListPrice
FROM dbo.DimProduct
WHERE EnglishProductName LIKE 'A%'
ORDER BY EnglishProductName;