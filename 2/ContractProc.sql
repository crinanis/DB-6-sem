CREATE OR ALTER PROCEDURE Usp_InsertUpdateDelete_Contract

@ContractID INT = 0,
@RealtyID INT = 0,
@RealtorID INT = 0,
@FareCode INT = 0,
@Term INT = 0,
@SignDate smalldatetime = NULL,
@Query INT,

@StartDate smalldatetime = NULL,
@EndDate smalldatetime = NULL

AS
BEGIN

IF (@Query = 1)
BEGIN
IF NOT EXISTS(SELECT 1 FROM realty WHERE realty_id = @RealtyID)
	BEGIN
	SELECT 'Realty does not exist'
	END
ELSE IF NOT EXISTS(SELECT 1 FROM realtors WHERE realtor_id = @RealtorID)
	BEGIN
	SELECT 'Realtor does not exist'
	END
ELSE IF NOT EXISTS(SELECT 1 FROM fares WHERE fare_id = @FareCode)
	BEGIN
	SELECT 'Fare does not exist'
	END
ELSE
	BEGIN
	INSERT INTO icontract(realtyid, realtorid, fare_code, term, sign_date)
	VALUES (@RealtyID, @RealtorID, @FareCode, @Term, @SignDate)
	IF (@@ROWCOUNT > 0)
		BEGIN
		SELECT 'Insert'
		END
	END
END

IF (@Query = 2)
BEGIN
IF NOT EXISTS(SELECT 1 FROM realty WHERE realty_id = @RealtyID)
	BEGIN
	SELECT 'Realty does not exist'
	END
ELSE IF NOT EXISTS(SELECT 1 FROM realtors WHERE realtor_id = @RealtorID)
	BEGIN
	SELECT 'Realtor does not exist'
	END
ELSE IF NOT EXISTS(SELECT 1 FROM fares WHERE fare_id = @FareCode)
	BEGIN
	SELECT 'Fare does not exist'
	END
ELSE
	BEGIN
	UPDATE icontract
	SET realtyid = @RealtyID,
		realtorid = @RealtorID,
		fare_code = @FareCode,
		term = @Term,
		sign_date = @SignDate
		WHERE icontract.contract_id = @ContractID
	SELECT 'Update'
	END
END

IF (@Query = 3)
	BEGIN
	DELETE FROM icontract
		WHERE icontract.contract_id = @ContractID
	SELECT 'Deleted'
	END

IF (@Query = 4)
	BEGIN
	SELECT * FROM icontract
	END

IF (@Query = 5)
	BEGIN
	SELECT * FROM icontract
	WHERE contract_id = @ContractID
	END

IF (@Query = 6)
	BEGIN
	SELECT * FROM icontract
    WHERE sign_date BETWEEN @StartDate AND @EndDate
	END

END