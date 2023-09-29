EXEC sp_srvrolepermission 'sysadmin';  -- привилегии встроенных ролей на уровне сервера

USE Insurance;
SELECT * FROM sys.database_permissions
WHERE grantee_principal_id = DATABASE_PRINCIPAL_ID('public'); -- привилегии встроенных ролей бд
GO

-- заимствование прав
CREATE LOGIN User1 WITH PASSWORD = '1234';
CREATE USER User1 FOR LOGIN User1;
grant all on owners to user2;
-- Подключение к базе данных как User1
USE Insurance;
GO
SETUSER 'User1';
EXEC GetOwners;
GO
-- Возвращение к своей оригинальной учетной записи
SETUSER;
GO
USE Insurance;
GO

-- АУДИТ СЕРВЕРА
CREATE SERVER AUDIT MyServerAudit -- объект аудита, только на мастере
TO FILE (
    FILEPATH = 'C:\db\' -- Замените на путь к папке, где будут храниться аудит-журналы
);
GO

CREATE SERVER AUDIT SPECIFICATION MyServerAuditSpec
FOR SERVER AUDIT MyServerAudit
ADD (FAILED_LOGIN_GROUP),
ADD (SUCCESSFUL_LOGIN_GROUP);
GO

ALTER SERVER AUDIT SPECIFICATION MyServerAuditSpec -- включаем
WITH (STATE = ON);

ALTER SERVER AUDIT MyServerAudit -- включает аудит и начинает запись аудит-событий в файлы журнала
WITH (STATE = ON);
GO

SELECT * FROM sys.fn_get_audit_file('C:\db\MyServerAudit*', NULL, NULL);
GO

-- АУДИТ БД
use Insurance;

drop database audit SPECIFICATION MyDatabaseAuditSpec;
CREATE DATABASE AUDIT SPECIFICATION MyDatabaseAuditSpec
FOR SERVER AUDIT MyServerAudit
ADD (SELECT, INSERT, UPDATE, DELETE ON dbo.owners BY public),
ADD (EXECUTE ON dbo.GetOwners BY public);
GO

ALTER DATABASE AUDIT SPECIFICATION MyDatabaseAuditSpec
WITH (STATE = ON);

SETUSER 'user2';
select * from dbo.owners;

-- Остановка аудита в базе данных и на сервере
ALTER DATABASE AUDIT SPECIFICATION MyDatabaseAuditSpec
WITH (STATE = OFF);
GO

USE master;
GO

ALTER SERVER AUDIT SPECIFICATION MyServerAuditSpec
WITH (STATE = OFF);
GO

-- ШИФРОВАНИК
-- создать ассиметричный ключ шифрования
create asymmetric key SampleAKey with algorithm = rsa_2048 encryption by password = 'Pas45!!~~';

-- зашифровать и расшифровать данные при пом ключа
declare @plaintext nvarchar(21);
declare @ciphertext nvarchar (256);

set @plaintext = 'this is a sample text';
print @plaintext;

set @ciphertext = EncryptByAsymKey(AsymKey_ID('SampleAKey'), @plaintext);
print @ciphertext;

set @plaintext = DecryptByAsymKey(AsymKey_ID('SampleAKey'), @ciphertext, N'Pas45!!~~');
print @plaintext;

-- создать сертификат
create certificate SampleCert encryption by password = N'pa$$W0RD'
	with subject = N'Sample Certificate',
	expiry_date = N'31/10/2033';

-- зашифровать и расшифровать данные при помощи сертификата
declare @plain_text nvarchar(58);
set @plain_text = 'this is certificate encryption text';
print @plain_text;

declare @cipher_text nvarchar(256);
set @cipher_text = EncryptByCert(Cert_ID('SampleCert'), @plain_text);
print @cipher_text;

set @plain_text = CAST(DecryptByCert(Cert_ID('SampleCert'), @cipher_text, N'pa$$W0RD') as nvarchar(58));
print @plain_text;
	

-- создать симметричный ключ шифрования
create symmetric key SKey with algorithm = AES_256 encryption by password = N'PA$$W0RD';

open symmetric key SKey decryption by password = N'PA$$W0RD';

create symmetric key SData with algorithm = AES_256 encryption by symmetric key SKey;

open symmetric key SData decryption by symmetric key SKey;


-- зашифровать и расшифровать данные при помощи ключа
declare @plain_tex nvarchar(512);
set @plain_tex = 'open the symmetric key with which to encrypt the data';
print @plain_tex;

declare @cipher_tex nvarchar(1024);
set @cipher_tex = EncryptByKey(Key_GUID('SData'), @plain_tex);
print @cipher_tex;

set @plain_tex = CAST(DecryptByKey(@cipher_tex) as nvarchar(512));
print @plain_tex;

close symmetric key SData;
close symmetric key SKey;

-- продемонстрировать прозрачное шифрование БД
use master;
create master key encryption by password = 'p@$$wOrd';
	
create certificate LabCert
		with subject = 'certificate to encrypt Lab10 DB ', 
		expiry_date = '31/10/2033';

	
use Insurance;
create database encryption key
with algorithm = AES_256
encryption by server certificate LabCert;
go

alter database Insurance
set encryption on;
go

--удалить шифрование из БД
alter database Insurance 
set encryption off;
go

-- продемонстрировать хеширование (MD2, MD4, MD5, SHA1, SHA2)
select HashBytes('SHA1', 'open the symmetric key with which to encrypt the data');
select HashBytes('MD4', 'open the symmetric key with which to encrypt the data');


-- продемонстрировать применение ЭЦП при помощи сертификата
--подписывает текст сертификатом и возвращает подпись
select * from sys. certificates;
select SIGNBYCERT(256, N'univer', N'pa$$W0RD') as ЭЦП;	--сертификат, pa$$W0RD пароль связанный с закрытым ключом для сертификата
--0 - изменены, 1 - не изменены
select VERIFYSIGNEDBYCERT(256, 'univer', 0x0100070204000000A4B18733863C7FE66F1873CAF81ABE6FA2615A4DB4646B1D3631BA3594FD01D5004D6E6C84937DC7810BD6F9870676BC11605AA20904B8B32EA03C27545AECCC36E5FF7F594C180BC9098D69B46C0D42CB09636F5D20B43275F676BE0AAECB8CA76D798A1403B47462ED307FC0F6CF335D14312DC58029078EE2AE0F5E070AC9050A6BADDF1E92872D959D2C1EA4F125B1ED74B9F902161CAF2FD3F33351C1B93C546B41FD1D6218BDD137A524E3416F116957B5B6C3D9B15BA1C1CA314104701513695A6116B3FFC85CD804E8AD82BA4A70F4B88782AE46A81369D39CFE64067B2C011FC98612A7840FFB5EB24631058EFCB2EB8AB408A5F251252A7E4F3E0DF0126B31C0B2E58BB7022D61072CDA507D55EFAB0626B0875486BF82E50514C8A4FE60948E3F1E0CB3F5B6F13010DA6347042453CECC76C7690413F26DD2D442B7245D0C28131C8B33AF80EF1146FE6F70A0CA74A141B8C9D235ECAF1A64E5724A0B52FE35D00D76C951C157E0407119EE357A335765E1889355A54628DFE6AA);
	
select * from sys. asymmetric_keys;
select SIGNBYASymKey(256, N'univer', N'Pas45!!~~') as ЭЦП;	--ас.ключ
select VERIFYSIGNEDBYASYMKEY(256, N'univer', 0x0100070204000000431CCEAABC3D940DA90716788427B202175D6D0C8C391A8C5B062A4B802D0E3FE67E48AF5C76178511DDEF6B969A14AFBF8BE433851F544A47EECC5FD665345F8ED43957C12930F47D9BEF9F19FAC48D6EA059563394BE4E81E561BFBDD1ACA2BEFD9010DD9ACA640C4E106EFDD9A85417668D7EB401C787407CE5974C4C0C971A6D0630ECFC37234686FC062B3420FEFE4F7E945D138EEB39EFDB4270C2564F3AD5034A17F24C8CFFCB47AC753CFDE8172B1A83075530404188509263F0DB2C4F3863D7A738F8F43A4599E4F26EDE953388EC155B90A57CCFE156079038616DECF095B9279615CFBAFF53F68173E652BA6052A609D317FB650A63B968BC936A);

-- сделать резервную копию необходимых ключей и сертификатов.
backup certificate SampleCert
to file = N'c:\db\BackupSampleCert.cer'
	with private key(
	file = N'c:\db\BackupSampleCert.pvk',
	encryption by password = N'pa$$W0RD',
	decryption by password = N'pa$$W0RD');

use master;
BACKUP MASTER KEY TO FILE = 'c:\db\BackupMasterKey.key' ENCRYPTION BY PASSWORD = 'p@$$wOrd';


