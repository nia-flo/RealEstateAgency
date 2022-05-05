CREATE DATABASE RealEstateAgency;

USE RealEstateAgency;

CREATE TABLE Person(
	EGN CHAR(10) CHECK(EGN NOT LIKE '%[^0-9]%') PRIMARY KEY,
	address VARCHAR(50) NOT NULL,
	name VARCHAR(50) NOT NULL,
	email VARCHAR(50) NOT NULL CHECK(email LIKE '%@%.%'),
	phone CHAR(10) NOT NULL CHECK(phone NOT LIKE '%[^0-9]%'),
	gender CHAR(1) CHECK(gender IN ('m', 'f'))
);

CREATE TABLE Employee(
	EGN CHAR(10) PRIMARY KEY,
	salary DECIMAL(7, 2) NOT NULL,
	position VARCHAR(20) CHECK(position IN ('agent', 'manager', 'intern', 'jurist', 'secretary')) NOT NULL,
	FOREIGN KEY(EGN) REFERENCES Person(EGN)
);

CREATE TABLE Estate(
	id INT IDENTITY(1,1) PRIMARY KEY,
	city VARCHAR(20) NOT NULL,
	address VARCHAR(50) NOT NULL,
	price DECIMAL(10, 2) NOT NULL CHECK(price > 0),
	area DECIMAL(7, 2) NOT NULL CHECK(area > 0),
	roomsCount INT NOT NULL CHECK(roomsCount > 0),
	realEstateAgent CHAR(10),
	additionalInfo VARCHAR(200),
	FOREIGN KEY(realEstateAgent) REFERENCES Employee(EGN)
);

CREATE TABLE Estate_Owner(
	estate INT NOT NULL,
	owner CHAR(10) NOT NULL,
	PRIMARY KEY(estate, owner),
	FOREIGN KEY(estate) REFERENCES Estate(id),
	FOREIGN KEY(owner) REFERENCES Person(EGN)
);

CREATE TABLE Deal(
	id INT IDENTITY(1,1) PRIMARY KEY,
	type CHAR(4) CHECK(type IN ('rent', 'sale')) NOT NULL,
	notary CHAR(10) NOT NULL,
	estate INT NOT NULL,
	date DATETIME NOT NULL DEFAULT(GETDATE()),
	price DECIMAL(10, 2) NOT NULL CHECK(price > 0),
	conditions VARCHAR(200),
	realEstateAgent CHAR(10) NOT NULL,
	commissionPersentage DECIMAL(4, 2) NOT NULL CHECK(commissionPersentage > 0),
	FOREIGN KEY(notary) REFERENCES Person(EGN),
	FOREIGN KEY(estate) REFERENCES Estate(id),
	FOREIGN KEY(realEstateAgent) REFERENCES Employee(EGN)
);

CREATE TABLE Deal_Seller(
	deal INT,
	seller CHAR(10),
	PRIMARY KEY(deal, seller),
	FOREIGN KEY(deal) REFERENCES Deal(id),
	FOREIGN KEY(seller) REFERENCES Person(EGN)
);

CREATE TABLE Deal_BuyerPerson(
	deal INT,
	buyer CHAR(10),
	PRIMARY KEY(deal, buyer),
	FOREIGN KEY(deal) REFERENCES Deal(id),
	FOREIGN KEY(buyer) REFERENCES Person(EGN)
);

CREATE TABLE Company(
	bulstat VARCHAR(9) CHECK(bulstat NOT LIKE '%[^0-9]%') PRIMARY KEY,
	name VARCHAR(20) NOT NULL,
	address VARCHAR(50) NOT NULL,
	MOL VARCHAR(50) NOT NULL
);

CREATE TABLE Deal_BuyerCompany(
	deal INT,
	buyer VARCHAR(9),
	PRIMARY KEY(deal, buyer),
	FOREIGN KEY(deal) REFERENCES Deal(id),
	FOREIGN KEY(buyer) REFERENCES Company(bulstat)
);