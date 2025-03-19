-- V1__
-- Crear un tipo de tabla para clientes
CREATE TYPE dbo.TipoCliente2 AS TABLE (
    ClienteID INT,
    Nombre NVARCHAR(100),
    FechaRegistro DATETIME DEFAULT GETDATE()
);
GO
