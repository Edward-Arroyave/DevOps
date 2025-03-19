exec SaveSchemaBackup 'InsertarCliente';
GO

ALTER PROCEDURE InsertarCliente
    @nombre VARCHAR(100),
    @correo VARCHAR(150),
    @telefono VARCHAR(20) = NULL -- Nuevo parámetro opcional
AS
BEGIN
    INSERT INTO Clientes (Nombre, Correo, FechaRegistro, Telefono) 
    VALUES (@nombre, @correo, GETDATE(), @telefono); -- Se agrega FechaRegistro y Teléfono
END;
GO
