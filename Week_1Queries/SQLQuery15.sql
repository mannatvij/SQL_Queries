-- 15. Get a list of all managers and total number of employees who report to them
SELECT 
    m.EmployeeKey as ManagerKey,
    m.FirstName + ' ' + m.LastName as ManagerName,
    m.Title as ManagerTitle,
    COUNT(e.EmployeeKey) as NumberOfReports
FROM dbo.DimEmployee m
INNER JOIN dbo.DimEmployee e ON m.EmployeeKey = e.ParentEmployeeKey
GROUP BY m.EmployeeKey, m.FirstName, m.LastName, m.Title
ORDER BY NumberOfReports DESC;
