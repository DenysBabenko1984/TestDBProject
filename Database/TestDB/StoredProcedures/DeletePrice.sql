CREATE PROCEDURE [dbo].[DeletePrice]
	@PriceId INT
AS
SET NOCOUNT ON
BEGIN TRY
	DELETE FROM dbo.Price
	WHERE PriceId = @PriceId

	IF @@ROWCOUNT = 0
		RAISERROR('Price with PriceId = [%i] does not exist and could not be deleted.', 16, 1, @PriceId)
END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH