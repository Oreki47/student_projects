# First Attempt Passed
SELECT c.class 
FROM (SELECT DISTINCT * FROM courses) AS c
GROUP BY c.class 
HAVING COUNT(*) >=5