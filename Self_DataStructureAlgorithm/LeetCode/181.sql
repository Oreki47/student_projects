# Second time easy pass
SELECT e1.Name as Employee
FROM Employee as e1 
LEFT OUTER JOIN Employee as e2
ON e1.ManagerId = e2.Id
WHERE e1.Salary > e2.Salary

# First attempt asked for help
SELECT e.Name AS Employee
FROM Employee AS e
LEFT JOIN Employee AS e2
ON e.ManagerId = e2.Id
WHERE e.Salary > e2.Salary;