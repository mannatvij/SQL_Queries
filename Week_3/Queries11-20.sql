--Task 11
SELECT DISTINCT s1.Name
FROM Students s1
JOIN Friends f ON s1.ID = f.ID
JOIN Students s2 ON f.Friend_ID = s2.ID
JOIN Packages p1 ON s1.ID = p1.ID
JOIN Packages p2 ON s2.ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY s1.Name;

--Task 12
SELECT 
    job_family,
    ROUND(
        (SUM(CASE WHEN country = 'India' THEN cost ELSE 0 END) * 100.0 / 
         SUM(CASE WHEN country != 'India' THEN cost ELSE 0 END)), 2
    ) AS cost_ratio_percentage
FROM job_costs 
GROUP BY job_family;

--Task 13
SELECT 
    business_unit,
    month_year,
    cost,
    revenue,
    ROUND((cost * 1.0 / revenue), 4) AS cost_revenue_ratio,
    ROUND((cost * 1.0 / LAG(cost) OVER (PARTITION BY business_unit ORDER BY month_year)), 4) AS cost_ratio_mom,
    ROUND((revenue * 1.0 / LAG(revenue) OVER (PARTITION BY business_unit ORDER BY month_year)), 4) AS revenue_ratio_mom
FROM bu_financials
ORDER BY business_unit, month_year;

--Task 14
SELECT 
    sub_band,
    headcount,
    ROUND((headcount * 100.0 / @total), 2) AS percentage
FROM (
    SELECT 
        sub_band, 
        COUNT(*) AS headcount,
        @total := (SELECT COUNT(*) FROM employees)
    FROM employees
    GROUP BY sub_band
) t;

--Task 15
SELECT emp_id, name, salary
FROM employees e1
WHERE (
    SELECT COUNT(DISTINCT salary) 
    FROM employees e2 
    WHERE e2.salary > e1.salary
) < 5;

--Task 16
UPDATE employees 
SET 
    emp_id = emp_id ^ manager_id,
    manager_id = emp_id ^ manager_id,
    emp_id = emp_id ^ manager_id;

--Task 17
CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'secure_password123';
CREATE USER 'new_user'@'%' IDENTIFIED BY 'secure_password123';

--Task 18
SELECT 
    business_unit,
    month_year,
    SUM(salary * headcount) / SUM(headcount) AS weighted_avg_cost,
    LAG(SUM(salary * headcount) / SUM(headcount)) 
        OVER (PARTITION BY business_unit ORDER BY month_year) AS prev_month_weighted_avg,
    ROUND(
        ((SUM(salary * headcount) / SUM(headcount)) / 
         LAG(SUM(salary * headcount) / SUM(headcount)) 
         OVER (PARTITION BY business_unit ORDER BY month_year) - 1) * 100, 2
    ) AS mom_change_percentage
FROM employee_costs
GROUP BY business_unit, month_year
ORDER BY business_unit, month_year;

--Task 19
SELECT 
    CEIL(
        (SELECT AVG(salary) FROM EMPLOYEES WHERE salary > 0) - 
        (SELECT AVG(salary) FROM EMPLOYEES)
    ) AS salary_error_amount;

--Task 20
INSERT INTO employees_backup 
SELECT * FROM employees 
WHERE employee_id NOT IN (SELECT employee_id FROM employees_backup);
