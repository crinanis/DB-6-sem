use Insurance;

CREATE TABLE Report(
	id INT PRIMARY KEY IDENTITY,
	xml_column XML
);
go
TRUNCATE TABLE Report;
go

CREATE OR ALTER PROCEDURE GenerateXML
    @result XML OUTPUT
AS
BEGIN
    SELECT @result = (
        SELECT DISTINCT
            o.owner_id,
            o.owner_surname,
            GETDATE() AS timestamp
        FROM
            owners o
        FOR XML PATH('row'), ROOT('rows')
    );
END;
go

CREATE OR ALTER PROCEDURE InsertXMLIntoReport 
	@value XML
AS
BEGIN
  INSERT INTO Report(xml_column) VALUES (@value);
END;
go

DECLARE @xml XML;
exec GenerateXml @xml output;
SELECT @xml;
exec InsertXmlIntoReport @xml;
SELECT * FROM Report;
go

CREATE PRIMARY XML INDEX index_xml_column ON Report(xml_column);
go

CREATE OR ALTER PROCEDURE ExtractElementFromXML @id_owner INT
AS
BEGIN
	DECLARE @xml XML, 
		@ownerid INT, @owner_sur NVARCHAR(255), @area DECIMAL(18,2), @realty_address NVARCHAR(255), @cost DECIMAL(18,2), @agency NVARCHAR(255);

	SELECT @xml = (SELECT xml_column.query('rows/row[owner_id= sql:variable("@id_owner")]') FROM Report);

	SET @ownerid					= @xml.value('row[1]/owner_id[1]', 'int');
	SET @owner_sur					= @xml.value('row[1]/owner_surname[1]', 'nvarchar(255)');
	SET @area						= @xml.value('row[1]/area[1]', 'decimal(18,2)');
	SET @realty_address				= @xml.value('row[1]/realty_address[1]', 'nvarchar(255)');
	SET @cost						= @xml.value('row[1]/cost[1]', 'decimal(18,2)');
	SET @agency						= @xml.value('row[1]/agency[1]', 'nvarchar(255)');

	SELECT @ownerid AS OwnerId, @owner_sur AS owner_surname, 
	@area AS realty_area, @realty_address AS realty_address, 
	@cost AS cost, @agency AS agency;
END;
go

SELECT*FROM realty

SELECT * FROM Report;
exec ExtractElementFromXml 9;

go
CREATE OR ALTER PROCEDURE ExtractElementsFromXML
AS
BEGIN
	DECLARE @xml XML;

    SELECT @xml = xml_column FROM Report;

    SELECT xml.value('(owner_surname)[1]', 'nvarchar(255)') AS owner_surname, 
		   xml.value('(owner_id)[1]', 'int') AS owner_id
    FROM @xml.nodes('rows/row') AS t(xml);
END;
go

exec ExtractElementsFromXml;
