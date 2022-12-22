-- CS4400: Introduction to Database Systems
-- Spring 2021
-- Phase II Create Table and Insert Statements Template


-- Team 62
-- Team Member Aidan Anderson (aanderson306)
-- Team Member Andreea Juravschi (ajuravschi3)
-- Team Member Dowon Kim (dkim694)
-- Team Member Dong Hyuk Park (dpark346)

-- Directions:
-- Please follow all instructions from the Phase II assignment PDF.
-- This file must run without error for credit.
-- Create Table statements should be manually written, not taken from an SQL Dump.
-- Rename file to cs4400_phase2_teamX.sql before submission

drop database if exists droneGroceryTest;
create database if not exists droneGroceryTest;
use droneGroceryTest;

-- CREATE TABLE STATEMENTS BELOW

create table groceryUser (
	userName char(100),
    passcode char(100) not null,
    fName char(100) not null,
    lName char(100) not null,
    zip char(5) not null,
    state char(2) not null,
    city char(15) not null,
    street char(100) not null,
    primary key (userName)
) engine = innodb;

create table customer (
	userName char(100),
    ccNumber char(20),
    CVV char(3),
    ExpDate date,
    constraint fk1 foreign key (userName) references groceryUser(userName),
    primary key (userName)
) engine = innodb;

create table employee (
	userName char(100),
   	constraint fk2 foreign key (userName) references groceryUser(userName),
	primary key (userName)
) engine = innodb;


create table groceryAdmin (
	userName char(100),
	PRIMARY KEY (userName),
	constraint fk6 FOREIGN KEY (userName) REFERENCES groceryUser(userName)
) engine = innodb;

create table groceryChain (
	chainName char(100),
	PRIMARY KEY (chainName)
) engine = innodb;

create table manager (
	userName char(100),
	manages char(50),
	constraint fk4 foreign key (userName) references employee(userName),
    constraint fk5 foreign key (manages) references groceryChain(chainName),
    PRIMARY KEY (userName)
) engine = innodb;

create table store (
	chainName char(100),
	storeName char(100),
	zip char(5),
	state char(2),
	city varchar(100),
	street varchar(255),
    constraint fk9 foreign key (chainName) REFERENCES groceryChain(chainName),
	primary key (storeName, chainName)
) engine = innodb;


create table technician (
	userName char(100),
	works_at char(100),
	PRIMARY KEY (userName),
	constraint fk10 FOREIGN KEY (userName) REFERENCES employee(userName),
	constraint fk11 FOREIGN KEY (works_at) REFERENCES store(storeName)
) engine = innodb;

create table drone (
    ID char(100),
    radius int not null,
    zip int not null,
    droneStatus char(100) not null,
    Worked_on_by char(100) not null,
    constraint fk3 foreign key (Worked_on_by) references technician(userName),
    primary key (ID)
) engine = innodb;


create table groceryOrder (
	ID INT AUTO_INCREMENT, 
	orderStatus ENUM('Drone Assigned', 'Delivered', 'In Transit', 'Pending'),
	orderDate DATE DEFAULT (DATE_FORMAT(NOW(), '%d-%m-%Y')),
	made_by char(100),
	deliver char(100),
	constraint fk7 foreign key (made_by) REFERENCES customer(userName),
	constraint fk8  FOREIGN KEY (deliver) REFERENCES drone(ID) ON DELETE SET NULL,
	PRIMARY KEY (ID)
) engine = innodb;


create table item (
	itemName varchar(100), 
	orderType char(100) NOT NULL,
	origin char(100) NOT NULL,
	organic char(5) NOT NULL,
	PRIMARY KEY (itemName)
) engine = innodb;

create table chainItem (
	chainName char(100),
	itemName char(100),
	PLU_Number char(100),
	order_limit INT,
	quantity INT,
	price DECIMAL (5,2),
	PRIMARY KEY (chainName, itemName, PLU_Number),
	constraint fk12 FOREIGN KEY (chainName) REFERENCES groceryChain(chainName),
	constraint fk13 FOREIGN KEY (itemName) REFERENCES item(itemName)
) engine = innodb;

create table groceryContains (
	ID INT,
	PLU_Number char(100),
	chainName char(100),
    itemName char(100),
	quantity INT,
	PRIMARY KEY (ID, chainName, itemName, PLU_Number),
	constraint fk14 FOREIGN KEY (ID) REFERENCES groceryOrder(ID), 
	constraint fk15 FOREIGN KEY (chainName, itemName, PLU_Number) REFERENCES chainItem(chainName, itemName, PLU_Number)
) engine = innodb;


