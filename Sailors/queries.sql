-- Active: 1700499878468@@127.0.0.1@3306@sailors
-- 1. Find the colors of boats reserved by Albert.
SELECT DISTINCT b.color
FROM sailors s
NATURAL JOIN reserves r NATURAL JOIN boat b
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

SELECT S.sname
FROM SAILORS S
WHERE (
    SELECT COUNT(DISTINCT B.bid)
    FROM BOAT B
) = (
    SELECT COUNT(DISTINCT R.bid)
    FROM RESERVES R
    WHERE R.sid = S.sid
);

-- 5. Find the name and age of the oldest sailor:

SELECT s.sname, s.age
FROM sailors s
ORDER BY s.age DESC
LIMIT 1;

SELECT s.sname, s.age
FROM sailors s
WHERE s.age = (
    SELECT MAX(s.age)
    FROM sailors s
);
-- 6. For each boat which was reserved by at least 5/2 sailors with age >= 40, find the boat id and the average age of such sailors:

SELECT r.bid, AVG(s.age) AS avg_age
FROM reserves r
JOIN sailors s ON r.sid = s.sid
WHERE s.age >= 40
GROUP BY r.bid
HAVING COUNT(r.sid) >= 2;

-- View that shows the names and colors of all the boats reserved by a sailor with a specific rating
CREATE VIEW boats_reserved_by_rating AS
SELECT DISTINCT b.bname, b.color
FROM sailors s
NATURAL JOIN reserves r NATURAL JOIN boat b
WHERE s.rating = 5;

SELECT * FROM boats_reserved_by_rating;

-- Trigger that prevents boat from being deleted if the boat has reservations

CREATE TRIGGER boat_delete_trigger
BEFORE DELETE ON boat
FOR EACH ROW
BEGIN
    IF EXISTS(
        Select bid from reserves
        WHERE bid = OLD.bid
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete boat with reservations';
    END IF;
END;


DELETE FROM boat WHERE bid = 101;