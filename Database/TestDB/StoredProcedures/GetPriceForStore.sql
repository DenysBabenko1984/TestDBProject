CREATE PROCEDURE [dbo].[GetPriceForStore]
	@StoreId INT,
	@ProductId INT = NULL
AS
/*
	Description - Return prices for specific store
	INPUT PARAMETERS:
	@StoreId - MANDATORY storeId
	@ProductId - Optional,  Return All prices in store in case of NULL value
*/
BEGIN TRY

	IF NOT EXISTS (SELECT 1 FROM dbo.Store WHERE StoreId = @StoreId)
		RAISERROR('Incorrect @StoreId = [%i] was passed', 16, 1, @StoreId)

	SELECT 
		p.PriceId
		, p.ProductId
		, pt.ProductTypeCode
		, pr.ProductName
		, s.StoreId
		, s.StoreName
		, c.CityName
	FROM	dbo.Price p
	INNER JOIN dbo.Product pr ON pr.ProductId = p.ProductId
	INNER JOIN dbo.ProductType pt ON pt.ProductTypeId = pr.ProductTypeId
	INNER JOIN dbo.Store s ON s.StoreId = p.StoreId
	INNER JOIN dbo.City c ON c.CityId = s.CityId
	WHERE p.StoreId = @StoreId
	AND (@ProductId IS NULL OR p.ProductId = @ProductId)

END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH