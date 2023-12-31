-- Active: 1700499878468@@127.0.0.1@3306@company
CREATE DATABASE company;

USE company;

CREATE TABLE employee(
    SSN VARCHAR(15) PRIMARY KEY,
    Name VARCHAR(40),
    Address VARCHAR(55),
    Sex VARCHAR(1),
    Salary INTEGER,
    SuperSSN VARCHAR(15),
    DNo INTEGER,
    FOREIGN KEY (SuperSSN) REFERENCES employee(SSN) ON DELETE SET NULL,
    FOREIGN KEY (DNo) REFERENCES department(DNo) ON DELETE SET NULL
);

CREATE TABLE department(
    DName VARCHAR(30),
    DNo INTEGER PRIMARY KEY,
    MgrSSN VARCHAR(15),
    MgrStartDate DATE,
    FOREIGN KEY (MgrSSN) REFERENCES employee(SSN) ON DELETE SET NULL
);

CREATE TABLE Dlocation(
    DNo INTEGER,
    Dloc VARCHAR(30),
    PRIMARY KEY (DNo, Dloc),
    FOREIGN KEY (DNo) REFERENCES department(DNo) ON DELETE CASCADE
);

CREATE TABLE project(
    PName VARCHAR(30),
    PNo INTEGER PRIMARY KEY,
    Plocation VARCHAR(30),
    DNo INTEGER,
    FOREIGN KEY (DNo) REFERENCES department(DNo) ON DELETE SET NULL
);

CREATE TABLE works_on(
    SSN VARCHAR(15),
    PNo INTEGER,
    Hours INTEGER,
    FOREIGN KEY (SSN) REFERENCES employee(SSN) ON DELETE SET NULL,
    FOREIGN KEY (PNo) REFERENCES project(PNo) ON DELETE CASCADE
);