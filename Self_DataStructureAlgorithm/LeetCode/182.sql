# second attmpt failed, forget the use of having
SELECT t.Email
FROM (SELECT p.email, COUNT(*) FROM Person as p GROUP BY p.Email HAVING COUNT(*) > 1) as t

# First attmpt, 
SELECT p.Email 
FROM Person AS p
GROUP BY p.Email
HAVING COUNT(*) > 1;