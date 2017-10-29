﻿CREATE TABLE [dbo].[ErrorLog]
(
	ErrorId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_ErrorLog PRIMARY KEY,
	ErrorDate DATETIME NOT NULL CONSTRAINT DF_ErrorLog_ErrorDate DEFAULT (GETUTCDATE()) ,
	UserName VARCHAR(255) NOT NULL CONSTRAINT DF_ErrorLog_UserName DEFAULT(SUSER_SNAME()),
	HostName VARCHAR(255) NOT NULL CONSTRAINT DF_ErrorLog_HostName DEFAULT(HOST_NAME()),
	AppName VARCHAR(255) NOT NULL CONSTRAINT DF_ErrorLog_AppName DEFAULT(APP_NAME()),
	ErrorNumber INT,
	ErrorSeverity INT,
	ErrorState INT,
	ErrorProcedure VARCHAR(255),
	ErrorLine INT, 
	ErrorMessage VARCHAR(4000)
)

GO

CREATE INDEX [IX_ErrorLog_ErrorDate] ON [dbo].[ErrorLog] (ErrorDate)
