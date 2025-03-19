CREATE PROCEDURE InsertarCliente
    @nombre VARCHAR(100),
    @correo VARCHAR(150)
AS
BEGIN
    INSERT INTO Clientes (Nombre, Correo) VALUES (@nombre, @correo);
END;
