CREATE PROCEDURE [dbo].[DeleteProductType]
	@ProductTypeId int
AS
/*
	Description - Delete  ProductType
	INPUT PARAMETERS:
	@ProductTypeId - ProductTypeId to be deleted
*/
SET NOCOUNT ON
BEGIN TRY
	DELETE FROM dbo.ProductType
	WHERE ProductTypeId = @ProductTypeId
END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH