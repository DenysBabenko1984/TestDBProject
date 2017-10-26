CREATE PROCEDURE [dbo].[PutProduct]
	@ProductId int = NULL OUTPUT,
	@ProductTypeCode VARCHAR(30),
	@ProductName VARCHAR(1000),
	@UserName VARCHAR(50) = NULL
AS
/*
	Description - INSERT\UPDATE  Product
	INPUT PARAMETERS:
	@ProductId - NULL in case of new row insertion.
	@ProductTypeCode
	@ProductName
	@UserName - User that responsible for change. If not passed SQL Server will try to identify it.
				Required because User used for authentification in UI could be different to user used for identification in DB.
				Well known constraint in case of Client-AppServer-DB architecture
*/
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
-- Need to lock ProductType for avoid unexpected row delete during product insertion

BEGIN TRY

   -- Detect whether the procedure was called  from an active transaction and save  that for later use.   
	--In the procedure, @TranCounter = 0  means there was no active transaction  and the procedure started one.  
    -- @TranCounter > 0 means an active  transaction was started before the   procedure was called.  
    DECLARE @TranCounter INT;  
    SET @TranCounter = @@TRANCOUNT;  
    IF @TranCounter > 0  
        -- Procedure called when there is  an active transaction.  
        -- Create a savepoint to be able  to roll back only the work done  
        -- in the procedure if there is an  error.  
        SAVE TRANSACTION ProcedureSave;  
    ELSE  
        -- Procedure must start its own  
        -- transaction.  
        BEGIN TRANSACTION;  
    -- Modify database.  

	-- 1. Check for Correct ProductCode
	IF ISNULL(@ProductTypeCode, '') = ''
		RAISERROR('Correct @ProductTypeCode should be provided', 16, 1)
	DECLARE @ProductTypeId int
	SELECT TOP 1 @ProductTypeId = ProductTypeId
	FROM dbo.ProductType
	WHERE ProductTypeCode = @ProductTypeCode

	IF @ProductTypeId is NULL
		RAISERROR('@ProductTypeCode=[%s] does not exist in dbo.ProductType table. Select correct one or create new befor new product creation.', 16, 1, @ProductTypeCode)
	
	IF Len(ISNULL(@ProductName, '')) = 0
		RAISERROR('@ProductName could not be empty', 16, 1)

	;MERGE dbo.Product as T
	USING (VALUES
				(@ProductId, @ProductTypeId, @ProductName)
			) as S(ProductId, ProductTypeId, ProductName)
	ON T.ProductId = S.ProductId
	WHEN NOT MATCHED THEN
		INSERT (ProductTypeId, ProductName, UpdatedBy)
		VALUES (ProductTypeId, ProductName, ISNULL(@UserName, SUSER_SNAME()))
	WHEN MATCHED THEN
		UPDATE SET
			T.ProductTypeId = S.ProductTypeId
			, T.ProductName = S.ProductName
			, T.UpdatedBy = ISNULL(@UserName, SUSER_SNAME())
			, T.UpdatedDate = GETUTCDATE()
	;

	SET @ProductId = SCOPE_IDENTITY()
 
    -- Get here if no errors; must commit  any transaction started in the  
    -- procedure, but not commit a transaction   started before the transaction was called.  
    IF @TranCounter = 0  
        -- @TranCounter = 0 means no transaction was  started before the procedure was called.  
        -- The procedure must commit the transaction  it started.  
        COMMIT TRANSACTION;  
END TRY
BEGIN CATCH
    -- An error occurred; must determine   which type of rollback will roll  back only the work done in the  procedure.  
    IF @TranCounter = 0  
        -- Transaction started in procedure.           Roll back complete transaction.  
        ROLLBACK TRANSACTION;  
    ELSE  
        -- Transaction started before procedure  called, do not roll back modifications  made before the procedure was called.  
        IF XACT_STATE() <> -1  
            -- If the transaction is still valid, just  roll back to the savepoint set at the  start of the stored procedure.  
            ROLLBACK TRANSACTION ProcedureSave;  
            -- If the transaction is uncommitable, a rollback to the savepoint is not allowed  
            -- because the savepoint rollback writes to  the log. Just return to the caller, which  should roll back the outer transaction.
	EXEC dbo.LogError;
	THROW
END CATCH

