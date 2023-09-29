use Insurance;
go

--clr on
EXEC sp_configure 'clr_enabled', 1;
RECONFIGURE;

EXEC sp_configure 'show advanced options', 1;
RECONFIGURE;

EXEC sp_configure 'clr strict security', 0;
RECONFIGURE;
---
GO

ALTER DATABASE Insurance SET TRUSTWORTHY ON 

CREATE ASSEMBLY lab3 from 'd:\1POIT\3\DB\labs\3\lab3\lab3\bin\Debug\lab3.dll'
	WITH PERMISSION_SET = UNSAFE;
GO
DROP ASSEMBLY lab3


--update
ALTER ASSEMBLY lab3
	FROM 'd:\1POIT\3\DB\labs\3\lab3\lab3\bin\Debug\lab3.dll'
	WITH PERMISSION_SET = UNSAFE;
GO

--procedure

CREATE OR ALTER PROCEDURE MoveFile
    @pathFrom nvarchar(256),
    @pathTo nvarchar(256)
AS 
EXTERNAL NAME lab3.StoredProcedures.MoveProc;
GO
DROP PROCEDURE MoveFile;

EXEC MoveFile 
    @pathFrom = 'd:\1POIT\3\DB\labs\3\lab3\a\test.txt', 
    @pathTo = 'd:\1POIT\3\DB\labs\3\lab3\b\test.txt';
GO


--type

CREATE TYPE Rate
	EXTERNAL NAME lab3.CurrencyRateType;
GO
DROP TYPE Rate;


DECLARE @rate Rate
	SET @rate = '666-2.2-2.3-04.04.2023'
	SELECT @rate.ToString()[Полученная строка];
GO
