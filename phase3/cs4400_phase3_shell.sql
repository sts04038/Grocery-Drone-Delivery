/*
CS4400: Introduction to Database Systems
Spring 2021
Phase III Template
Team 62
Team Member Aidan Anderson (aanderson306)
Team Member Andreea Juravschi (ajuravschi3)
Team Member Dowon Kim (dkim694)
Team Member Dong Hyuk Park (dpark346)


Directions:
Please follow all instructions from the Phase III assignment PDF.
This file must run without error for credit.
*/

-- ID: 2a
-- Author: asmith457
-- Name: register_customer
DROP PROCEDURE IF EXISTS register_customer;
DELIMITER //
CREATE PROCEDURE register_customer(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
	   IN i_zipcode CHAR(5),
       IN i_ccnumber VARCHAR(40),
	   IN i_cvv CHAR(3),
       IN i_exp_date DATE
)
BEGIN
-- Type solution below
    IF
		length(i_zipcode)=5
	THEN
    INSERT INTO users (Username, Pass, FirstName, LastName, Street, City, State, Zipcode) 
		VALUES (i_username, md5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);
        
	INSERT INTO customer (Username, CcNumber, CVV, EXP_DATE) 
		VALUES (i_username, i_ccnumber, i_cvv, i_exp_date);
	END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 2b
-- Author: asmith457
-- Name: register_employee
DROP PROCEDURE IF EXISTS register_employee;
DELIMITER //
CREATE PROCEDURE register_employee(
	   IN i_username VARCHAR(40),
       IN i_password VARCHAR(40),
	   IN i_fname VARCHAR(40),
       IN i_lname VARCHAR(40),
       IN i_street VARCHAR(40),
       IN i_city VARCHAR(40),
       IN i_state VARCHAR(2),
       IN i_zipcode CHAR(5)
)
BEGIN

-- Type solution below
    IF
		length(i_zipcode) = 5
	Then
	INSERT INTO users (Username, Pass, FirstName, LastName, Street, City, State, Zipcode) 
		VALUES (i_username, md5(i_password), i_fname, i_lname, i_street, i_city, i_state, i_zipcode);

	INSERT INTO employee (Username) 
		VALUES (i_username);
    END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 4a
-- Author: asmith457
-- Name: admin_create_grocery_chain
DROP PROCEDURE IF EXISTS admin_create_grocery_chain;
DELIMITER //
CREATE PROCEDURE admin_create_grocery_chain(
        IN i_grocery_chain_name VARCHAR(40)
)
BEGIN

-- Type solution below
	INSERT INTO chain (ChainName) 
		VALUES (i_grocery_chain_name);
-- End of solution
END //
DELIMITER ;

-- ID: 5a
-- Author: ahatcher8
-- Name: admin_create_new_store
DROP PROCEDURE IF EXISTS admin_create_new_store;
DELIMITER //
CREATE PROCEDURE admin_create_new_store(
    	IN i_store_name VARCHAR(40),
        IN i_chain_name VARCHAR(40),
    	IN i_street VARCHAR(40),
    	IN i_city VARCHAR(40),
    	IN i_state VARCHAR(2),
    	IN i_zipcode CHAR(5)
)
BEGIN
-- Type solution below
	INSERT INTO store (StoreName, ChainName, Street, City, State, Zipcode)
		VALUES (i_store_name, i_chain_name, i_street, i_city, i_state, i_zipcode);
-- End of solution
END //
DELIMITER ;


-- ID: 6a
-- Author: ahatcher8
-- Name: admin_create_drone
DROP PROCEDURE IF EXISTS admin_create_drone;
DELIMITER //
CREATE PROCEDURE admin_create_drone(
	   IN i_drone_id INT,
       IN i_zip CHAR(5),
       IN i_radius INT,
       IN i_drone_tech VARCHAR(40)
)
BEGIN
-- Type solution below
	IF
		(i_zip = (select Zipcode from STORE where StoreName = (select StoreName from DRONE_TECH where username = i_drone_tech)))
    THEN
		INSERT INTO drone (ID, DroneStatus, Zip, Radius, DroneTech) VALUES (i_drone_id, 'Available', i_zip, i_radius, i_drone_tech); 
	END IF;
    