-- INSERT STATEMENTS BELOW

INSERT INTO groceryuser (userName, passcode, fName, lName, street, city, state, zip)
VALUES
('mmoss7', 'password2', 'Mark', 'Moss', '15 Tech Lane', 'Duluth', 'GA', '30047'),
('lchen27', 'password3', 'Liang', 'Chen', '40 Walker Rd ', 'Kennesaw', 'GA', '30144'),
('jhilborn97', 'password4', 'Jack', 'Hilborn', '177 W Beaverdam Rd', 'Atlanta', 'GA', '30303'),
('jhilborn98', 'password5', 'Jake', 'Hilborn', '4605 Nasa Pkwy', 'Atlanta', 'GA', '30309'),
('ygao10', 'password6', 'Yuan', 'Gao', '27 Paisley Dr SW', 'Atlanta', 'GA', '30313'),
('kfrog03', 'password7', 'Kermit', 'Frog', '707 E Norfolk Ave', 'Atlanta', 'GA', '30318'),
('cforte58', 'password8', 'Connor', 'Forte', '13817 Shirley Ct NE', 'Atlanta', 'GA', '30332'),
('fdavenport49', 'password9', 'Felicia', 'Devenport', '6150 Old Millersport Rd NE', 'College Park', 'GA', '30339'),
('hliu88', 'password10', 'Hang', 'Liu', '1855 Fruit St', 'Atlanta', 'GA', '30363'),
('akarev16', 'password11', 'Alex', 'Karev', '100 NW 73rd Pl ', 'Johns Creek', 'GA', '30022'),
('jdoe381', 'password12', 'Jane ', 'Doe', '12602 Gradwell St', 'Duluth', 'GA', '30047'),
('sstrange11', 'password13', 'Stephen', 'Strange', '112 Huron Dr', 'Kennesaw', 'GA', '30144'),
('dmcstuffins7', 'password14', 'Doc', 'Mcstuffins', '27 Elio Cir', 'Atlanta', 'GA', '30303'),
('mgrey91', 'password15', 'Meredith', 'Grey', '500 N Stanwick Rd', 'Atlanta', 'GA', '30309'),
('pwallace51', 'password16', 'Penny', 'Wallace', '3127 Westwood Dr NW', 'Atlanta', 'GA', '30313'),
('jrosario34', 'password17', 'Jon', 'Rosario', '1111 Catherine St', 'Atlanta', 'GA', '30318'),
('nshea230', 'password18', 'Nicholas', 'Shea', '299 Shady Ln', 'Atlanta', 'GA', '30332'),
('mgeller3', 'password19', 'Monica ', 'Geller', '120 Stanley St', 'College Park', 'GA', '30339'),
('rgeller9', 'password20', 'Ross', 'Geller ', '4206 106th Pl NE', 'Atlanta', 'GA', '30363'),
('jtribbiani27', 'password21', 'Joey ', 'Tribbiani', '143 Pebble Ln', 'Johns Creek', 'GA', '30022'),
('pbuffay56', 'password22', 'Phoebe ', 'Buffay', '230 County Rd', 'Duluth', 'GA', '30047'),
('rgreen97', 'password23', 'Rachel', 'Green', '40 Frenchburg Ct', 'Kennesaw', 'GA', '30144'),
('cbing101', 'password24', 'Chandler ', 'Bing', '204 S Mapletree Ln', 'Atlanta', 'GA', '30303'),
('pbeesly61', 'password25', 'Pamela', 'Beesly', '932 Outlaw Bridge Rd', 'Atlanta', 'GA', '30309'),
('jhalpert75', 'password26', 'Jim ', 'Halpert', '185 Dry Creek Rd', 'Atlanta', 'GA', '30313'),
('dschrute18', 'password27', 'Dwight ', 'Schrute', '3009 Miller Ridge Ln', 'Atlanta', 'GA', '30318'),
('amartin365', 'password28', 'Angela ', 'Martin', '905 E Pinecrest Cir', 'Atlanta', 'GA', '30332'),
('omartinez13', 'password29', 'Oscar', 'Martinez', '26958 Springcreek Rd', 'College Park', 'GA', '30339'),
('mscott845', 'password30', 'Michael ', 'Scott', '105 Calusa Lake Dr', 'Denver', 'CO', '80014'),
('abernard224', 'password31', 'Andy ', 'Bernard', '21788 Monroe Rd #284', 'Johns Creek', 'GA', '30022'),
('kkapoor155', 'password32', 'Kelly ', 'Kapoor', '100 Forest Point Dr', 'Duluth', 'GA', '30047'),
('dphilbin81', 'password33', 'Darryl ', 'Philbin', '800 Washington St', 'Kennesaw', 'GA', '30144'),
('sthefirst1', 'password34', 'Sofia', 'Thefirst', '4337 Village Creek Dr', 'Atlanta', 'GA', '30303'),
('gburdell1', 'password35', 'George', 'Burdell', '201 N Blossom St', 'Atlanta', 'GA', '30309'),
('dsmith102', 'password36', 'Dani', 'Smith', '1648 Polk Rd', 'Atlanta', 'GA', '30313'),
('dbrown85', 'password37', 'David', 'Brown', '12831 Yorba Ave', 'Atlanta', 'GA', '30318'),
('dkim99', 'password38', 'Dave', 'Kim', '1710 Buckner Rd', 'Atlanta', 'GA', '30332'),
('tlee984', 'password39', 'Tom', 'Lee', '205 Mountain Ave', 'College Park', 'GA', '30339'),
('jpark29', 'password40', 'Jerry', 'Park', '520 Burberry Way', 'Atlanta', 'GA', '30363'),
('vneal101', 'password41', 'Vinay', 'Neal', '190 Drumar Ct', 'Johns Creek', 'GA', '30022'),
('hpeterson55', 'password42', 'Haydn', 'Peterson', '878 Grand Ivey Pl', 'Duluth', 'GA', '30047'),
('lpiper20', 'password43', 'Leroy', 'Piper', '262 Stonecliffe Aisle', 'Kennesaw', 'GA', '30144'),
('mbob2', 'password44', 'Chuck', 'Bass', '505 Bridge St', 'New York', 'NY', '10033'),
('mrees785', 'password45', 'Marie', 'Rees', '1081 Florida Ln', 'Atlanta', 'GA', '30309'),
('wbryant23', 'password46', 'William', 'Bryant', '109 Maple St', 'Atlanta', 'GA', '30313'),
('aallman302', 'password47', 'Aiysha', 'Allman', '420 Austerlitz Rd', 'Atlanta', 'GA', '30318'),
('kweston85', 'password48', 'Kyle', 'Weston', '100 Palace Dr', 'Birmingham', 'AL', '35011'),
('lknope98', 'password49', 'Leslie ', 'Knope', '10 Dogwood Ln', 'College Park', 'GA', '30339'),
('bwaldorf18', 'password50', 'Blair ', 'Waldorf', '1110 Greenway Dr', 'Atlanta', 'GA', '30363');

INSERT INTO customer (username, ccNumber, CVV, ExpDate)
VALUES 
('mscott845', '6518 5559 7446 1663', '551', '2021-02-21'),
('abernard224', '2328 5670 4310 1965', '644', '2021-05-21'),
('kkapoor155', '8387 9523 9827 9291', '201', '1931-02-01'),
('dphilbin81', '6558 8596 9852 5299', '102', '2021-12-21'),
('sthefirst1', '3414 7559 3721 2479', '489', '2021-11-21'),
('gburdell1', '5317 1210 9087 2666', '852', '2021-01-21'),
('dsmith102', '9383 3212 4198 1836', '455', '2021-08-21'),
('dbrown85', '3110 2669 7949 5605', '744', '2021-10-21'),
('dkim99', '2272 3555 4078 4744', '606', '2021-08-21'),
('tlee984', '9276 7639 7883 4273', '862', '2021-08-21'),
('jpark29', '4652 3726 8864 3798', '258', '2021-12-21'),
('vneal101', '5478 8420 4436 7471', '857', '2021-09-21'),
('hpeterson55', '3616 8977 1296 3372', '295', '2021-04-21'),
('lpiper20', '9954 5698 6355 6952', '794', '2021-04-21'),
('mbob2', '7580 3274 3724 5356', '269', '2021-05-21'),
('mrees785', '7907 3513 7161 4248', '858', '2021-08-21'),
('wbryant23', '1804 2062 7825 9689', '434', '2021-04-21'),
('aallman302', '2254 7887 8863 3807', '862', '2021-04-21'),
('kweston85', '8445 8585 2138 1374', '632', '2021-11-21'),
('lknope98', '1440 2292 5962 4450', '140', '1931-04-01'),
('bwaldorf18', '5839 2673 8600 1880', '108', '2021-12-21');

INSERT INTO employee (userName)
VALUES 
('lchen27'),
('jhilborn97'),
('jhilborn98'),
('ygao10'),
('kfrog03'),
('cforte58'),
('fdavenport49'),
('hliu88'),
('akarev16'),
('jdoe381'),
('sstrange11'),
('dmcstuffins7'),
('mgrey91'),
('pwallace51'),
('jrosario34'),
('nshea230'),
('mgeller3'),
('rgeller9'),
('jtribbiani27'),
('pbuffay56'),
('rgreen97'),
('cbing101'),
('pbeesly61'),
('jhalpert75'),
('dschrute18'),
('amartin365'),
('omartinez13');

INSERT INTO groceryAdmin (userName)
VALUES ('mmoss7');

INSERT INTO groceryChain (chainName)
VALUES
('Sprouts'),
('Whole Foods'),
('Kroger'),
('Walmart'),
('Moss Market'),
("Trader Joe's"),
('Publix'),
('Query Mart');


INSERT INTO manager (userName, manages)
VALUES
('rgreen97', 'Kroger'),
('cbing101', 'Publix'),
('pbeesly61', 'Walmart'),
("jhalpert75", "Trader Joe's"),
('dschrute18', 'Whole Foods'),
('amartin365', 'Sprouts'),
('omartinez13', 'Query Mart');

INSERT INTO store (chainName, storeName, street, city, state, zip)
VALUES
('Sprouts','Abbots Bridge','116 Bell Rd','Johns Creek','GA','30022'),
('Whole Foods','North Point','532 8th St NW','Johns Creek','GA','30022'),
('Kroger','Norcross','650 Singleton Road','Duluth','GA','30047'),
('Walmart','Pleasant Hill','2365 Pleasant Hill Rd','Duluth','GA','30047'),
('Moss Market','KSU Center','3305 Busbee Drive NW','Kennesaw','GA','30144'),
("Trader Joe's",'Owl Circle','48 Owl Circle SW','Kennesaw','GA','30144'),
('Publix','Park Place','10 Park Place South SE','Atlanta','GA','30303'),
('Publix','The Plaza Midtown','950 W Peachtree St NW','Atlanta','GA','30309'),
('Query Mart','GT Center','172 6th St NW','Atlanta','GA','30313'),
('Whole Foods','North Avenue','120 North Avenue NW','Atlanta','GA','30313'),
('Sprouts','Piedmont','564 Piedmont ave NW','Atlanta','GA','30318'),
('Kroger','Midtown','725 Ponce De Leon Ave','Atlanta','GA','30332'),
('Moss Market','Tech Square','740 Ferst Drive ','Atlanta','GA','30332'),
('Moss Market','Bobby Dodd','150 Bobby Dodd Way NW','Atlanta','GA','30332'),
('Query Mart','Tech Square','280 Ferst Drive NW','Atlanta','GA','30332'),
('Moss Market','College Park','1895 Phoenix Blvd','College Park','GA','30339'),
('Publix','Atlanta Station','595 Piedmot Ave NE','Atlanta ','GA','30363');

INSERT INTO technician (userName, works_at)
VALUES
('lchen27', 'KSU Center'),
('jhilborn97', 'Park Place'),
('jhilborn98', 'The Plaza Midtown'),
('ygao10', 'North Avenue'),
('kfrog03', 'Piedmont'),
('cforte58', 'Tech Square'),
('fdavenport49', 'College Park'),
('hliu88', 'Atlanta Station'),
('akarev16', 'North Point'),
('jdoe381', 'Norcross'),
('sstrange11', 'Owl Circle'),
('dmcstuffins7', 'Park Place'),
('mgrey91', 'The Plaza Midtown'),
('pwallace51', 'GT Center'),
('jrosario34', 'Piedmont'),
('nshea230', 'Midtown'),
('mgeller3', 'College Park'),
('rgeller9', 'Atlanta Station'),
('jtribbiani27', 'Abbots Bridge'),
('pbuffay56', 'Pleasant Hill');

INSERT INTO drone (worked_on_by, ID, droneStatus, zip, radius)
VALUES
('lchen27', '103', 'Available', '30144', '3'),
('jhilborn97', '114', 'Available', '30303', '8'),
('jhilborn98', '105', 'Available', '30309', '4'),
('ygao10', '106', 'Available', '30313', '6'),
('kfrog03', '117', 'Available', '30318', '9'),
('cforte58', '118', 'Available', '30332', '5'),
('fdavenport49', '109', 'Available', '30339', '5'),
('hliu88', '110', 'Available', '30363', '5'),
('akarev16', '111', 'Busy', '30022', '5'),
('jdoe381', '102', 'Available', '30047', '7'),
('sstrange11', '113', 'Available', '30144', '6'),
('dmcstuffins7', '104', 'Busy', '30303', '8'),
('mgrey91', '115', 'Available', '30309', '7'),
('pwallace51', '116', 'Available', '30313', '3'),
('jrosario34', '107', 'Available', '30318', '8'),
('nshea230', '108', 'Available', '30332', '7'),
('mgeller3', '119', 'Available', '30339', '7'),
('rgeller9', '120', 'Available', '30363', '7'),
('jtribbiani27', '101', 'Available', '30022', '5'),
('pbuffay56', '112', 'Busy', '30047', '6');

INSERT INTO groceryOrder (ID, orderStatus, orderDate, made_by, deliver)
VALUES
('10001', 'Delivered', '2021-01-03', 'hpeterson55', '102'),
('10002', 'Delivered', '2021-01-13', 'abernard224', '111'),
('10003', 'Delivered', '2021-01-13', 'dbrown85', '117'),
('10004', 'Delivered', '2021-01-16', 'dkim99', '108'),
('10005', 'Delivered', '2021-01-21', 'dphilbin81', '103'),
('10006', 'Delivered', '2021-01-22', 'sthefirst1', '104'),
('10007', 'Delivered', '2021-01-22', 'sthefirst1', '104'),
('10008', 'Delivered', '2021-01-28', 'wbryant23', '116'),
('10009', 'Delivered', '2021-02-01', 'hpeterson55', '112'),
('10010', 'Delivered', '2021-02-04', 'kkapoor155', '112'),
('10011', 'Delivered', '2021-02-05', 'aallman302', '117'),
('10012', 'In Transit', '2021-02-14', 'vneal101', '111'),
('10013', 'In Transit', '2021-02-14', 'sthefirst1', '104'),
('10014', 'Drone Assigned', '2021-02-14', 'hpeterson55', '112'),
('10015', 'Pending', '2021-02-24', 'lpiper20', NULL);

