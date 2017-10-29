CREATE PROCEDURE [dbo].[LogError]
AS
SET NOCOUNT ON
BEGIN
	SET NOCOUNT ON
	INSERT INTO dbo.ErrorLog (
			UserName ,
			HostName ,
			AppName ,
			ErrorNumber ,
			ErrorSeverity ,
			ErrorState ,
			ErrorProcedure ,
			ErrorLine , 
			ErrorMessage 
		)
	VALUES(
		SUSER_SNAME(),
		HOST_NAME(),
		APP_NAME(),
		ERROR_NUMBER(),
		ERROR_SEVERITY(),
		ERROR_STATE(),
		ERROR_PROCEDURE(),
		ERROR_LINE(),
		ERROR_MESSAGE()
	)
END
