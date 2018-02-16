# Almost got it, with no knowledge on DATEDIFF
SELECT w1.Id
FROM Weather AS w1
LEFT OUTER JOIN Weather AS w2
ON DATEDIFF(w1.date, w2.date) = 1
WHERE w1.Temperature > w2.Temperature