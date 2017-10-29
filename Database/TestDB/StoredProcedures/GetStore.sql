CREATE PROCEDURE [dbo].[GetStore]
	@StoreId INT
AS
/*
	Description - Return a Store details by ID
	INPUT PARAMETERS:
	@StoreId - Store to be returned
*/
SET NOCOUNT ON
BEGIN TRY
	SELECT 
		s.StoreId
		,s.CityId
		,c.CountryCode
		,co.CountryName
		,c.State
		,c.CityName
		,s.StoreName
		,s.UpdatedBy
		,s.UpdatedDate
	FROM	dbo.Store s
	INNER JOIN	dbo.City c on c.CityId = s.CityId
	INNER JOIN dbo.Country co on co.CountryCode = c.CountryCode
	WHERE s.StoreId = @StoreId

END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH