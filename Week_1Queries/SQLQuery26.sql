-- 26. List of employees whose FirstName contains character 'a'
SELECT 
    EmployeeKey,
    FirstName,
    LastName,
    Title
FROM dbo.DimEmployee
WHERE FirstName LIKE '%a%'
ORDER BY FirstName;