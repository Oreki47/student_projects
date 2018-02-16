# First/Second attempts add passed
SELECT FirstName, LastName, City, State
FROM Person AS p
LEFT JOIN Address AS a
ON p.PersonId = a.PersonId