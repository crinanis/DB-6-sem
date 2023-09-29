CREATE USER insurance IDENTIFIED BY "12345";
grant all privileges to insurance;
DROP TABLE icontract CASCADE CONSTRAINTS;

select * from realty;
select * from owners;
select * from realtors;
select * from fares;
select * from icontract;


CREATE TABLE owners (
owner_id NUMBER(10) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
owner_name NVARCHAR2(255) NOT NULL,
owner_surname NVARCHAR2(255) NOT NULL,
owner_patronimyc NVARCHAR2(255) NOT NULL,
owner_address NVARCHAR2(255) NOT NULL,
owner_number NVARCHAR2(255) NOT NULL,
owner_passport NVARCHAR2(255) NOT NULL
);

CREATE TABLE realty (
realty_id NUMBER(10) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
realty_type NVARCHAR2(255) NOT NULL,
area FLOAT NOT NULL,
realty_address NVARCHAR2(255) NOT NULL,
cost FLOAT NOT NULL,
ownerid INT REFERENCES owners(owner_id) ON DELETE CASCADE
);

CREATE TABLE realtors (
realtor_parent_id NUMBER(10),
realtor_id NUMBER(10) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
realtor_nsp NVARCHAR2(255) NOT NULL,
realtor_address NVARCHAR2(255) NOT NULL,
realtor_number NVARCHAR2(255) NOT NULL,
agency NVARCHAR2(255) NOT NULL
);

CREATE TABLE fares (
fare_id NUMBER(10) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
title NVARCHAR2(255) NOT NULL,
int_rate_6 FLOAT,
int_rate_12 FLOAT,
int_rate_36 FLOAT
);

CREATE TABLE icontract (
contract_id NUMBER(10) GENERATED ALWAYS AS IDENTITY START WITH 1 INCREMENT BY 1 PRIMARY KEY,
realtyid INT REFERENCES realty(realty_id) ON DELETE CASCADE,
realtorid INT REFERENCES realtors(realtor_id) ON DELETE CASCADE,
fare_code INT REFERENCES fares(fare_id) ON DELETE CASCADE,
term INT,
sign_date DATE
);

-- INSERT

INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Евгения','Николаева','Владимиовна','Бобруйск, Советская 34','+375294878736','BO37624');
INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Яна','Колядко','Сергеевна','Копыль, Денисовская 1','+375334567687','КO87463');
INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Ефрем','Егоров','Рудольфович',' г. Воскресенск, шоссе 1905 года, 22','+375299786754','КO87463');
INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Игорь','Журавлёв','Рубенович','г. Клин, въезд Ломоносова, 29','+37529','КO87463');
INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Аким','Прохоров','Константинович','г. Подольск, наб. Балканская, 75','+37533','КO87463');
INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Тала','Имильянова','Борисовна','г. Москва, ул. Сталина, 50','+37541','КO87463');
INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Екатерина','Артёмьева','Германновна','г. Истра, ул. Чехова, 58','+37529','КO87463');
INSERT INTO owners (owner_name, owner_surname, owner_patronimyc, owner_address, owner_number, owner_passport)
VALUES ('Силика','Громова','Романовна','г. Серпухов, въезд Гоголя, 82','+37529','КO87463');


INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Городское жильё', 3000, 'Минск, Белорусская 21', 25000, 1);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Городское жильё', 10000, 'Минск, Петра Глебки 90', 10000, 1);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Офисные помещения', 10000, 'Бобруйск, Минская 19', 5560, 5);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Торговые помещения', 10000, 'Бобруйск, Ульяновская 100', 4599, 8);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Свободный земельный участок', 10000, 'Бобруйск, Урицкого 21', 1099, 7);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Производственные помещения', 10000, 'Бобруйск, Советская 19', 25900, 4);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Элитное жильё', 10000, 'Бобруйск, Ванцети 41', 50000, 1);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Складские помещения', 10000, 'Осиповичи, Западная 31', 350, 3);
INSERT INTO realty (realty_type, area, realty_address, cost, ownerid) 
VALUES ('Загородное жильё', 1000, 'Бобруйск, Гагарина 41/11', 100000, 2);


insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Буданова Ксения Андреевна', 'Николы Теслы, 24-96', '+375333303546', 'ДубаиПроперти');
insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Древотень Евгений Владимирович', 'Проспект Мира 1, 54', '+375293348576', 'Авангард');
insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Сидорова Ольга Петровна', 'ул. Пушкина 10', '+79123456789', 'Краснодар Недвижимость');
insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Иванов Александр Сергеевич', 'ул. Ленина 20', '+79112223344', 'Городской Центр Недвижимости');
insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Петров Дмитрий Игоревич', 'ул. Гагарина 30', '+79090909090', 'Агентство Недвижимости "Дом"');
insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Ковалева Елена Николаевна', 'ул. Маяковского 40', '+79167778899', 'Недвижимость Плюс');
insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Соколов Иван Александрович', 'пр. Победы 50', '+79112223344', 'Недвижимость Элит');
insert into realtors (realtor_nsp, realtor_address, realtor_number, agency)
values ('Новиков Алексей Сергеевич', 'ул. Кирова 60', '+79050123456', 'Квартиры Екатеринбурга');


INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Стандартный', 4.5, 9.0, 27.0);
INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Премиум', 5.5, 11.0, 33.0);
INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Эксклюзив', 6.5, 13.0, 39.0);
INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Эконом', 3.5, 7.0, 21.0);
INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Профессиональный', 7.5, 15.0, 45.0);
INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Базовый', 5.0, 10.0, 30.0);
INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Комфорт', 4.0, 8.0, 24.0);
INSERT INTO fares (title, int_rate_6, int_rate_12, int_rate_36)
VALUES ('Премиум-плюс', 8.5, 17.0, 51.0);


INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (3, 3, 8, 3, TO_DATE('10.11.2012', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (7, 4, 2, 20, TO_DATE('23.01.2017', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (8, 5, 8, 15, TO_DATE('09.05.2005', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (6, 6, 5, 12, TO_DATE('01.12.2011', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (1, 1, 2, 10, TO_DATE('17.03.2023', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (5, 1, 1, 1, TO_DATE('30.07.2021', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (4, 1, 6, 2, TO_DATE('29.09.2020', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (8, 6, 5, 6, TO_DATE('03.08.2022', 'DD.MM.YYYY'));
INSERT INTO icontract (realtyid, realtorid, fare_code, term, sign_date) VALUES (3, 3, 5, 8, TO_DATE('12.10.2022', 'DD.MM.YYYY'));