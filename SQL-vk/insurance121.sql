create database insurance121;
use insurance121;
create table person (
    did VARCHAR(5),
    dname varchar(10),
    address varchar(10),
    PRIMARY KEY ( did )
);

create table car(
    regno varchar(10),
    model varchar(10),
    year integer,
    PRIMARY KEY (regno)
);

create table owns(
    did varchar(5),
    regno varchar(10),
    foreign key ( did ) references person(did) on delete cascade,
    foreign key ( regno ) references car(regno) on delete cascade
);

create table accident(
    repnum integer,
    accdate date,
    location varchar(10),
    primary key ( repnum )
);

create table participated(
    did varchar(5),
    regno varchar(10),
    repnum integer,
    damageamt integer,
    foreign key ( did ) references person(did) on delete cascade,
    foreign key ( regno ) references car(regno) on delete cascade,
    foreign key ( repnum ) references accident(repnum ) on delete cascade
);

insert into person values 
("d001", "Dom", "Mysuru"),
("d002", "Roman", "Delhi"),
("d003", "Brain", "Mumbai"),
("d004", "Shaw", "Chennai"),
("d005", "Hobbs", "Ranchi"),
("d006", "Letty", "Bangalore");

insert into car values 
("ka-1969", "Maruti", "2020"),
("ka-1961", "Tata", "2020"),
("ka-1998", "Ford", "2023"),
("ka-2023", "Ferrai", "2017"),
("ka-1947", "Suzuti", "2010"),
("ka-2004", "Renault", "2000");

insert into owns VALUES
("d001", "ka-1969"),
("d001", "ka-2004"),
("d002", "ka-1961"),
("d003", "ka-1998"),
("d004", "ka-2023");

insert into accident VALUES
(123, "2020-09-29", "Mysuru"),
(124, "2021-09-29", "Ranchi"),
(125, "2022-09-29", "Mumbai"),
(126, "2023-08-29", "Chennai"),
(127, "2020-09-23", "Banglore"),
(128, "2020-04-29", "Delhi");

insert into participated VALUES
("d001", "ka-1969", 123, 5600),
("d002", "ka-1961", 124, 54600),
("d003", "ka-1998", 125, 4600),
("d001", "ka-2004", 126, 5659),
("d004", "ka-2023", 127, 5609);

SELECT * FROM person;
SELECT * FROM owns;
SELECT * FROM car;
SELECT * FROM accident;
SELECT * FROM participated;

-- 1. Find the total number of people who owned cars that were involved in accidents in 2021.
-- 2. Find the number of accidents in which the cars belonging to "Dom" were involved.
-- 3. Add a new accident to the database; assume any values for required attributes.
-- 4. Delete the Maruti belonging to "Dom".
-- 5. Update the damage amount for the car with license number "ka-1961" in the accident
-- with report.
-- 6. A view that shows models and year of cars that are involved in accident.
-- 7. A trigger that prevents driver with total damage amount >rs.50,000 from owning a car.

-- 1
SELECT COUNT(DISTINCT p.did) AS total_people
FROM person p
JOIN owns o ON p.did = o.did
JOIN participated pa ON o.regno = pa.regno
JOIN accident a ON pa.repnum = a.repnum
WHERE EXTRACT(YEAR FROM a.accdate) = 2021;

-- 2
SELECT COUNT(DISTINCT pa.repnum) AS accidents_involving_Dom
FROM person p
JOIN owns o ON p.did = o.did
JOIN participated pa ON o.regno = pa.regno
WHERE p.dname = 'Dom';

-- 3
INSERT INTO accident (accdate, location)
VALUES ('2023-11-18', 'Mysuru');

-- 4
DELETE FROM car
WHERE regno IN (
    SELECT o.regno
    FROM owns o
    JOIN person p ON o.did = p.did
    WHERE p.dname = 'Dom'
    AND car.model = 'Maruti'
);

-- 5
UPDATE participated
SET damageamt = 5000
WHERE regno = 'ka-1961'
AND repnum = 123;

-- 6
CREATE VIEW accident_cars_view AS
SELECT DISTINCT c.model, c.year
FROM car c
JOIN participated pa ON c.regno = pa.regno;

SELECT * FROM accident_cars_view;

-- 7
DELIMITER //
CREATE TRIGGER ARB BEFORE INSERT ON owns FOR EACH ROW
BEGIN
    DECLARE total_damage INTEGER;

    -- Calculate the total damage amount for the driver
    SELECT SUM(damageamt)
    INTO total_damage
    FROM participated
    WHERE did = NEW.did;

    -- Check if the total damage amount is NULL and replace with 0
    IF total_damage IS NULL THEN
        SET total_damage = 0;
    END IF;

    -- Check if the total damage amount exceeds 50000
    IF total_damage >= 50000 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Driver has total damage amount greater than or equal to 50000';
    END IF;
END;
//
DELIMITER ;

INSERT INTO owns VALUES
("d002", "ka-1969");