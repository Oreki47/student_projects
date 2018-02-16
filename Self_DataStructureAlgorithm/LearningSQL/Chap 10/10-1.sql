SELECT p.name AS product_name, a.account_id AS account_name
FROM product AS P LEFT OUTER JOIN account AS a
ON p.product_cd = a.product_cd
ORDER BY product_name