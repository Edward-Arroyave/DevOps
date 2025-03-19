
EXEC SaveSchemaBackup 'Vista_Clientes';
GO

ALTER VIEW Vista_Clientes AS
SELECT ID, Nombre, Correo, FechaRegistro FROM Clientes;
GO
