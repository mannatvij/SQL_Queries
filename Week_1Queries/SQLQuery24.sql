-- 24. List of employee firstname, lastname, superviser FirstName, LastName
SELECT 
    e.FirstName as EmployeeFirstName,
    e.LastName as EmployeeLastName,
    s.FirstName as SupervisorFirstName,
    s.LastName as SupervisorLastName
FROM dbo.DimEmployee e
LEFT JOIN dbo.DimEmployee s ON e.ParentEmployeeKey = s.EmployeeKey
ORDER BY e.LastName, e.FirstName;