SELECT a.account_id AS account_id, a.product_cd as product_cd,
CONCAT(i.fname, ' ', i.lname) AS individual_name, b.name AS business_name
FROM account AS a
LEFT OUTER JOIN individual AS i
ON a.cust_id = i.cust_id
LEFT OUTER JOIN business as b
ON a.cust_id = b.cust_id
ORDER BY a.account_id


SELECT a.account_id, a.product_cd, i.fname, i.lname, b.name
FROM account AS a
LEFT JOIN individual AS i
ON a.cust_id = i.cust_id
LEFT JOIN business AS b
ON a.cust_id = b.cust_id;