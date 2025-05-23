-- 5. List of all products sorted by product name
SELECT 
    ProductKey,
    ProductAlternateKey,
    EnglishProductName,
    Color,
    Size,
    ListPrice
FROM dbo.DimProduct
WHERE ProductKey != 0  
ORDER BY EnglishProductName;