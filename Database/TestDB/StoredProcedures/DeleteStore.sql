CREATE PROCEDURE [dbo].[DeleteStore]
	@StoreId INT
AS
/*
	Description - Delete  Store
	INPUT PARAMETERS:
	@StoreId - Store to be deleted
*/
SET NOCOUNT ON
BEGIN TRY
	DELETE FROM dbo.Store
	WHERE StoreId = @StoreId

	IF @@ROWCOUNT = 0
		RAISERROR('Product with StoreId = [%i] does not exist and could not be deleted.', 16, 1, @StoreId)
END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH