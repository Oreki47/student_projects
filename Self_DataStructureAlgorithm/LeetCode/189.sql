# First Attempt NO HELP MEDIUM QUESTION YEE!
SELECT DISTINCT l1.Num AS ConsecutiveNums
FROM Logs AS l1 
LEFT JOIN Logs AS l2
ON l1.ID = l2.ID-1
LEFT JOIN Logs AS l3
ON l1.ID = l3.ID-2
WHERE l1.Num = l2.Num
AND l1.Num = l3.Num