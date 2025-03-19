exec SaveSchemaBackup 'Employees';
GO
ALTER TABLE Employees 
ADD HireDate DATETIME DEFAULT GETDATE();
