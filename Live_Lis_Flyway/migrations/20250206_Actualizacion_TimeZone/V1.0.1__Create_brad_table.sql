-- Flyway migration script V1.0.1__Create_brad_table.sql

-- Crear la tabla 'brad'
CREATE TABLE brad (
    Id INT IDENTITY(1,1) PRIMARY KEY,       -- Columna de Id con auto-incremento
    Name NVARCHAR(100) NOT NULL,             -- Columna de nombre (no nula)
    Age INT,                                -- Columna de edad
    Email NVARCHAR(255),                     -- Columna de email
    CreatedAt DATETIME2 DEFAULT GETDATE(),  -- Columna de fecha de creación
    UpdatedAt DATETIME2 DEFAULT GETDATE()   -- Columna de fecha de actualización
);

-- Si es necesario, agregar algunos índices o restricciones adicionales
CREATE INDEX IX_Brad_Email ON brad(Email);

-- Insertar algunos datos de ejemplo (opcional)
-- INSERT INTO brad (Name, Age, Email) VALUES ('John Doe', 30, 'john.doe@example.com');