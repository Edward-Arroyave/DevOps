CREATE TRIGGER trg_AfterInsertFlyway
ON flyway_schema_history
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @LastMigrationVersion NVARCHAR(50);
    DECLARE @LastMigrationCheckSum NVARCHAR(MAX);
    DECLARE @LastMinute DATETIME = DATEADD(MINUTE, -1, GETDATE());

    -- Obtener la versión y el checksum de la última migración insertada en el último minuto
    SELECT TOP 1 
        @LastMigrationVersion = version, 
        @LastMigrationCheckSum = checksum
    FROM inserted 
    WHERE installed_on >= @LastMinute
    ORDER BY installed_rank DESC;

    -- Verificar que se obtuvo una migración válida antes de actualizar
    IF @LastMigrationVersion IS NOT NULL
    BEGIN
        UPDATE dbo.flyway_object_changes
        SET 
            MigrationVersion = @LastMigrationVersion,
            MigrationCheckSum = @LastMigrationCheckSum
        WHERE MigrationVersion IS NULL;
    END
END;
GO
