-- 1. Find the colors of boats reserved by Albert.
SELECT DISTINCT b.color
FROM sailors s
JOIN reserves r ON s.sid = r.sid
JOIN boat b ON r.bid = b.bid
WHERE s.sname = 'Albert';

-- 2. Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103:
SELECT DISTINCT s.sid
FROM sailors s
LEFT JOIN reserves r ON s.sid = r.sid
WHERE s.rating >= 8 OR r.bid = 103;
 
-- 3. Find the names of sailors who have not reserved a boat whose name contains the string “storm”. Order the names in ascending order:

SELECT s.sname
FROM sailors s
WHERE s.sid NOT IN (
    SELECT r.sid
    FROM reserves r
    JOIN boat b ON r.bid = b.bid
    WHERE b.bname LIKE '%storm%'
)
ORDER BY s.sname ASC;

-- 4. Find the names of sailors who have reserved all boats.

SELECT s.sname
FROM sailors s
WHERE NOT EXISTS (
    SELECT b.bid
    FROM boat b
    WHERE NOT EXISTS (
        SELECT r.sid
        FROM reserves r
        WHERE r.sid = s.sid AND r.bid = b.bid
    )
);

-- 5. Find the name and age of the oldest sailor:

SELECT s.sname, s.age
FROM sailors s
ORDER BY s.age DESC
LIMIT 1;

-- 6. For each boat which was reserved by at least 5/2 sailors with age >= 40, find the boat id and the average age of such sailors:

SELECT r.bid, AVG(s.age) AS avg_age
FROM reserves r
JOIN sailors s ON r.sid = s.sid
WHERE s.age >= 40
GROUP BY r.bid
HAVING COUNT(r.sid) >= 2;
