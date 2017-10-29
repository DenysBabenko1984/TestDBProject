CREATE PROCEDURE [dbo].[SearchCity]
	@CountryCode CHAR(2) = NULL,
	@State CHAR(2) = NULL,
	@CountryName VARCHAR(255) = NULL,
	@CityName VARCHAR(255) = NULL
AS
/*
	Description - Search City
	INPUT PARAMETERS:
	@CountryCode - ISO 3166 Code
	@State - State or District Code
	@CountryName - Country name. Mask search supported
	@CityName - City name.  Mask search supported
*/
SET NOCOUNT ON
BEGIN TRY
	SELECT 
		c.CityId
		,c.CityName
		,co.CountryCode
		,co.CountryName
		,c.PostalCode
		,c.State
	FROM	dbo.City c
	INNER JOIN	dbo.Country co on co.CountryCode = c.CountryCode
	WHERE (@CountryCode IS NULL OR @CountryCode = co.CountryCode)
	AND (@State IS NULL OR @State = c.State)
	AND (@CountryName is NULL or co.CountryName LIKE @State)
	AND (@CityName IS NULL OR c.CityName LIKE @CityName)
END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH
