-- List the Order# and Ship Date for all orders shipped from Warehouse 0002.

SELECT orderid,ship_date
FROM shipment
WHERE warehouse = 0002;

-- List the warehouse information from which the customer named "Kumar" was supplied with his orders.Produce a listing of order#,warehouse#

SELECT orderid,warehouse
FROM shipment
WHERE orderid in (
    SELECT orderid
    FROM order_
    WHERE cust in (
        SELECT cust
        FROM customer
        WHERE cname = "Kumar"
    )
)

-- Produce a listing : Cnamee ,#ofOrders,AvG_oRDER_aMT  where middle COLUMN is the total number of orders by the customer andf the last is the average  order amount for that customer

SELECT cname,COUNT(orderid) as NPoofOrder, AVG(order_amt) as Avg_Order_Amt 
FROM customer 
NATURAL JOIN order_
group by cname;


-- DELETE ALL ORDERS FROM CUSTOMER named kumar

DELETE FROM order_
WHERE cust in (
    SELECT cust
    FROM customer
    WHERE cname = "Kumar"
)

-- FIND the item with the maximum unit price

SELECT *
FROM item
WHERE unitprice = (
    SELECT MAX(unitprice)
    FROM item
) 

-- A trigger that updates order_amount based on quantity and unit price of order-item
DELIMITER //
CREATE TRIGGER update_order_amount_up
AFTER UPDATE on order_item
FOR EACH ROW
BEGIN
    DECLARE uamt INT;
    SELECT unitprice INTO uamt FROM item  WHERE item.item = NEW.item LIMIT 1;
    UPDATE order_ SET order_amt = uamt * NEW.qty WHERE order_.orderid = NEW.orderid ;
END;
//
DELIMITER ;



SELECT * FROM order_;

UPDATE order_item SET qty = 2 WHERE orderid = 1;

Select * from order_;

-- View to display the orderid and ship_date for all orders shipped from warehouse 0002
CREATE View order_shipment AS
SELECT orderid,ship_date
FROM shipment
WHERE warehouse = 0002;

SELECT * FROM order_shipment;