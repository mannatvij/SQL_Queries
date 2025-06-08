--Queries of The Week Three Assignment:
--Task1
WITH RankedTasks AS (
    SELECT *,
           ROW_NUMBER() OVER (ORDER BY Start_Date) AS rn
    FROM Projects
),
GroupedTasks AS (
    SELECT *,
           DATE_SUB(Start_Date, INTERVAL rn DAY) AS grp
    FROM RankedTasks
)
SELECT 
    MIN(Start_Date) AS Project_Start_Date,
    MAX(End_Date) AS Project_End_Date
FROM GroupedTasks
GROUP BY grp
ORDER BY DATEDIFF(MAX(End_Date), MIN(Start_Date)) ASC,
         MIN(Start_Date) ASC;

--task2
SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Packages p1 ON s.ID = p1.ID         
JOIN Packages p2 ON f.Friend_ID = p2.ID  
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary ASC;

--Task 3
SELECT DISTINCT 
    LEAST(f1.X, f1.Y) AS X,
    GREATEST(f1.X, f1.Y) AS Y
FROM Functions f1
JOIN Functions f2
    ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <= f1.Y
ORDER BY X;

--Task 4
SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    SUM(IFNULL(ss.total_submissions, 0)) AS total_submissions,
    SUM(IFNULL(ss.total_accepted_submissions, 0)) AS total_accepted_submissions,
    SUM(IFNULL(vs.total_views, 0)) AS total_views,
    SUM(IFNULL(vs.total_unique_views, 0)) AS total_unique_views
FROM Contests c
JOIN Colleges co ON c.contest_id = co.contest_id
JOIN Challenges ch ON co.college_id = ch.college_id
LEFT JOIN View_Stats vs ON ch.challenge_id = vs.challenge_id
LEFT JOIN Submission_Stats ss ON ch.challenge_id = ss.challenge_id
GROUP BY c.contest_id, c.hacker_id, c.name
HAVING 
    total_submissions > 0 OR 
    total_accepted_submissions > 0 OR 
    total_views > 0 OR 
    total_unique_views > 0
ORDER BY c.contest_id;

--Task 5
SELECT 
    s.submission_date,
    COUNT(DISTINCT s.hacker_id) AS unique_hackers,
    h.hacker_id,
    h.name
FROM Submissions s
JOIN Hackers h ON s.hacker_id = h.hacker_id
WHERE s.submission_date BETWEEN '2016-03-01' AND '2016-03-15'
GROUP BY s.submission_date, s.hacker_id
-- Rank hackers per day by number of submissions
WITH daily_ranks AS (
    SELECT 
        s.submission_date,
        s.hacker_id,
        h.name,
        COUNT(*) AS submission_count,
        RANK() OVER (PARTITION BY s.submission_date ORDER BY COUNT(*) DESC, s.hacker_id ASC) AS rank
    FROM Submissions s
    JOIN Hackers h ON s.hacker_id = h.hacker_id
    WHERE s.submission_date BETWEEN '2016-03-01' AND '2016-03-15'
    GROUP BY s.submission_date, s.hacker_id
)
SELECT 
    dr.submission_date,
    (SELECT COUNT(DISTINCT hacker_id) 
     FROM Submissions 
     WHERE submission_date = dr.submission_date) AS unique_hackers,
    dr.hacker_id,
    dr.name
FROM daily_ranks dr
WHERE dr.rank = 1
ORDER BY dr.submission_date;

--Task 6
SELECT 
    ROUND(ABS(MAX(LAT_N) - MIN(LAT_N)) + ABS(MAX(LONG_W) - MIN(LONG_W)), 4) AS ManhattanDistance
FROM STATION;

--Task 7
WITH RECURSIVE numbers(n) AS (
    SELECT 2
    UNION ALL
    SELECT n + 1 FROM numbers WHERE n < 1000
),
primes AS (
    SELECT n FROM numbers n1
    WHERE NOT EXISTS (
        SELECT 1 FROM numbers n2
        WHERE n2.n < n1.n AND n1.n % n2.n = 0 AND n2.n > 1
    )
)
SELECT GROUP_CONCAT(n SEPARATOR '&') AS primes_up_to_1000
FROM primes;

--Task 8
SELECT
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM (
    SELECT Name, Occupation,
           ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM OCCUPATIONS
) AS sorted_names
GROUP BY rn
ORDER BY rn;

--Task 9
SELECT 
    N,
    CASE 
        WHEN P IS NULL THEN 'Root'
        WHEN N NOT IN (SELECT DISTINCT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
        ELSE 'Inner'
    END AS NodeType
FROM BST
ORDER BY N;


--Task 10
SELECT 
    c.company_code,
    c.founder,
    COUNT(DISTINCT lm.lead_manager_code) AS lead_manager_count,
    COUNT(DISTINCT sm.senior_manager_code) AS senior_manager_count,
    COUNT(DISTINCT m.manager_code) AS manager_count,
    COUNT(DISTINCT e.employee_code) AS employee_count
FROM Company c
LEFT JOIN Lead_Manager lm ON c.company_code = lm.company_code
LEFT JOIN Senior_Manager sm ON c.company_code = sm.company_code
LEFT JOIN Manager m ON c.company_code = m.company_code
LEFT JOIN Employee e ON c.company_code = e.company_code
GROUP BY c.company_code, c.founder
ORDER BY c.company_code;
