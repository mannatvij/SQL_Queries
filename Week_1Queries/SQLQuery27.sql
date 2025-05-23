-- 27. List of managers who have more than four people reporting to them
SELECT 
    m.EmployeeKey as ManagerKey,
    m.FirstName + ' ' + m.LastName as ManagerName,
    m.Title,
    COUNT(e.EmployeeKey) as NumberOfReports
FROM dbo.DimEmployee m
INNER JOIN dbo.DimEmployee e ON m.EmployeeKey = e.ParentEmployeeKey
GROUP BY m.EmployeeKey, m.FirstName, m.LastName, m.Title
HAVING COUNT(e.EmployeeKey) > 4
ORDER BY NumberOfReports DESC;