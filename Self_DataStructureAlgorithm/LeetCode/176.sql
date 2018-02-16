# Second Attempt Logic correct but still failed the return NULL as default
SELECT (SELECT DISTINCT e.Salary FROM Employee AS e ORDER BY e.Salary DESC LIMIT 1 OFFSET 1) as SecondHighestSalary

# Write your MySQL query statement below
SELECT (
    SELECT DISTINCT e.Salary 
    FROM Employee AS e
    ORDER BY e.Salary DESC LIMIT 1 OFFSET 1
)
AS SecondHighestSalary