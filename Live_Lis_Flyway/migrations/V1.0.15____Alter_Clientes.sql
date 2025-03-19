
exec SaveSchemaBackup 'Clientes';

ALTER TABLE Clientes
ADD Telefono VARCHAR(20) NULL;