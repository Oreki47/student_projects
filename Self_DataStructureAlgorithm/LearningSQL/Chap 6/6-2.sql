SELECT e.fname, e.lname
FROM employee AS e
UNION
(SELECT i.fname, i.lname
 FROM individual AS i
 INNER JOIN customer AS c
 WHERE i.cust_id = c.cust_id)
ORDER BY lname;