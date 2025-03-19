exec SaveSchemaBackup 'Auditoria_Insert';
GO
ALTER TRIGGER Auditoria_Insert
ON Clientes
AFTER INSERT
AS
BEGIN
    INSERT INTO Auditoria (Descripcion, Fecha, Usuario)
    SELECT 
        'Nuevo cliente agregado: ' + Nombre + ' | Correo: ' + Correo,
        GETDATE(),
        SUSER_NAME()
    FROM inserted;
END;
GO