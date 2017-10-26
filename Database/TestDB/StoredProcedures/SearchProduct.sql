CREATE PROCEDURE [dbo].[SearchProduct]
	@ProductTypeCode VARCHAR(30) = NULL, -- 
	@ProductName VARCHAR(1000) = NULL,
	@UpdatedBy VARCHAR(50) = NULL

AS
/*
	Description - Search products
	INPUT PARAMETERS:
	@ProductTypeCode - Product Type Mask search supported
	@ProductName - Product Name. Mask search supported
	@UpdatedBy - Search products modified by user
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
	WHERE (@ProductTypeCode IS NULL OR pt.ProductTypeCode LIKE @ProductTypeCode)
	AND (@ProductName IS NULL OR p.ProductName LIKE @ProductName)
	AND (@UpdatedBy IS NULL OR p.UpdatedBy = @UpdatedBy)

END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH