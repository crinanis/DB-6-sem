create database Insurance;
drop database Insurance;
use Insurance;

CREATE TABLE owners (
	owner_id INT IDENTITY (1, 1) PRIMARY KEY,
	owner_name NVARCHAR (255) NOT NULL,
	owner_surname NVARCHAR (255) NOT NULL,
	owner_patronimyc NVARCHAR (255) NOT NULL,
	owner_address NVARCHAR (255) NOT NULL,
	owner_number NVARCHAR (255) NOT NULL,
	owner_passport NVARCHAR (255) NOT NULL,
);

CREATE TABLE realty (
	realty_id INT IDENTITY (1, 1) PRIMARY KEY,
	realty_type NVARCHAR (255) NOT NULL,
	area FLOAT NOT NULL,
	realty_address NVARCHAR (255) NOT NULL,
	cost FLOAT NOT NULL,
	ownerid INT FOREIGN KEY REFERENCES owners(owner_id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE realtors (
	realtor_id INT IDENTITY (1, 1) PRIMARY KEY,
	realtor_nsp NVARCHAR (255) NOT NULL,
	realtor_address NVARCHAR (255) NOT NULL,
	realtor_number NVARCHAR (255) NOT NULL,
	agency NVARCHAR (255) NOT NULL,
);

CREATE TABLE fares(
	fare_id INT IDENTITY (1, 1) PRIMARY KEY,
	title NVARCHAR (255) NOT NULL,
	int_rate_6 REAL,
	int_rate_12 REAL,
	int_rate_36 REAL
);

CREATE TABLE icontract (
	contract_id INT IDENTITY (1, 1) PRIMARY KEY,
	realtyid INT FOREIGN KEY REFERENCES realty(realty_id) ON DELETE CASCADE ON UPDATE CASCADE,
	realtorid INT FOREIGN KEY REFERENCES realtors(realtor_id) ON DELETE CASCADE ON UPDATE CASCADE,
	fare_code INT FOREIGN KEY REFERENCES fares(fare_id) ON DELETE CASCADE ON UPDATE CASCADE,
	term INT,
	sign_date Date
);

