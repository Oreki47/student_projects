# Second without but some typos
SELECT c.Name as Customers
FROM Customers as c
LEFT OUTER JOIN (SELECT o.CustomerId as Id, COUNT(*) as history FROM Orders as o GROUP BY o.CustomerId) as y
ON c.Id = y.Id
WHERE y.history IS NULL

# First Attempt with hint
SELECT c.Name AS Customers
FROM Customers AS c
WHERE c.Id NOT IN (
    SELECT DISTINCT o.CustomerId
    FROM Orders AS o
)