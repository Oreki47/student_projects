SELECT DISTINCT p1.id, p1.date, p1.people
FROM stadium AS p1
LEFT JOIN stadium AS p2
ON p1.id = p2.id+1
LEFT JOIN stadium AS p3
ON p1.id = p3.id+2
LEFT JOIN stadium AS p4
ON p1.id = p4.id-1
LEFT JOIN stadium AS p5
ON p1.id = p5.id-2
WHERE (p1.people >= 100 
	AND (
		(p2.people >= 100 AND p3.people >= 100) OR 
		(p4.people >= 100 AND p5.people >= 100) OR 
		(p2.people >=100 AND p4.people >= 100))
	) 
ORDER BY p1.id