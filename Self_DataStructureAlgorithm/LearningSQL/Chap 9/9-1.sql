SELECT a.account_id, a.cust_id, p.product_cd, a.avail_balance
FROM account AS a
INNER JOIN product AS p
ON a.product_cd = p.product_cd
WHERE p.product_type_cd = 'LOAN'


SELECT a.account_id, a.product_cd, a.cust_id, a.avail_balance
FROM account AS a
INNER JOIN 
(SELECT p.product_cd
FROM product AS p
WHERE p.product_type_cd = 'LOAN') AS p2
ON a.product_cd = p2.product_cd;

/* SELECT account_id, product_cd, cust_id, avail_balance
FROM account
WHERE product_cd IN (SELECT product_cd
FROM product
WHERE product_type_cd = 'LOAN'); */