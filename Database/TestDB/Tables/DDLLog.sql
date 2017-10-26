CREATE TABLE [dbo].[DDLLog]
(
	[EventDateTime] DATETIME NOT NULL, 
    [DBUser] VARCHAR(100) NULL CONSTRAINT DF_DDLLog_DBUser DEFAULT(SUSER_NAME()), 
    [Event] VARCHAR(100) NULL, 
    [TSQL] VARCHAR(4000) NULL, 
    [ObjectName] VARCHAR(255) NULL, 
    [ObjectType] VARCHAR(50) NULL
)

GO

CREATE INDEX [IX_DDLLog_ObjectName] ON [dbo].[DDLLog] (ObjectName, EventDateTime)
