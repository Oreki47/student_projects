SELECT CONCAT(fname, ' ', lname) AS employee_name, train_time.name AS level
FROM employee AS e
INNER JOIN
(SELECT 'trainee' name, '2004-01-01' start_dt, '2005-12-31' end_dt
UNION ALL
SELECT 'worker' name, '2002-01-01' start_dt, '2003-12-31' end_dt
UNION ALL
SELECT 'mentor' name, '2000-01-01' start_dt, '2001-12-31' end_dt ) AS train_time
ON train_time.start_dt < e.start_date AND
e.start_date < train_time.end_dt