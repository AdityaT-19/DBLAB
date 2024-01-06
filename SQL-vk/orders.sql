create database ordersprocess121;
use ordersprocess121;

CREATE TABLE customers (
  cust_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  cname VARCHAR(255) NOT NULL,
  city VARCHAR(255) NOT NULL
);

CREATE TABLE item (
    item_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    unitprice INT NOT NULL
);

CREATE TABLE warehouse (
    warehouse_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    city VARCHAR(255) NOT NULL
);

CREATE TABLE orders (
    order_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    odate DATE NOT NULL,
    cust_id INT NOT NULL,
    order_amt INT NOT NULL,
    FOREIGN KEY (cust_id) REFERENCES customers(cust_id) ON DELETE CASCADE
);

CREATE TABLE order_item (
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES item(item_id) ON DELETE CASCADE
);

CREATE TABLE shipment (
    order_id INT NOT NULL,
    warehouse_id INT NOT NULL,
    ship_date DATE NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (warehouse_id) REFERENCES warehouse(warehouse_id) ON DELETE CASCADE
);

INSERT INTO customers (cname,city) VALUES ('Rohith', 'Mumbai');
INSERT INTO customers (cname,city) VALUES ('Kohli', 'Delhi');
INSERT INTO customers (cname,city) VALUES ('Dhoni', 'Ranchi');
INSERT INTO customers (cname,city) VALUES ('Rahul', 'Bangalore');
INSERT INTO customers (cname,city) VALUES ('Ashwin', 'Chennai');

INSERT INTO item (unitprice) VALUES (100);
INSERT INTO item (unitprice) VALUES (200);
INSERT INTO item (unitprice) VALUES (300);
INSERT INTO item (unitprice) VALUES (400);
INSERT INTO item (unitprice) VALUES (500);

INSERT INTO warehouse (city) VALUES ('Mumbai');
INSERT INTO warehouse (city) VALUES ('Delhi');
INSERT INTO warehouse (city) VALUES ('Bangalore');
INSERT INTO warehouse (city) VALUES ('Ranchi');
INSERT INTO warehouse (city) VALUES ('Chennai');

INSERT INTO orders (odate, cust_id, order_amt) VALUES ('2023-12-01', 1, 1000);
INSERT INTO orders (odate, cust_id, order_amt) VALUES ('2023-12-02', 2, 2000);
INSERT INTO orders (odate, cust_id, order_amt) VALUES ('2023-11-29', 3, 3000);
INSERT INTO orders (odate, cust_id, order_amt) VALUES ('2023-11-30', 4, 4000);
INSERT INTO orders (odate, cust_id, order_amt) VALUES ('2023-11-28', 1, 5000);
INSERT INTO orders (odate, cust_id, order_amt) VALUES ('2023-11-27', 5, 6000);
INSERT INTO orders (odate, cust_id, order_amt) VALUES ('2023-11-26', 3, 7000);

INSERT INTO order_item (order_id, item_id, quantity) VALUES (1, 1, 1);
INSERT INTO order_item (order_id, item_id, quantity) VALUES (2, 2, 2);
INSERT INTO order_item (order_id, item_id, quantity) VALUES (3, 3, 3);
INSERT INTO order_item (order_id, item_id, quantity) VALUES (4, 4, 4);
INSERT INTO order_item (order_id, item_id, quantity) VALUES (5, 5, 5);

INSERT INTO shipment (order_id, warehouse_id, ship_date) VALUES (1, 1, '2023-12-01');
INSERT INTO shipment (order_id, warehouse_id, ship_date) VALUES (2, 2, '2023-12-02');
INSERT INTO shipment (order_id, warehouse_id, ship_date) VALUES (3, 3, '2023-11-29');
INSERT INTO shipment (order_id, warehouse_id, ship_date) VALUES (4, 4, '2023-11-30');
INSERT INTO shipment (order_id, warehouse_id, ship_date) VALUES (5, 5, '2023-11-28');

SELECT * FROM customers;
SELECT * FROM item;
SELECT * FROM warehouse;
SELECT * FROM orders;
SELECT * FROM order_item;
SELECT * FROM shipment;

-- Query-1
SELECT S.order_id, S.ship_date
FROM Shipment S
WHERE S.warehouse_id = 2;

-- Query-2
SELECT o.order_id AS OrderNumber, s.warehouse_id AS WarehouseNumber
FROM customers c
JOIN orders o ON c.cust_id = o.cust_id
JOIN shipment s ON o.order_id = s.order_id
WHERE c.cname = 'Rohith';

-- Query-3
SELECT c.cname AS Cname, COUNT(o.order_id) AS NumberOfOrders, AVG(o.order_amt) AS Avg_Order_Amt
FROM customers c
LEFT JOIN orders o ON c.cust_id = o.cust_id
GROUP BY c.cust_id, c.cname;

-- Query-4
DELETE FROM orders
WHERE cust_id = (SELECT cust_id FROM customers WHERE cname = 'Rohith');

SELECT * FROM orders;

-- Query-5
SELECT *
FROM item
WHERE unitprice = (SELECT MAX(unitprice) FROM item);


-- Trigger
DELIMITER //

CREATE TRIGGER update_order_amount
AFTER INSERT ON order_item
FOR EACH ROW
BEGIN
    DECLARE total_amount INT;
    
    SET total_amount = NEW.quantity * (SELECT unitprice FROM item WHERE item_id = NEW.item_id);
    
    UPDATE orders
    SET order_amt = total_amount
    WHERE order_id = NEW.order_id;
END //

DELIMITER ;

INSERT INTO order_item (order_id, item_id, quantity) VALUES (6, 1, 1);
INSERT INTO order_item (order_id, item_id, quantity) VALUES (7, 2, 2);


-- View
SELECT * FROM orders;

CREATE VIEW OrdersFromWarehouse2 AS
SELECT s.order_id AS orderID, s.ship_date AS shipment_date
FROM shipment s
WHERE s.warehouse_id = 2;

SELECT * FROM OrdersFromWarehouse2;