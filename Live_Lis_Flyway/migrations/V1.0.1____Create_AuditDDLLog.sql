CREATE TABLE [dbo].[flyway_object_changes] (
    [LogID] INT IDENTITY(1,1) PRIMARY KEY,
    [MigrationVersion] NVARCHAR(50) NULL,
    [MigrationCheckSum] NVARCHAR(MAX) NULL, 
    [EventType] NVARCHAR(100) NOT NULL,  -- Tipo de evento (CREATE, ALTER, DROP, etc.)
    [ObjectType] NVARCHAR(50) NOT NULL,  -- Tipo de objeto (TABLE, PROCEDURE, VIEW, etc.)
    [ObjectName] NVARCHAR(200) NOT NULL, -- Nombre del objeto afectado
    [SQLCommand] NVARCHAR(MAX) NOT NULL, -- Comando SQL ejecutado
    [OldDefinition] NVARCHAR(MAX) NULL,  -- Esquema antes del cambio
    [NewDefinition] NVARCHAR(MAX) NULL,  -- Esquema después del cambio
    [ChangedBy] NVARCHAR(128) NOT NULL,  -- Usuario que hizo el cambio
    [ChangeDate] DATETIME DEFAULT GETDATE() NOT NULL -- Fecha y hora del cambio
);
