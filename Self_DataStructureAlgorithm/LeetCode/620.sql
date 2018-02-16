# second attempt without any hint
SELECT *
FROM cinema
WHERE id % 2 != 0
AND description NOT LIKE "boring"
ORDER BY rating DESC

# first attempt with hints from others
SELECT * FROM cinema AS c
WHERE (
    (c.id % 2) <> 0 
    AND
    c.description != 'boring'
)
ORDER BY c.rating DESC;