CREATE DATABASE order_processing;

USE order_processing;

CREATE TABLE customer(
    cust INTEGER PRIMARY KEY,
    cname VARCHAR(30),
    city VARCHAR(20)
);

CREATE TABLE order_(
    orderid INTEGER PRIMARY KEY,
    odate DATE,
    cust INTEGER ,
    order_amt INTEGER,
    FOREIGN KEY (cust) REFERENCES customer(cust) ON DELETE CASCADE
);

CREATE TABLE item(
    item INTEGER PRIMARY KEY,
    unitprice INTEGER
);

CREATE TABLE order_item(
    orderid INTEGER,
    item INTEGER,
    qty INTEGER,
    FOREIGN KEY (orderid) REFERENCES order_(orderid) ON DELETE CASCADE,
    FOREIGN KEY (item) REFERENCES item(item) ON DELETE CASCADE
);

CREATE TABLE warehouse(
    warehouse INTEGER PRIMARY KEY,
    city VARCHAR(20)
);

CREATE TABLE shipment(
    orderid INTEGER,
    warehouse INTEGER,
    ship_date DATE,
    FOREIGN KEY (orderid) REFERENCES order_(orderid) ON DELETE CASCADE,
    FOREIGN KEY (warehouse) REFERENCES warehouse(warehouse) ON DELETE CASCADE
);