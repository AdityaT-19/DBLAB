CREATE DATABASE insurance;

USE insurance;

CREATE TABLE person (
    driver_id VARCHAR(10) PRIMARY KEY,
    name VARCHAR(40) ,
    address VARCHAR(50)
);

CREATE TABLE car (
    regno VARCHAR(10) PRIMARY KEY,
    model VARCHAR(40) ,
    year INTEGER
);

CREATE TABLE accident(
    report_number INTEGER PRIMARY KEY,
    acc_date DATE,
    location VARCHAR(50)
);

CREATE TABLE owns(
    driver_id VARCHAR(10),
    regno VARCHAR(10),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)  ON DELETE CASCADE,
    FOREIGN KEY (regno) REFERENCES car(regno) ON DELETE CASCADE
);

CREATE TABLE participated(
    driver_id VARCHAR(10),
    regno VARCHAR(10),
    report_number INTEGER,
    damage_amount INTEGER,
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)  ON DELETE SET NULL,
    FOREIGN KEY (regno) REFERENCES car(regno) ON DELETE SET NULL,
    FOREIGN KEY (report_number) REFERENCES accident(report_number) ON DELETE SET NULL
);
