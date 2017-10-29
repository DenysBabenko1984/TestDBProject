CREATE PROCEDURE [dbo].[GetProductTypeList]
	@ProductTypeCode VARCHAR(30) = NULL, 
	@ProductTypeDescription VARCHAR(100) = NULL
AS
/*
	Description - SP Returns a list of available ProductType.
	Could be used for UI DropDown control
	INPUT PARAMETERS:
	@ProductTypeCode - ProductTypeCode to be filtered. SQL Wildcard supported
	@ProductTypeDescription - ProductTypeDescriptions to be filtered. SQL Wildcard supported
*/
SET NOCOUNT ON
BEGIN TRY
	SELECT  
		p.ProductTypeId,
		p.ProductTypeCode,
		p.ProductTypeDescription
	FROM dbo.ProductType p
	WHERE	ISNULL(@ProductTypeCode, p.ProductTypeCode) = p.ProductTypeCode
	AND		ISNULL(@ProductTypeDescription, p.ProductTypeDescription) = p.ProductTypeDescription
END TRY
BEGIN CATCH
	IF (XACT_STATE() = -1)
		ROLLBACK
	EXEC dbo.LogError;
	THROW
END CATCH
