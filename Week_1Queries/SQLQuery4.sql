-- 4. List of all customers who live in UK or USA
SELECT 
    c.CustomerKey,
    c.FirstName,
    c.LastName,
    c.EmailAddress,
    g.CountryRegionCode,
    g.EnglishCountryRegionName
FROM dbo.DimCustomer c
INNER JOIN dbo.DimGeography g ON c.GeographyKey = g.GeographyKey
WHERE g.CountryRegionCode IN ('GB', 'US') -- UK = GB, USA = US
ORDER BY g.EnglishCountryRegionName, c.LastName;