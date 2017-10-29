CREATE PROCEDURE [dbo].[DeleteProduct]
	@ProductId INT
AS
/*
	Description - Delete  Product
	INPUT PARAMETERS:
	@ProductId - ProductId to be deleted
*/
SET NOCOUNT ON
BEGIN TRY
	DELETE FROM dbo.Product
	WHERE ProductId = @ProductId

	IF @@ROWCOUNT = 0
		RAISERROR('Product with ProductId = [%i] does not exist and could not be deleted.', 16, 1, @ProductId)
END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH