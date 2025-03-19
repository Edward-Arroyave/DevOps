CREATE TRIGGER Auditoria_Insert
ON Clientes
AFTER INSERT
AS
BEGIN
    INSERT INTO Auditoria (Descripcion, Fecha)
    SELECT 'Nuevo cliente agregado: ' + Nombre, GETDATE()
    FROM inserted;
END;
