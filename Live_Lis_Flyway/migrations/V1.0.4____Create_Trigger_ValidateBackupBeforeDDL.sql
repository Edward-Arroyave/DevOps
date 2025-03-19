CREATE TRIGGER trg_ValidateBackupBeforeDDL
ON DATABASE
AFTER  DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
 DECLARE @EventType NVARCHAR(100);
  SELECT @EventType = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'NVARCHAR(100)');
 IF @EventType LIKE '%DROP%' OR @EventType LIKE '%ALTER%'
    BEGIN
    SET NOCOUNT ON;

    DECLARE @ObjectName NVARCHAR(200);
    SELECT @ObjectName = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'NVARCHAR(200)');

    -- Validar si el objeto tiene un respaldo reciente
    IF NOT EXISTS (SELECT TOP 1 1 FROM flyway_object_changes  WHERE ObjectName = @ObjectName AND EventType = 'BACKUP_OBJECT'  ORDER BY ChangeDate DESC)
    BEGIN
        RAISERROR ('ERROR: No se puede modificar  sin un respaldo previo. Usa el sp SaveSchemaBackup.', 16, 1, @ObjectName);
        ROLLBACK;
    END
	END
END;
GO

