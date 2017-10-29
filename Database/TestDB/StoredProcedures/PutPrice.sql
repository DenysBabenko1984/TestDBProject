CREATE PROCEDURE [dbo].[PutPrice]
	@PriceTable utPriceTable READONLY -- table type used
	,@UserName VARCHAR(50)
AS
/*
	Description - bulk INSERT\UPDATE  prices
	INPUT PARAMETERS:
	@PriceTable - user defined table.
	@UserName - User that responsible for change. If not passed SQL Server will try to identify it.
				Required because User used for authentification in UI could be different to user used for identification in DB.
				Well known constraint in case of Client-AppServer-DB architecture
	
	RETURN RESULTSET
	Table with utPriceTable type structure.
*/
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;  
-- Need to lock ProductType for avoid unexpected row delete during product insertion
-- REPEATABLE READ because solution was developed and tested on Azure SQL

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

	-- 1. Check for Correct input parameters
	DECLARE @FailedRows VARCHAR(MAX) = ''

	;WITH CTE AS(
		SELECT	DISTINCT StoreId, ProductId FROM @PriceTable pt
		EXCEPT
		(
			SELECT s.StoreId, p.ProductId
			FROM dbo.Store s
			CROSS JOIN dbo.Product p
		)
	)
	SELECT	@FailedRows = STRING_AGG((FORMATMESSAGE('( %i . %i )', StoreId, ProductId)), ',')
	FROM	CTE

	IF LEN(@FailedRows) > 0
		RAISERROR('Next StoreId and ProductId could not be accepted by system. %s', 16, 1, @FailedRows)
	
	-- Fail if deleted rows were passed as input
	If EXISTS (
				SELECT 1 FROM @PriceTable pt 
				LEFT OUTER JOIN dbo.Price p  on p.PriceId = pt.PriceId
				WHERE pt.PriceId IS NOT NULL
				AND p.PriceId IS NULL
			)
		RAISERROR('Deleted rows were passed as input for update.', 16, 1)

	DECLARE @ActionTable TABLE
		(
			RowId INT,
			PriceId INT
		)

	;MERGE dbo.Price as T
	USING @PriceTable as S
	ON T.PriceId = S.PriceId
	WHEN Matched THEN
		UPDATE SET
			T.PriceValue = S.PriceValue
			,T.UpdatedBy = @UserName
			,T.UpdatedDate = GETUTCDATE()
	WHEN NOT MATCHED THEN
		INSERT(StoreId, ProductId, PriceValue, UpdatedBy, UpdatedDate)
		VALUES(s.StoreId, s.ProductId, s.PriceValue, ISNULL(@UserName, SUSER_SNAME()), GETUTCDATE())
	OUTPUT s.RowId, INSERTED.PriceId INTO @ActionTable
	;

    -- Get here if no errors; must commit  any transaction started in the  
    -- procedure, but not commit a transaction   started before the transaction was called.  
    IF @TranCounter = 0  
        -- @TranCounter = 0 means no transaction was  started before the procedure was called.  
        -- The procedure must commit the transaction  it started.  
        COMMIT TRANSACTION;  

	SELECT 
		ISNULL(pt.PriceId, a.PriceId)	as PriceId
		, pt.RowId
		, pt.StoreId
		, pt.ProductId
		, pt.PriceValue
	FROM @PriceTable pt
	INNER JOIN @ActionTable a ON a.RowId = pt.RowId

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

