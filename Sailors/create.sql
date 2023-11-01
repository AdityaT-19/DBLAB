-- Active: 1698830877738@@127.0.0.1@3306@sailors
CREATE DATABASE sailors;

USE sailors;

CREATE TABLE sailors (
    sid     INTEGER PRIMARY KEY,
    sname   VARCHAR(40),
    rating  FLOAT,
    age     INTEGER
);

CREATE TABLE boat (
    bid     INTEGER PRIMARY KEY,
    bname   VARCHAR(40),
    color   VARCHAR(10)
);

CREATE TABLE reserves (
    sid     INTEGER,
    bid     INTEGER,
    day     DATE,
    FOREIGN KEY (sid) REFERENCES sailors(sid) ON DELETE CASCADE,
    FOREIGN KEY (bid) REFERENCES boat(bid) ON DELETE CASCADE
);