INSERT INTO item (itemName, orderType, origin, organic)
VALUES
('2% Milk', 'Dairy', 'Georgia', 'Yes' ),
('4-1 Shampoo', 'Personal Care', 'Michigan', 'No' ),
('Almond Milk', 'Dairy', 'Georgia', 'No' ),
('Apple Juice', 'Beverages', 'Missouri', 'Yes' ),
('Baby Food', 'Produce', 'Georgia', 'Yes' ),
('Baby Shampoo', 'Personal Care', 'Michigan', 'Yes' ),
('Bagels', 'Bakery', 'Georgia', 'No' ),
('Bamboo Brush', 'Personal Care', 'Louisiana', 'Yes' ),
('Bamboo Comb', 'Personal Care', 'Louisiana', 'Yes' ),
('Bandaids', 'Personal Care', 'Arkansas', 'No' ),
('Black Tea', 'Beverages', 'India', 'Yes' ),
('Brown bread', 'Bakery', 'Georgia', 'No' ),
('Cajun Seasoning', 'Other', 'Lousiana', 'Yes' ),
('Campbells Soup', 'Other', 'Georgia', 'Yes' ),
('Carrot', 'Produce', 'Alabama', 'No' ),
('Chicken Breast', 'Meat', 'Georgia', 'No' ),
('Chicken Thighs', 'Meat', 'Georgia', 'Yes' ),
('Coca-cola', 'Beverages', 'Georgia', 'No' ),
('Coffee', 'Beverages', 'Columbia', 'Yes' ),
('Disani', 'Beverages', 'California', 'Yes' ),
('Doughnuts', 'Bakery', 'Georgia', 'No' ),
('Earl Grey Tea', 'Beverages', 'Italy', 'Yes' ),
('Fuji Apple', 'Produce', 'Georgia', 'No' ),
('Gala Apple', 'Produce', 'New Zealand', 'Yes' ),
('Grape Juice', 'Beverages', 'Missouri', 'No' ),
('Grassfed Beef', 'Meat', 'Georgia', 'Yes' ),
('Green Tea ', 'Beverages', 'India', 'Yes' ),
('Green Tea Shampoo', 'Personal Care', 'Michigan', 'Yes' ),
('Ground Breef', 'Meat', 'Texas', 'Yes' ),
('Ice Cream', 'Dairy', 'Georgia', 'No' ),
('Lamb Chops', 'Meat', 'New Zealand', 'Yes' ),
('Lavender Handsoap', 'Personal Care', 'France', 'Yes' ),
('Lemon Handsoap', 'Personal Care', 'France', 'Yes' ),
('Makeup', 'Personal Care', 'New York', 'No' ),
('Napkins', 'Paper Goods', 'South Carolina', 'No' ),
('Navel Orange', 'Produce', 'California', 'Yes' ),
('Onions', 'Produce', 'Mississippi', 'No' ),
('Orange Juice', 'Beverages', 'Missouri', 'Yes' ),
('Organic Peanut Butter', 'Other ', 'Alabama', 'Yes' ),
('Organic Toothpaste', 'Personal Care', 'Florida', 'Yes' ),
('Paper Cups', 'Paper Goods', 'South Carolina', 'No' ),
('Paper plates', 'Paper Goods', 'South Carolina', 'No' ),
('Peanut Butter', 'Other', 'Alabama', 'No' ),
('Pepper', 'Other', 'Alaska', 'No' ),
('Pepsi', 'Beverages', 'Kansas', 'No' ),
('Plastic Brush', 'Personal Care', 'Louisiana', 'No' ),
('Plastic Comb', 'Personal Care', 'Louisiana', 'No' ),
('Pomagranted Juice', 'Beverages', 'Florida', 'Yes' ),
('Potato', 'Produce', 'Alabama', 'No' ),
('Pura Life', 'Beverages', 'California', 'Yes' ),
('Roma Tomato', 'Produce', 'Mexico', 'Yes' ),
('Rosemary Tea', 'Beverages', 'Greece', 'Yes' ),
('Sea salt', 'Other', 'Alaska', 'Yes' ),
('Spinach', 'Produce', 'Florida', 'Yes' ),
('Spring Water', 'Beverages', 'California', 'Yes' ),
('Stationary', 'Paper Goods', 'North Carolina', 'No' ),
('Strawberries', 'Produce', 'Wisconson', 'Yes' ),
('Sunflower Butter', 'Other', 'Alabama', 'No' ),
('Swiss Cheese', 'Dairy', 'Italy', 'No' ),
('Toilet Paper', 'Personal Care', 'Kentucky', 'No' ),
('Toothbrush', 'Personal Care', 'Kansas', 'No' ),
('Toothpaste', 'Personal Care', 'Florida', 'No' ),
('Turkey Wings', 'Meat', 'Georgia', 'No' ),
('White Bread', 'Bakery', 'Georgia', 'No' ),
('Whole Milk', 'Dairy', 'Georgia', 'Yes' ),
('Yellow Curry Powder', 'Other', 'India', 'No' ),
('Yogurt', 'Dairy', 'Georgia', 'No' );

INSERT INTO chainItem (chainName, itemName, PLU_Number, order_limit, quantity, price)
VALUES
('Sprouts', '2% Milk', '10001', '10', '410', '6.38'),
('Publix', '4-1 Shampoo', '10006', '6', '60', '5.85'),
('Sprouts', 'Baby Food', '10005', '5', '170', '10.56'),
('Publix', 'Bagels', '10009', '5', '130', '5.67'),
('Walmart', 'Bandaids', '10002', '4', '300', '14.71'),
("Trader Joe's", 'Black Tea', '10003', '8', '130', '3.31'),
('Kroger', 'Brown bread', '10002', '10', '80', '6.99'),
('Moss Market', 'Campbells Soup', '10003', '8', '390', '13.31'),
('Kroger', 'Carrot', '10004', '10', '370', '8.19'),
('Publix', 'Carrot', '10001', '9', '110', '9.71'),
('Publix', 'Chicken Thighs', '10008', '10', '280', '2.81'),
('Walmart', 'Coca-cola', '10003', '6', '160', '14.85'),
('Kroger', 'Coffee', '10005', '8', '170', '4.3'),
("Trader Joe's", 'Earl Grey Tea', '10005', '8', '130', '20.53'),
('Moss Market', 'Fuji Apple', '10002', '2', '130', '1.99'),
('Moss Market', 'Gala Apple', '10001', '8', '450', '15.32'),
('Publix', 'Grape Juice', '10004', '7', '150', '11.89'),
('Whole Foods', 'Grassfed Beef', '10001', '1', '170', '13.88'),
("Trader Joe's", 'Green Tea', '10002', '4', '340', '7.25'),
('Query Mart', 'Ice Cream', '10002', '2', '310', '13.58'),
('Whole Foods', 'Lamb Chops', '10002', '4', '280', '20.14'),
('Query Mart', 'Lamb Chops', '10001', '2', '410', '7.72'),
('Kroger', 'Lavender Handsoap', '10008', '4', '140', '7.23'),
('Walmart', 'Napkins', '10006', '4', '410', '18.36'),
('Walmart', 'Paper Cups', '10005', '1', '50', '7.73'),
('Publix', 'Paper Cups', '10003', '10', '430', '20.18'),
('Walmart', 'Paper plates', '10007', '10', '60', '20.29'),
('Sprouts', 'Peanut Butter', '10004', '7', '410', '1.3'),
('Publix', 'Peanut Butter', '10002', '6', '190', '10.35'),
('Walmart', 'Pepsi', '10004', '10', '110', '3.21'),
('Publix', 'Pepsi', '10007', '6', '440', '11.19'),
('Kroger', 'Pepsi', '10007', '6', '340', '14.74'),
('Publix', 'Roma Tomato', '10005', '6', '140', '15.91'),
("Trader Joe's", 'Rosemary Tea', '10004', '10', '310', '10.55'),
('Walmart', 'Spinach', '10001', '9', '320', '11.44'),
('Kroger', 'Spinach', '10006', '8', '130', '2.35'),
("Trader Joe's", 'Sunflower Butter', '10001', '4', '160', '8.23'),
('Kroger', 'White Bread', '10001', '8', '220', '7.52'),
('Sprouts', 'Whole Milk', '10002', '8', '370', '15.26'),
('Sprouts', 'Yellow Curry Powder', '10003', '7', '230', '16.72'),
('Kroger', 'Yogurt', '10003', '6', '330', '3.27');

INSERT INTO groceryContains (ID, PLU_Number, chainName, itemName, quantity)
VALUES
('10001', '10003','Kroger', 'Yogurt', '4'),
('10001', '10001','Kroger', 'White Bread', '1'),
('10001', '10004','Kroger', 'Carrot', '10'),
('10001', '10005','Kroger', 'Coffee', '1'),
('10002', '10002','Whole Foods', 'Lamb Chops', '2'),
('10003', '10001','Sprouts', '2% Milk', '2'),
('10003', '10003','Sprouts', 'Yellow Curry Powder', '3'),
('10003', '10004','Sprouts', 'Peanut Butter', '1'),
('10004', '10002','Kroger', 'Brown Bread', '2'),
('10005', '10001','Moss Market', 'Gala Apple', '6'),
('10005', '10002','Moss Market', 'Fuji Apple', '2'),
('10006', '10002','Publix', 'Peanut Butter', '1'),
('10006', '10003','Publix', 'Paper Cups', '6'),
('10006', '10004','Publix', 'Grape Juice', '2'),
('10006', '10005','Publix', 'Roma Tomato', '6'),
('10006', '10006','Publix', '4-1 Shampoo', '1'),
('10006', '10001','Publix', 'Carrot', '5'),
('10007', '10006','Publix', '4-1 Shampoo', '1'),
('10008', '10002','Query Mart', 'Ice Cream', '1'),
('10009', '10002','Walmart', 'Bandaids', '4'),
('10010', '10004','Walmart', 'Pepsi', '1'),
('10010', '10003','Walmart', 'Coca-cola', '1'),
('10011', '10005','Sprouts', 'Baby Food', '3'),
('10012', '10001','Whole Foods', 'Grassfed Beef', '1'),
 ('10013', '10008','Publix', 'Chicken Thighs', '2'),
('10014', '10007','Walmart', 'Paper Plates', '8'),
('10015', '10002',"Trader Joe's", 'Green Tea', '2'),
('10015', '10003',"Trader Joe's", 'Black Tea', '2'),
('10015', '10004',"Trader Joe's", 'Rosemary Tea', '2'),
('10015', '10005',"Trader Joe's", 'Earl Grey Tea', '2');


