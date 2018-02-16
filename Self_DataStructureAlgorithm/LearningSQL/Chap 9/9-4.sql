SELECT e.emp_id, e.fname, e.lname,
(SELECT d.name FROM department d WHERE d.dept_id = e.dept_id) dept_name,
(SELECT b.name FROM branch b WHERE b.branch_id = e.assigned_branch_id) branch_name
FROM employee e