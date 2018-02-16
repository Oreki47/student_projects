SELECT CONCAT(e.fname, ' ', e.lname) AS name, p.name AS Product, b.name AS Branch, account_groups.tot AS Total
FROM
(SELECT product_cd, open_branch_id, open_emp_id, sum(avail_balance) AS tot
FROM account
GROUP BY product_cd, open_branch_id, open_emp_id) AS account_groups
INNER JOIN employee AS e ON e.emp_id = account_groups.open_emp_id
INNER JOIN product AS p ON p.product_cd = account_groups.product_cd
INNER JOIN branch b ON b.branch_id = account_groups.open_branch_id
ORDER BY 2, 3