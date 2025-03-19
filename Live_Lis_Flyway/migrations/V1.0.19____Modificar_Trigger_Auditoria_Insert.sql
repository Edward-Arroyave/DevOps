exec SaveSchemaBackup 'Auditoria_Insert';
GO
ALTER TRIGGER Auditoria_Insert
ON Clientes
AFTER INSERT
AS
BEGIN
    INSERT INTO Auditoria (Descripcion)
    SELECT 
        'Nuevo cliente agregado: ' + Nombre + ' | Correo: ' + Correo
    FROM inserted;
END;
GO
