-- Flyway migration script V1.0.2__Alter_brand_table.sql

-- Agregar una nueva columna para almacenar el teléfono
ALTER TABLE brand ADD Phone NVARCHAR(20) NULL;

-- Modificar la columna Email para que sea única
ALTER TABLE brand ADD CONSTRAINT UQ_brand_Email UNIQUE (Email);

-- Agregar un trigger para actualizar automáticamente UpdatedAt en modificaciones
GO
CREATE TRIGGER trg_Update_brand 
ON brand
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    UPDATE brand
    SET UpdatedAt = GETDATE()
    FROM brand
    INNER JOIN inserted i ON brand.Id = i.Id;
END;
GO
