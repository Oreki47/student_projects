SELECT SUM(a.avail_balance) AS tot
FROM account AS a
GROUP BY a.product_cd, a.open_branch_id
HAVING count(*) >1
ORDER BY tot DESC;