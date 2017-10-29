CREATE PROCEDURE [dbo].[GetProduct]
	@ProductId INT
AS
/*
	Description - Return a Product details by ID
	INPUT PARAMETERS:
	@ProductId - ProductId to be returned
*/
SET NOCOUNT ON
BEGIN TRY
	SELECT 
		p.ProductId,
		p.ProductName,
		p.ProductTypeId,
		pt.ProductTypeCode,
		pt.ProductTypeDescription,
		p.UpdatedDate,
		p.UpdatedBy
	FROM	dbo.Product p
	INNER JOIN	dbo.ProductType pt on pt.ProductTypeId = p.ProductTypeId
	WHERE p.ProductId = @ProductId

END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH