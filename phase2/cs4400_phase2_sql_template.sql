
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

-- CREATE TABLE STATEMENTS BELOW

create table groceryUser (
	userName char(100) not null,
    passcode char(100) not null,
    fName char(100) not null,
    lName char(100) not null,
    primary key (userName)
) engine = innodb;

create table customer (
	userName char(100) not null,
    ccNumber int(100),
    CVV int(100),
    ExpDate date not null,
    constraint fk1 foreign key (userName) references groceryUser(userName),
    primary key (userName)
) engine = innodb;

create table employee (
	userName char(100) not null,
   	constraint fk2 foreign key (userName) references groceryUser(userName),
    	primary key (userName)
) engine = innodb;

create table drone (
    ‘ID’ char(100) not null,
    ‘radius’ int(100) not null,
    ‘droneStatus’ char(100) not null,
    ‘Worked_on_by’ char(100) not null,
    constraint fk3 foreign key (Worked_on_by) references droneTechnician(userName),
    primary key (ID)
) engine = innodb;

create table manager (
	userName char(100),
	manages varchar(50),
	constraint fk4 foreign key (userName) references employee(userName),
    constraint fk5 foreign key (manages) references groceryChain(manages),
    PRIMARY KEY (userName)
) engine = innodb;

create table groceryAdmin (
	userName char(100),
	PRIMARY KEY (userName),
	constraint fk6 FOREIGN KEY (userName) REFERENCES groceryAdmin(userName)
) engine = innodb;

create table groceryOrder (
	ID INT AUTO_INCREMENT, 
	orderStatus ENUM('drone assigned', 'delivered', 'in transit'),
	orderDate DATE DEFAULT (DATE_FORMAT(NOW(), '%d-%m-%Y')),
	made_by char(100),
	deliver char(100),
	constraint fk7 foreign key (made_by) REFERENCES customer(userName),
	constraint fk8 FOREIGN KEY (deliver) REFERENCES drone(ID),
	PRIMARY KEY (ID)
) engine = innodb;

create table store (
	chainName char(100),
	storeName char(100),
	zip char(5),
	state char(2),
	city varchar(100),
	street varchar(255),
    constraint fk9 foreign key (chainName) REFERENCES groceryChain(userName),
	primary key (storeName)
) engine = innodb;

create table technician (
	userName char(100),
	works_at char(100),
	PRIMARY KEY (userName),
	constraint fk10 FOREIGN KEY (userName) REFERENCES employee(userName),
	constraint fk11 FOREIGN KEY (works_at) REFERENCES store(chainName)
) engine = innodb;

create table groceryChain (
	chainName char(100),
	PRIMARY KEY (chainName)
) engine = innodb;

create table item (
	itemName varchar(100), 
	orderType ENUM( Diary, 'Bakery', ‘Meat’, ‘Produce’, ‘Personal Care’, ‘Paper Goods’,‘Beverages’, ‘Other’) NOT NULL,
	origin char(100) NOT NULL,
	organic ENUM(‘Yes’, ‘No’) NOT NULL,
	PRIMARY KEY (itemName)
) engine = innodb;

create table chainItem (
	chainName char(100),
	itemName char(100),
	PLU_Number INT(5) ZEROFILL NOT NULL AUTO_INCREMENT,
	order_limit INT,
	quantity INT,
	price DECIMAL (5,2),
	PRIMARY KEY (chainName, itemName, PLU_Number’),
	constraint fk12 FOREIGN KEY (chainName) REFERENCES groceryChain(chainItem),
	constraint fk13 FOREIGN KEY (itemName) REFERENCES item(itemName)
) engine = innodb;

create table groceryContains (
	ID INT,
	PLU_Number INT,
	chainName char(100),
	quantity INT,
	PRIMARY KEY (ID),
	constraint fk14 FOREIGN KEY (id) REFERENCES groceryOrder(ID), 
	constraint fk15 FOREIGN KEY (PLU_Number, chainName) REFERENCES chainItem(PLU_Number, chainName)
) engine = innodb;


-- INSERT STATEMENTS BELOW
