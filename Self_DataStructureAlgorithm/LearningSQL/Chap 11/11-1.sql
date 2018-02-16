SELECT emp_id,
	CASE
		WHEN title LIKE '%President' OR title = 'Loan Manager'
			OR title = 'Treasurer'
			THEN 'Management'
		WHEN title LIKE '%Teller' OR title = 'Operations Manager'
			THEN 'Operations'
		ELSE 'Unknown'
	END
FROM employee;