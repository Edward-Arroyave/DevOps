CREATE TABLE Auditoria (
    ID INT PRIMARY KEY,
    Descripcion VARCHAR(MAX),  -- TEXT está obsoleto, usa VARCHAR(MAX)
    Fecha DATETIME DEFAULT GETDATE(),
    Usuario NVARCHAR(100) -- Cambiado de TIMESTAMP a DATETIME con DEFAULT GETDATE()
);
