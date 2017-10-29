CREATE TRIGGER [DDLLog]
ON DATABASE
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
	DECLARE @data XML = EVENTDATA()
	INSERT INTO dbo.DDLLog (EventDateTime, DBUser, Event, ObjectName, ObjectType, TSQL)
	VALUES (
		GETUTCDATE(),
		CONVERT(VARCHAR(100), CURRENT_USER),
		@data.value('(/EVENT_INSTANCE/EventType)[1]', 'VARCHAR(100)'),
		@data.value('(/EVENT_INSTANCE/SchemaName)[1]', 'VARCHAR(255)') + '.' + @data.value('(/EVENT_INSTANCE/ObjectName)[1]', 'VARCHAR(255)'),
		@data.value('(/EVENT_INSTANCE/ObjectType)[1]', 'VARCHAR(100)'),
		@data.value('(/EVENT_INSTANCE/TSQLCommand)[1]', 'VARCHAR(4000)')
	)
END
