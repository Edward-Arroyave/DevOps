exec SaveSchemaBackup 'idx_clientes_nombre';

DROP INDEX IF EXISTS idx_clientes_nombre ON Clientes;
GO