-- End of solution
END //
DELIMITER ;


-- ID: 7a
-- Author: ahatcher8
-- Name: admin_create_item
DROP PROCEDURE IF EXISTS admin_create_item;
DELIMITER //
CREATE PROCEDURE admin_create_item(
        IN i_item_name VARCHAR(40),
        IN i_item_type VARCHAR(40),
        IN i_organic VARCHAR(3),
        IN i_origin VARCHAR(40)
)
BEGIN
-- Type solution below
	IF 
		NOT EXISTS (SELECT 1 FROM ITEM WHERE BINARY ITEM.ItemName = BINARY i_item_name) AND
        i_organic IN ('Yes', 'No') AND 
        i_item_type IN ('Dairy', 'Bakery', 'Meat', 'Produce', 'Personal Care', 'Paper Goods', 'Beverages', 'Other')
    THEN
		INSERT INTO item (ItemName, ItemType, Organic, Origin) VALUES (i_item_name, i_item_type, i_organic, i_origin);
	END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 8a
-- Author: dvaidyanathan6
-- Name: admin_view_customers
DROP PROCEDURE IF EXISTS admin_view_customers;
DELIMITER //
CREATE PROCEDURE admin_view_customers(
	   IN i_first_name VARCHAR(40),
       IN i_last_name VARCHAR(40)
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS admin_view_customers_result;
CREATE TABLE admin_view_customers_result
	SELECT Username AS "Username", concat(FirstName," ", LastName) AS "Name", concat(Street,", ",City,", ", State," ",Zipcode) AS "Address" 
    FROM CUSTOMER NATURAL JOIN USERS 
    WHERE 
    (i_first_name IS NOT NULL AND i_last_name IS NOT NULL AND FirstName = i_first_name AND LastName = i_last_name) OR 
    (i_first_name IS NOT NULL AND (i_last_name IS NULL OR i_last_name = '') AND FirstName = i_first_name) OR 
    ((i_first_name IS NULL OR i_first_name = '') AND i_last_name IS NOT NULL AND LastName = i_last_name) OR 
    ((i_first_name IS NULL OR i_first_name = '') AND (i_last_name IS NULL OR i_last_name = ''));
    
-- End of solution
END //
DELIMITER ;

-- ID: 9a
-- Author: dvaidyanathan6
-- Name: manager_create_chain_item
DROP PROCEDURE IF EXISTS manager_create_chain_item;
DELIMITER //
CREATE PROCEDURE manager_create_chain_item(
        IN i_chain_name VARCHAR(40),
    	IN i_item_name VARCHAR(40),
    	IN i_quantity INT, 
    	IN i_order_limit INT,
    	IN i_PLU_number INT,
    	IN i_price DECIMAL(4, 2)
)
BEGIN
-- Type solution below
	IF
		(9999 < i_PLU_number AND i_PLU_number < 100000) AND
		EXISTS (SELECT ItemName from ITEM WHERE ItemName = i_item_name) AND
        EXISTS (SELECT ChainName from CHAIN WHERE ChainName = i_chain_name) AND
		NOT EXISTS (SELECT PLUNumber, ChainName FROM CHAIN_ITEM WHERE (ChainName = i_chain_name AND PLUNumber = i_PLU_number))

    THEN
		INSERT INTO CHAIN_ITEM(ChainItemName, ChainName, PLUNumber, Orderlimit, Quantity, Price)
			VALUES (i_item_name, i_chain_name, i_PLU_number, i_order_limit, i_quantity, i_price);
            
    END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 10a
-- Author: dvaidyanathan6
-- Name: manager_view_drone_technicians
DROP PROCEDURE IF EXISTS manager_view_drone_technicians;
DELIMITER //
CREATE PROCEDURE manager_view_drone_technicians(
	   IN i_chain_name VARCHAR(40),
       IN i_drone_tech VARCHAR(40),
       IN i_store_name VARCHAR(40)
)
BEGIN
-- Type solution below

DROP TABLE IF EXISTS manager_view_drone_technicians_result;
CREATE TABLE manager_view_drone_technicians_result
	SELECT Username AS "Username", concat(FirstName," ", LastName) AS "Name", StoreName AS "Location" 
    FROM DRONE_TECH NATURAL JOIN USERS 
    WHERE 
    ((i_drone_tech IS NOT NULL) AND (i_store_name IS NOT NULL) AND (Username = i_drone_tech) AND (StoreName = i_store_name) AND (Chainname = i_chain_name)) OR
    ((i_drone_tech IS NOT NULL) AND (i_store_name IS NULL OR i_store_name = '') AND (Username = i_drone_tech) AND (Chainname = i_chain_name)) OR
    ((i_drone_tech IS NULL OR i_drone_tech = '') AND (i_store_name IS NOT NULL) AND (StoreName = i_store_name) AND (Chainname = i_chain_name)) OR
    ((i_drone_tech IS NULL OR i_drone_tech = '') AND (i_store_name IS NULL OR i_store_name = '') AND (Chainname = i_chain_name));


-- End of solution
END //
DELIMITER ;

-- ID: 11a
-- Author: vtata6
-- Name: manager_view_drones
DROP PROCEDURE IF EXISTS manager_view_drones;
DELIMITER //
CREATE PROCEDURE manager_view_drones(
	   IN i_mgr_username varchar(40), 
	   IN i_drone_id int, 
       IN drone_radius int
)
BEGIN
-- Type solution below	   
DROP TABLE IF EXISTS manager_view_drones_result;
CREATE TABLE manager_view_drones_result
	SELECT ID AS "Drone ID", DroneTech AS "Operator", Radius, Zip AS "Zip Code", DroneStatus as "Status"
    FROM DRONE JOIN DRONE_TECH ON (DroneTech = Username) JOIN MANAGER ON (DRONE_TECH.ChainName = MANAGER.ChainName)
    WHERE
    ((i_drone_id IS NOT NULL) AND (ID = i_drone_id) AND
		(drone_radius IS NOT NULL) AND (Radius >= drone_radius) AND 
				(DRONE_TECH.ChainName = (select ChainName FROM MANAGER WHERE Username = i_mgr_username))) OR
                
    ((i_drone_id IS NOT NULL) AND (ID = i_drone_id) AND 
		(drone_radius IS NULL or drone_radius = '') AND
			(DRONE_TECH.ChainName = (select ChainName from MANAGER WHERE Username = i_mgr_username))) OR
            
    ((i_drone_id IS NULL or i_drone_id = '') AND 
		(drone_radius IS NOT NULL) AND (Radius >= drone_radius) AND 
				(DRONE_TECH.ChainName = (select ChainName from MANAGER WHERE Username = i_mgr_username)))OR
                
    ((i_drone_id IS NULL or i_drone_id = '') AND 
		(drone_radius IS NULL or drone_radius = '') AND 
			(DRONE_TECH.ChainName = (select ChainName from MANAGER WHERE Username = i_mgr_username)));


-- End of solution
END //
DELIMITER ;

-- ID: 12a
-- Author: vtata6
-- Name: manager_manage_stores
DROP PROCEDURE IF EXISTS manager_manage_stores;
DELIMITER //
CREATE PROCEDURE manager_manage_stores(
	   IN i_mgr_username varchar(50), 
	   IN i_storeName varchar(50), 
	   IN i_minTotal int, 
	   IN i_maxTotal int
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS manager_manage_stores_result;
CREATE TABLE manager_manage_stores_result
SELECT StoreName, concat(Street," ", City,", ", State, " ", Zipcode) "Address", Orders, Employees+1 "Employees", OTotal AS "Total"
    FROM ORDERS 
	NATURAL JOIN (SELECT ChainName, OrderID "ID", Quantity FROM CONTAINS WHERE ChainName = (SELECT ChainName from Manager WHERE Username = i_mgr_username)) C
    NATURAL JOIN (SELECT PLUNumber, PRICE FROM CHAIN_ITEM WHERE ChainName = (SELECT ChainName from Manager WHERE Username = i_mgr_username)) CI 
    NATURAL JOIN (SELECT DroneTech, ID "DroneID" FROM DRONE) D
    NATURAL JOIN (SELECT StoreName, Username "DroneTech" FROM DRONE_TECH) DT
    NATURAL JOIN (SELECT StoreName, count(*) 'Employees' FROM DRONE_TECH WHERE ChainName = (SELECT ChainName from Manager WHERE Username = i_mgr_username) GROUP BY StoreName) AS temp
    NATURAL JOIN (SELECT Storename, Street, City, State, Zipcode FROM Store) temp1
    NATURAL JOIN (select Storename, count(*) "Orders" from Orders natural join (select ID "DroneID", DroneTech, Storename from Drone natural join (select username "DroneTech", Storename FROM DRONE_TECH where chainname = (SELECT ChainName from Manager WHERE Username = i_mgr_username)) x) y group by storename) z
	NATURAL JOIN (select storename, sum(price*quantity) As "OTotal" from orders 
		natural join (select orderID "ID", itemname, price, quantity from contains 
        natural join (select ChainItemName "ItemName", price from chain_item where chainname = (SELECT ChainName from Manager WHERE Username = i_mgr_username) )temp0)temp1 
        natural join (select ID "DroneID", DroneTech, Storename from Drone 
        natural join (select username "DroneTech", Storename FROM DRONE_TECH where chainname = (SELECT ChainName from Manager WHERE Username = i_mgr_username)) temp2)temp3 group by storename) temp4
GROUP BY StoreName
HAVING
((i_storeName IS NOT NULL) 
	AND (i_minTotal IS NOT NULL) 
    AND (i_maxTotal IS NOT NULL) 
    AND (Storename like i_storeName) 
    AND (Total > i_minTotal) 
    AND (Total < i_maxTotal)) 
    OR
((i_storeName IS NOT NULL) 
	AND (i_minTotal IS NULL OR i_minTotal = '') 
    AND (i_maxTotal IS NOT NULL) 
    AND (Storename like i_storeName) 
    AND (Total < i_maxTotal)) 
    OR
((i_storeName IS NOT NULL)
    AND (i_minTotal IS NOT NULL) 
	AND (i_maxTotal IS NULL OR i_minTotal = '') 
    AND (Storename like i_storeName) 
    AND (Total < i_maxTotal)) 
    OR
((i_storeName IS NOT NULL)
    AND (i_minTotal IS NULL OR i_minTotal = '')
	AND (i_maxTotal IS NULL OR i_minTotal = '') 
    AND (Storename like i_storeName))
    OR
((i_storeName IS NULL)    
	AND (i_minTotal IS NOT NULL) 
    AND (i_maxTotal IS NOT NULL) 
    AND (Total > i_minTotal) 
    AND (Total < i_maxTotal)) 
    OR
((i_storeName IS NULL)
	AND (i_minTotal IS NULL OR i_minTotal = '') 
    AND (i_maxTotal IS NOT NULL) 
    AND (Total < i_maxTotal)) 
    OR
((i_storeName IS NULL)
	AND (i_minTotal IS NULL) 
    AND (i_maxTotal IS NULL OR i_minTotal = '') 
    AND (Total > i_minTotal)) 
    OR
((i_storeName IS NULL)
	AND (i_minTotal IS NULL OR i_minTotal = '') 
    AND (i_maxTotal IS NULL OR i_minTotal = ''));

-- End of solution
END //
DELIMITER ;

-- ID: 13a
-- Author: vtata6
-- Name: customer_change_credit_card_information
DROP PROCEDURE IF EXISTS customer_change_credit_card_information;
DELIMITER //
CREATE PROCEDURE customer_change_credit_card_information(
	   IN i_custUsername varchar(40), 
	   IN i_new_cc_number varchar(19), 
	   IN i_new_CVV int, 
	   IN i_new_exp_date date
)
BEGIN
-- Type solution below
	DROP TABLE IF EXISTS customer_change_credit_card_information_result;
	CREATE TABLE customer_change_credit_card_information_result;
	IF
		EXISTS (SELECT Username from USERS WHERE Username = i_custUsername) AND i_new_exp_date > CURDATE()

    THEN
		UPDATE CUSTOMER
        SET CcNumber = i_new_cc_number, CVV = i_new_CVV, EXP_DATE = i_new_exp_date
		WHERE Username = i_custUsername;
            
    END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 14a
-- Author: ftsang3
-- Name: customer_view_order_history
DROP PROCEDURE IF EXISTS customer_view_order_history;
DELIMITER //
CREATE PROCEDURE customer_view_order_history(
	   IN i_username VARCHAR(40),
       IN i_orderid INT
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS customer_view_order_history_result;
CREATE TABLE customer_view_order_history_result
SELECT SUM(CONTAINS.Quantity * CHAIN_ITEM.Price) AS 'Total Amount', SUM(CONTAINS.Quantity) AS 'Total Items', OrderDate AS 'Date of Purchase',
DroneID AS 'Drone ID', Drone.DroneTech AS "Store Associate", OrderStatus as 'Status'
FROM ORDERS, CONTAINS, CHAIN_ITEM, DRONE, USERS
WHERE ORDERS.ID in (SELECT ID FROM ORDERS WHERE CustomerUsername = i_username) 
AND ORDERS.ID = CONTAINS.OrderID
AND ORDERS.ID = i_orderid
AND CustomerUsername = i_username
AND CONTAINS.PLUNumber = CHAIN_ITEM.PLUNumber
AND CONTAINS.ChainName = CHAIN_ITEM.ChainName
AND DroneID = DRONE.ID
AND Username = DroneTech
GROUP BY DroneID, OrderDate, OrderStatus;


-- End of solution
END //
DELIMITER ;

-- ID: 15a
-- Author: ftsang3
-- Name: customer_view_store_items
DROP PROCEDURE IF EXISTS customer_view_store_items;
DELIMITER //
CREATE PROCEDURE customer_view_store_items(
	   IN i_username VARCHAR(40),
       IN i_chain_name VARCHAR(40),
       IN i_store_name VARCHAR(40),
       IN i_item_type VARCHAR(40)
)
BEGIN
-- Type solution below
    IF STRCMP(UPPER(i_item_type), 'ALL') = 0 THEN
		DROP TABLE IF EXISTS customer_view_store_items_result;
		CREATE TABLE customer_view_store_items_result
		SELECT ChainItemName AS "Items", Orderlimit
		FROM CHAIN_ITEM, USERS, STORE
		WHERE CHAIN_ITEM.ChainName = i_chain_name
        AND USERS.Zipcode = STORE.Zipcode 
        AND Username = i_username
        AND StoreName = i_store_name;
    
    ELSE
		DROP TABLE IF EXISTS customer_view_store_items_result;
		CREATE TABLE customer_view_store_items_result
		SELECT ChainItemName AS "Items", Orderlimit
		FROM CHAIN_ITEM, USERS, STORE
		WHERE CHAIN_ITEM.ChainName = i_chain_name AND ChainItemName IN (SELECT ItemName FROM ITEM WHERE ItemType = i_item_type)
        AND USERS.Zipcode = STORE.Zipcode 
        AND Username = i_username
        AND StoreName = i_store_name;
    
    END IF;

-- End of solution
END //
DELIMITER ;

-- ID: 15b
-- Author: ftsang3
-- Name: customer_select_items
DROP PROCEDURE IF EXISTS customer_select_items;
DELIMITER //
CREATE PROCEDURE customer_select_items(
	    IN i_username VARCHAR(40),
    	IN i_chain_name VARCHAR(40),
    	IN i_store_name VARCHAR(40),
    	IN i_item_name VARCHAR(40),
    	IN i_quantity INT
)
BEGIN
-- Type solution below
	-- DROP TABLE IF EXISTS customer_select_items_result;
	-- CREATE TABLE customer_select_items_result;    
    IF
		EXISTS (SELECT USERS.Zipcode 
        FROM CHAIN_ITEM, USERS, STORE 
        WHERE Username = i_username
        AND StoreName = i_store_name
        AND USERS.Zipcode = STORE.Zipcode
        AND CHAIN_ITEM.ChainName = i_chain_name
        AND STORE.ChainName = i_chain_name
		AND ChainItemName = i_item_name
        AND i_quantity < Quantity
        AND i_quantity < Orderlimit)
	THEN
		INSERT INTO ORDERS (OrderStatus, OrderDate, CustomerUsername)
			VALUES ('Creating', CURDATE(), i_username);
		
        SET @pluNum = (SELECT PLUNumber FROM CHAIN_ITEM WHERE ChainItemName = i_item_name AND ChainName = i_chain_name);
		INSERT INTO CONTAINS (OrderID, ItemName, ChainName, PLUNumber, Quantity)
			VALUES (LAST_INSERT_ID(), i_item_name, i_chain_name, @pluNum, i_quantity);
	
    END IF;
-- End of solution
END //
DELIMITER ;
         
-- ID: 16a
-- Author: jkomskis3
-- Name: customer_review_order
DROP PROCEDURE IF EXISTS customer_review_order;
DELIMITER //
CREATE PROCEDURE customer_review_order(
	   IN i_username VARCHAR(40)
)
BEGIN
-- Type solution below
	DROP TABLE IF EXISTS customer_review_order_result;
	CREATE TABLE customer_review_order_result
    
    SELECT ItemName AS 'Items', CONTAINS.Quantity, CHAIN_ITEM.Price AS 'Unit Cost'
    FROM ORDERS, CONTAINS, CHAIN_ITEM
    WHERE ID in (SELECT ID FROM ORDERS WHERE CustomerUsername = i_username) 
    AND ID = CONTAINS.OrderID
    AND CONTAINS.PLUNumber = CHAIN_ITEM.PLUNumber
    AND CONTAINS.ChainName = CHAIN_ITEM.ChainName
    AND OrderStatus = 'Creating';
    
-- End of solution
END //
DELIMITER ;


-- ID: 16b
-- Author: jkomskis3
-- Name: customer_update_order
DROP PROCEDURE IF EXISTS customer_update_order;
DELIMITER //
CREATE PROCEDURE customer_update_order(
	   IN i_username VARCHAR(40),
       IN i_item_name VARCHAR(40),
       IN i_quantity INT
)
BEGIN
-- Type solution below
	-- DROP TABLE IF EXISTS customer_update_order_result;
	-- CREATE TABLE customer_update_order_result;
    
	IF
		EXISTS (SELECT CustomerUsername FROM ORDERS WHERE CustomerUsername = i_username) AND
        EXISTS (SELECT ItemName FROM CONTAINS WHERE ItemName = i_item_name) AND
        EXISTS (SELECT OrderStatus FROM ORDERS WHERE OrderStatus = 'Creating') AND
        i_quantity > 0

    THEN
		UPDATE CONTAINS
        SET Quantity = i_quantity
		WHERE ItemName = i_item_name
		AND CONTAINS.OrderID in (SELECT ID FROM ORDERS WHERE CustomerUsername = i_username AND OrderStatus = 'Creating' AND ID = CONTAINS.OrderID);
        
	ELSEIF
		EXISTS (SELECT CustomerUsername FROM ORDERS WHERE CustomerUsername = i_username) AND
        EXISTS (SELECT ItemName FROM CONTAINS WHERE ItemName = i_item_name) AND
        EXISTS (SELECT OrderStatus FROM ORDERS WHERE OrderStatus = 'Creating') AND
		i_quantity = 0
	THEN
		DELETE FROM CONTAINS
        WHERE itemName = i_item_name
        AND CONTAINS.OrderID in (SELECT ID FROM ORDERS WHERE CustomerUsername = i_username AND OrderStatus = 'Creating' AND ID = CONTAINS.OrderID);
        
    END IF;
    
-- End of solution
END //
DELIMITER ;


-- ID: 17a
-- Author: jkomskis3
-- Name: customer_update_order
DROP PROCEDURE IF EXISTS drone_technician_view_order_history;
DELIMITER //
CREATE PROCEDURE drone_technician_view_order_history(
        IN i_username VARCHAR(40),
    	IN i_start_date DATE,
    	IN i_end_date DATE
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS drone_technician_view_order_history_result;
CREATE TABLE drone_technician_view_order_history_result
SELECT ORDERS.ID "ID", Operator, OrderDate, DroneID, OrderStatus "Status", sum(Quantity*Price) "Total" 
FROM ORDERS
JOIN (SELECT OrderID, ItemName, Quantity, Price
	  FROM CONTAINS 
	  JOIN (SELECT Price, ChainItemName 
			FROM CHAIN_ITEM 
			WHERE Chain_Item.ChainName = (select chainname from drone_tech where username = i_username)) a 
			ON (ItemName = ChainItemName) 
			WHERE Contains.ChainName = (select chainname from drone_tech where username = i_username)) b
			ON (ID = OrderID)
	LEFT JOIN (SELECT ID, DroneTech FROM DRONE) c ON (c.ID = DroneID)
	LEFT JOIN (SELECT Username FROM DRONE_TECH ) d ON (c.DroneTech = d.Username)
    LEFT JOIN (SELECT Username, concat(FirstName," ",LastName) "Operator" FROM USERS) e ON (e.Username = d.Username)
    WHERE             
	(
		(
			i_start_date IS NOT NULL AND
			i_end_date IS NOT NULL AND
            OrderDate >= i_start_date AND
            OrderDate <= i_end_date
		) 
        OR
        (
			i_start_date IS NOT NULL AND
			i_end_date IS NULL AND
            OrderDate >= i_start_date
		)
        OR
		(
			i_start_date IS NULL AND
			i_end_date IS NOT NULL AND
            OrderDate <= i_end_date
		)
        OR
		(
			i_start_date IS NULL AND
			i_end_date IS NULL
		)
	)
	GROUP BY OrderID;

-- End of solution
END //
DELIMITER ;

-- ID: 17b
-- Author: agoyal89
-- Name: dronetech_assign_order
DROP PROCEDURE IF EXISTS dronetech_assign_order;
DELIMITER //
CREATE PROCEDURE dronetech_assign_order(
	   IN i_username VARCHAR(40),
       IN i_droneid INT,
       IN i_status VARCHAR(20),
       IN i_orderid INT
)
BEGIN
-- Type solution below
set @State = (select Orderstatus from ORDERS WHere ID  = i_orderID);
set @Assigned = (select droneid from orders where id = i_orderID);
IF @State = "Pending" THEN 
	UPDATE ORDERS SET Orderstatus = i_status, DroneID = i_droneid WHERE ID = i_orderID; 
    UPDATE DRONE SET DroneStatus = 'Busy' WHERE ID = i_droneid;
END IF;
IF @State = "Drone Assigned" THEN
	UPDATE ORDERS SET Orderstatus = i_status WHERE ID = i_orderID; 
END IF;
IF @Assigned = i_droneid AND @Assigned in (select ID from drone where dronetech = i_username) THEN
	UPDATE ORDERS SET OrderStatus = i_status WHERE ID = i_orderid;
END IF;
-- End of solution
END //
DELIMITER ;

-- ID: 18a
-- Author: agoyal89
-- Name: dronetech_order_details
DROP PROCEDURE IF EXISTS dronetech_order_details;
DELIMITER //
CREATE PROCEDURE dronetech_order_details(
	   IN i_username VARCHAR(40),
       IN i_orderid VARCHAR(40)
)
BEGIN
-- Type solution below
	SET @customer = (SELECT concat(FirstName," ", LastName) FROM USERS, ORDERS WHERE Username = CustomerUsername AND ID = i_orderid);
    SET @droneTech = (SELECT concat(FirstName," ", LastName) FROM USERS WHERE Username = i_username);
	
    DROP TABLE IF EXISTS dronetech_order_details_result;
	CREATE TABLE dronetech_order_details_result
    
    SELECT @customer AS "Customer Name", ORDERS.ID AS "Order ID",
	SUM(CONTAINS.Quantity * CHAIN_ITEM.Price) AS 'Total Amount', SUM(CONTAINS.Quantity) AS 'Total Items',
	OrderDate AS 'Date of Purchase', DroneID AS "Drone ID", @droneTech AS "Store Associate", OrderStatus as 'Status',
	concat(Street,", ",City,", ", State," ",Zipcode) AS "Address"
	FROM ORDERS, CONTAINS, CHAIN_ITEM, DRONE, USERS
	WHERE DRONE.ID in (SELECT ID FROM DRONE WHERE DroneTech = i_username)
    AND ORDERS.ID in (SELECT ID FROM ORDERS WHERE DroneID = DRONE.ID)
	AND ORDERS.ID = CONTAINS.OrderID
	AND ORDERS.ID = i_orderid
	AND CONTAINS.PLUNumber = CHAIN_ITEM.PLUNumber
	AND CONTAINS.ChainName = CHAIN_ITEM.ChainName
	AND DroneID = DRONE.ID
	AND Username = CustomerUsername
	GROUP BY DroneID, OrderDate, OrderStatus;
    
    
-- End of solution
END //
DELIMITER ;


-- ID: 18b
-- Author: agoyal89
-- Name: dronetech_order_items
DROP PROCEDURE IF EXISTS dronetech_order_items;
DELIMITER //
CREATE PROCEDURE dronetech_order_items(
        IN i_username VARCHAR(40),
    	IN i_orderid INT
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS dronetech_order_items_result;
CREATE TABLE dronetech_order_items_result
SELECT chainItemName AS 'Item', contains.Quantity AS 'Count' 
FROM CHAIN_ITEM, contains, ORDERS
WHERE ORDERS.ID = CONTAINS.OrderID
AND ORDERS.ID = i_orderid
AND CONTAINS.PLUNumber = CHAIN_ITEM.PLUNumber
AND CONTAINS.ChainName = CHAIN_ITEM.ChainName;

-- End of solution
END //
DELIMITER ;


-- ID: 19a
-- Author: agoyal89
-- Name: dronetech_assigned_drones
DROP PROCEDURE IF EXISTS dronetech_assigned_drones;
DELIMITER //
CREATE PROCEDURE dronetech_assigned_drones(
        IN i_username VARCHAR(40),
    	IN i_droneid INT,
    	IN i_status VARCHAR(20)
)
BEGIN
-- Type solution below
DROP TABLE IF EXISTS dronetech_assigned_drones_result;
CREATE TABLE dronetech_assigned_drones_result
SELECT ID AS 'Drone ID', DroneStatus AS 'Status', Radius AS 'Radius'
FROM DRONE JOIN DRONE_TECH ON (DroneTech = Username)
WHERE
	(i_username IS NOT NULL AND (i_username = DRONE_TECH.Username)
    AND i_droneid is NOT NULL AND (i_droneid = ID)
    AND i_status IS NOT NULL AND i_status = DroneStatus) OR
    
    (i_username IS NOT NULL AND (i_username = DRONE_TECH.Username)
    AND (i_droneid is NULL or i_droneid = '')
    AND i_status IS NOT NULL AND i_status = DroneStatus) OR
    
	(i_username IS NOT NULL AND (i_username = DRONE_TECH.Username)
    AND i_droneid is NOT NULL AND (i_droneid = ID)
    AND (i_status IS NULL or i_status = '')) OR
    
    (i_username IS NOT NULL AND (i_username = DRONE_TECH.Username)
    AND (i_droneid is NULL or i_droneid = '')
    AND (i_status IS NULL or i_status = '')) OR
    
    (i_username IS NOT NULL AND (i_username = DRONE_TECH.Username)
    AND (i_status = 'All')
    AND (i_droneid IS NULL or i_droneid = '')) OR
    
    (i_username IS NOT NULL AND (i_username = DRONE_TECH.Username)
    AND (i_status = 'All')
    AND (i_droneid IS NOT NULL and i_droneid = ID));



-- End of solution
END //
DELIMITER ;
