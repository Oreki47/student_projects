# Did not know about the round and COUNT(SELECTION)

SELECT Request_at AS Day
    , ROUND(COUNT(Status <> 'completed' OR NULL) / COUNT(*), 2) AS `Cancellation Rate`
FROM Users AS u1
RIGHT JOIN Trips AS t1
ON t1.Client_Id = u1.Users_Id
WHERE (
    (u1.Banned = "NO" AND u1.Role = "Client") AND
    (t1.Request_at BETWEEN "2013-10-01" AND "2013-10-03")
)
GROUP BY t1.Request_at
