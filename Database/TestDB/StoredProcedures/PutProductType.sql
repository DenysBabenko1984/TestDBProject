CREATE PROCEDURE [dbo].[PutProductType]
	@ProductTypeId INT = NULL OUTPUT,
	@ProductTypeCode VARCHAR(30),
	@ProductTypeDescription VARCHAR(1000)
AS
/*
	Description - Delete  ProductType
	INPUT PARAMETERS:
	@ProductTypeId - NULL in case of new row insertion.
	@ProductTypeCode
	@ProductTypeDescription
*/
SET NOCOUNT ON
BEGIN TRY

	;MERGE dbo.ProductType as T
	USING (VALUES
				(@ProductTypeId, @ProductTypeCode, @ProductTypeDescription)
			) as S(ProductTypeId, ProductTypeCode, ProductTypeDescription)
	ON T.ProductTypeId = S.ProductTypeId
	WHEN NOT MATCHED THEN
		INSERT (ProductTypeCode, ProductTypeDescription)
		VALUES (ProductTypeCode, ProductTypeDescription)
	WHEN MATCHED THEN
		UPDATE SET
			T.ProductTypeCode = S.ProductTypeCode
			, T.ProductTypeDescription = S.ProductTypeDescription
	;

	SET @ProductTypeId = SCOPE_IDENTITY()
END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH