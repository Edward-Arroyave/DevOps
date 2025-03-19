exec SaveSchemaBackup  'idx_clientes_correo';
GO


IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'idx_clientes_correo' AND object_id = OBJECT_ID('Clientes'))
BEGIN
    DROP INDEX idx_clientes_correo ON Clientes;
END
GO
