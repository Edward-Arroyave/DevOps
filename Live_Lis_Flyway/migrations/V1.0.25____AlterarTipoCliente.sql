CREATE TYPE dbo.TipoCliente2 AS TABLE (
    ClienteID INT,
    Nombre NVARCHAR(100),
    Correo NVARCHAR(150),  -- Nueva columna agregada
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO