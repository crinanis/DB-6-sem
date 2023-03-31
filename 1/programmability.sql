use Insurance;
go
----------- ФУНКЦИИ

CREATE OR ALTER FUNCTION NumOfContracts(@realtor_nsp varchar(255))
RETURNS INT
AS
BEGIN
	DECLARE @number AS INT;
	SELECT @number = count(*) FROM icontract
		INNER JOIN realtors ON icontract.realtorid = realtors.realtor_id
		WHERE realtors.realtor_nsp = @realtor_nsp
	RETURN @number;
END;
go

SELECT dbo.NumOfContracts('Древотень Евгений Владимирович') AS 'Количество контрактов';
go

--Страховой взнос
CREATE OR ALTER FUNCTION CalculateInsurancePayment(@cost FLOAT, @years INT, @fareTitle NVARCHAR(255))
RETURNS FLOAT
AS
BEGIN
    DECLARE @interestRate FLOAT
    SELECT @interestRate = 
            CASE
                WHEN @years = 0.5 THEN int_rate_6
                WHEN @years = 1 THEN int_rate_12
                ELSE int_rate_36
            END
    FROM fares
    WHERE title = @fareTitle
    
    RETURN (@cost * @interestRate / 100)
END
go

SELECT title, dbo.CalculateInsurancePayment(100000, 1, title) AS 'Страховой взнос за 1 год' FROM fares
go


CREATE OR ALTER FUNCTION RealtorsWithInsSq(@square float)
RETURNS INT
AS
BEGIN
	DECLARE @number AS INT;
	SELECT @number= COUNT(DISTINCT re.realtor_id) FROM icontract i
		INNER JOIN realty r ON r.realty_id = i.realtyid
		INNER JOIN realtors re ON re.realtor_id = i.realtorid 
		WHERE r.area > @square
	RETURN @number;
END;
go

SELECT dbo.RealtorsWithInsSq(599) AS 'Количество риэлторов';
go


----------- ПРОЦЕДУРЫ

CREATE OR ALTER PROCEDURE FindContract(@contract_num int)
AS
BEGIN
	SELECT * FROM icontract WHERE contract_id = @contract_num;
END;
go

exec FindContract 30;
go


CREATE OR ALTER PROCEDURE DeleteFare(@title varchar(255))
AS
BEGIN
	SELECT * FROM fares WHERE fares.title = @title;
	DELETE FROM fares WHERE fares.title = @title;
END;
go

exec DeleteFare 'Эксклюзив';
go
insert into fares values ('Эксклюзив', 6.5, 13.0, 39.0);
go

CREATE OR ALTER PROCEDURE FindRealty(@begin_square float, @end_square float)
AS
BEGIN
	SELECT o.owner_surname, r.area, r.realty_address, re.agency
	FROM icontract i
		JOIN realtors re ON i.realtorid = re.realtor_id
		JOIN realty r ON i.realtyid = r.realty_id
		JOIN owners o ON r.ownerid = o.owner_id
			WHERE r.area BETWEEN @begin_square AND @end_square
END;
go

exec FindRealty 200, 599;
go

----------- ТРИГГЕРЫ

CREATE OR ALTER TRIGGER prevent_owner_deletion
ON owners
INSTEAD OF DELETE
AS
BEGIN
    IF EXISTS (SELECT * FROM realty WHERE ownerid IN (SELECT owner_id FROM deleted))
    BEGIN
        RAISERROR('Нельзя удалить владельца, у которого есть недвижимость.', 16, 1);
    END
    ELSE
    BEGIN
        DELETE FROM owners WHERE owner_id IN (SELECT owner_id FROM deleted);
    END
END

select*from owners;
delete from owners where owner_id = 9;
go


CREATE OR ALTER TRIGGER tr_update_realty_cost
ON realty
AFTER UPDATE
AS
BEGIN
    UPDATE realty
    SET realty.cost = realty.area * 3.56213
    FROM realty
    JOIN inserted ON realty.realty_id = inserted.realty_id
END;

update realty set area = 5000 where realty_id = 24;
go


CREATE OR ALTER TRIGGER trg_no_owner_passport_change
ON owners
FOR UPDATE
AS
IF UPDATE(owner_passport)
BEGIN
    RAISERROR ('Нельзя изменить номер паспорта.', 16, 1)
    ROLLBACK TRANSACTION
END;

update owners set owner_passport = '' where owner_id = 9;
go


----------- ВЬЮШКИ

CREATE OR ALTER VIEW contract_details AS
SELECT contract_id, area, realty_address, realtor_nsp
FROM icontract
INNER JOIN realty ON realty.realty_id = icontract.realtyid
INNER JOIN realtors ON icontract.realtorid = realtors.realtor_id;
go

SELECT * FROM contract_details;
go


CREATE OR ALTER VIEW realty_owners AS
SELECT r.realty_address, o.owner_surname, o.owner_name, o.owner_patronimyc
FROM realty r
INNER JOIN owners o ON r.ownerid = o.owner_id;
go

SELECT * FROM realty_owners;
go


CREATE OR ALTER VIEW fare_rates AS
SELECT title, int_rate_6[% ставка за полгода], int_rate_12[% ставка за год], int_rate_36[% ставка за три года]
FROM fares;
go

SELECT * FROM fare_rates;
go

----------- ИНДЕКСЫ
CREATE INDEX idx_owners_surname ON owners (owner_surname);
CREATE INDEX idx_realty_address ON realty (realty_address);
CREATE INDEX idx_icontract_fare_code ON icontract (fare_code);



