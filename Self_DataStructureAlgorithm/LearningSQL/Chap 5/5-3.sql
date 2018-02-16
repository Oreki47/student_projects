SELECT e.emp_id, e.fname, e.lname
FROM employee AS e
LEFT JOIN
employee AS e2
ON e.superior_emp_id = e2.emp_id
WHERE e.dept_id != e2.dept_id;