CREATE PROCEDURE [dbo].[SearchStore]
	@CityId int = NULL,
	@StoreName VARCHAR(1000) = NULL
AS
/*
	Description - SearchForStore
	INPUT PARAMETERS:
	@CityId - CityId could be  recieved on a base of SearchCity SP.  Fore better performaance Full city list should be cahed on App side.
	@StoreName - Store name. Mask supported
*/
SET NOCOUNT ON
BEGIN TRY
	SELECT 
		s.StoreId
		,s.CityId
		,c.CountryCode
		,co.CountryName
		,c.State
		,c.PostalCode
		,c.CityName
		,s.StoreName
		,s.UpdatedBy
		,s.UpdatedDate
	FROM	dbo.Store s
	INNER JOIN dbo.City c ON c.CityId = s.CityId
	INNER JOIN dbo.Country co ON co.CountryCode = c.CountryCode
	WHERE (@StoreName is NULL Or  s.StoreName like @StoreName)
	AND  (@CityId is NULL OR s.CityId = @CityId)

END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH
