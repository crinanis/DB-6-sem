CREATE OR ALTER PROCEDURE Usp_InsertUpdateDelete_Realty

@RealtyId INT = 0
,@RealtyType NVARCHAR (255) = NULL
,@RealtyAddress NVARCHAR (255) = NULL
,@Area FLOAT = 0
,@Cost FLOAT = NULL
,@OwnerId INT = NULL
,@Query INT
AS
BEGIN

IF (@Query = 1)
BEGIN
IF EXISTS(SELECT 1 FROM owners WHERE owner_id = @OwnerId)
	BEGIN
	INSERT INTO realty(realty_type, realty_address, area, cost, ownerid)
	VALUES (@RealtyType, @RealtyAddress, @Area, @Cost, @OwnerId)
	IF (@@ROWCOUNT > 0)
		BEGIN
		SELECT 'Insert'
		END
	END
ELSE
	BEGIN
	SELECT 'Owner does not exist'
	END
END

IF (@Query = 2)
BEGIN
IF EXISTS(SELECT 1 FROM owners WHERE owner_id = @OwnerId)
	BEGIN
	UPDATE realty
	SET realty_type = @RealtyType,
		realty_address = @RealtyAddress,
		area = @Area,
		cost = @Cost,
		ownerid = @OwnerId
		WHERE realty.realty_id = @RealtyId
	SELECT 'Update'
	END
ELSE 
	BEGIN
	SELECT 'Owner does not exist'
	END
END

IF (@Query = 3)
BEGIN
DELETE FROM realty
	WHERE realty.realty_id = @RealtyId
SELECT 'Deleted'
END

IF (@Query = 4)
BEGIN
SELECT * FROM realty
END

IF (@Query = 5)
BEGIN
SELECT * FROM realty
WHERE realty.realty_id = @RealtyId
END

END