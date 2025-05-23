-- 33. List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.'
-- NOTE: DimProduct doesn't have supplier information, showing category structure
SELECT 
    p.EnglishProductName,
    pc.EnglishProductCategoryName,
    ps.EnglishProductSubcategoryName
FROM dbo.DimProduct p
INNER JOIN dbo.DimProductSubcategory ps ON p.ProductSubcategoryKey = ps.ProductSubcategoryKey
INNER JOIN dbo.DimProductCategory pc ON ps.ProductCategoryKey = pc.ProductCategoryKey
ORDER BY pc.EnglishProductCategoryName, ps.EnglishProductSubcategoryName, p.EnglishProductName;
