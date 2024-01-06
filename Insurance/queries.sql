-- Active: 1700499878468@@127.0.0.1@3306@insurance
USE insurance;

-- 1.	Find the total number of people who owned cars that were involved in accidents in 2021.



Select COUNT(*) as total_accidents
FROM participated NATURAL JOIN accident
NATURAL JOIN owns 
WHERE accident.acc_date like "2021%"; 

--2. Find the number of accidents in which the cars belonging to "Smith"  were involved

Select COUNT(*) as total_accidents
FROm participated p 
JOIN owns o ON p.regno = o.regno 
JOIN person pp ON pp.driver_id = o.driver_id
WHERE pp.name like "%Smith%";

--3. Add a new accident to the database; assume any values for required attributes.

INSERT INTO accident VALUES ( 62541,"2023-12-29","Mysore" );

--4. Delete the MAZDA belonging to "Smith".

DELETE FROM car c WHERE regno IN (SELECT regno FROM owns o JOIN person p ON p.driver_id = o.driver_id WHERE p.name like "%Smith%" AND c.model = "MAZDA");

--5. Update the damage amount for the car with license number "KA09MA1234" in the accident with report

UPDATE participated SET damage_amount = 10000 WHERE regno = "KA-09-MA-1234" ;

-- View that shows models and year of cars that are involved in accident

CREATE VIEW accident_cars AS
SELECT DISTINCT model, year
FROM car 
WHERE car.regno IN (SELECT regno FROM participated);

SELECT * FROM accident_cars;

-- A trigger that prevents a driver from participating in more that 3 accidents a year

CREATE TRIGGER accident_limit
BEFORE INSERT on participated
FOR EACH ROW
BEGIN 
    IF ( SELECT COUNT(*) from participated Natural join accident WHERE driver_id = NEW.driver_id AND acc_date like "2021%") >= 2
    THEN
        SIGNAL SQLSTATE '42000' SET MESSAGE_TEXT = 'Driver has exceeded accident limit';
    END IF;END;

DROP TRIGGER accident_limit;
INSERT INTO participated VALUES
("D222", "KA-20-AB-4223", 66666, 20000);