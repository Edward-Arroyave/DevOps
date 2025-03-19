CREATE PROCEDURE SaveSchemaBackup
    @ObjectName NVARCHAR(200)
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @OldSchema NVARCHAR(MAX) = '';
    DECLARE @ObjectType NVARCHAR(50) = '';
    DECLARE @CRLF NVARCHAR(2) = CHAR(13) + CHAR(10);
    DECLARE @INDENT NVARCHAR(4) = '    ';
    DECLARE @SEPARATOR NVARCHAR(10) = ',' + @CRLF + @INDENT;

    -- Determinar el tipo de objeto optimizado
    SELECT @ObjectType = 
        CASE 
            WHEN EXISTS (SELECT 1 FROM sys.objects WHERE name = @ObjectName AND type IN ('U', 'P', 'V', 'TR')) THEN
                (SELECT CASE type 
                    WHEN 'U' THEN 'TABLE'
                    WHEN 'P' THEN 'PROCEDURE'
                    WHEN 'V' THEN 'VIEW'
                    WHEN 'TR' THEN 'TRIGGER'
                END FROM sys.objects WHERE name = @ObjectName AND type IN ('U', 'P', 'V', 'TR'))
            WHEN EXISTS (SELECT 1 FROM sys.indexes WHERE name = @ObjectName) THEN 'INDEX'
            WHEN EXISTS (SELECT 1 FROM sys.types WHERE name = @ObjectName AND is_user_defined = 1) THEN 'TYPE'
            ELSE 'UNKNOWN'
        END;


    -- Obtener la estructura del objeto optimizado
    SET @OldSchema = 
        CASE 
            WHEN @ObjectType = 'TABLE' THEN (
                SELECT QUOTENAME(@ObjectName) + ' (' + @CRLF +
                    STRING_AGG(
                        @INDENT + QUOTENAME(c.name) + ' ' + ty.name +
                        CASE 
                            WHEN ty.name IN ('varchar', 'nvarchar', 'char', 'nchar') 
                                THEN '(' + 
                                    CASE 
                                        WHEN c.max_length = -1 THEN 'MAX' 
                                        ELSE 
                                            CASE ty.name
                                                WHEN 'nvarchar' THEN CAST(c.max_length/2 AS NVARCHAR(MAX))
                                                WHEN 'nchar' THEN CAST(c.max_length/2 AS NVARCHAR(MAX))
                                                ELSE CAST(c.max_length AS NVARCHAR(MAX))
                                            END
                                    END + ')'
                            WHEN ty.name IN ('decimal', 'numeric') 
                                THEN '(' + CAST(c.precision AS NVARCHAR(MAX)) + ',' + CAST(c.scale AS NVARCHAR(MAX)) + ')'
                            ELSE '' 
                        END + ' ' + IIF(c.is_nullable = 1, 'NULL', 'NOT NULL')
                        , @SEPARATOR
                    ) WITHIN GROUP (ORDER BY c.column_id) + @CRLF + ')'
                FROM sys.tables t
                JOIN sys.columns c ON t.object_id = c.object_id
                JOIN sys.types ty ON c.user_type_id = ty.user_type_id
                WHERE t.name = @ObjectName
                GROUP BY t.name
            )
            
            WHEN @ObjectType IN ('PROCEDURE', 'VIEW', 'TRIGGER') THEN (
                SELECT QUOTENAME(@ObjectName) + ' (' + @CRLF +
                    REPLACE(
                        REPLACE(m.definition, 
                            CASE @ObjectType
                                WHEN 'PROCEDURE' THEN 'CREATE PROCEDURE '
                                WHEN 'VIEW' THEN 'CREATE VIEW '
                                WHEN 'TRIGGER' THEN 'CREATE TRIGGER '
                            END, ''),
                        'CREATE ', '') + @CRLF + ')'
                FROM sys.sql_modules m
                WHERE m.object_id = OBJECT_ID(@ObjectName)
            )
            
            WHEN @ObjectType = 'INDEX' THEN (
                SELECT QUOTENAME(i.name) + ' ON ' + QUOTENAME(s.name) + '.' + QUOTENAME(t.name) + @CRLF + '(' + @CRLF +
                    STRING_AGG(
                        @INDENT + QUOTENAME(c.name) + IIF(ic.is_descending_key = 1, ' DESC', ' ASC')
                        , ', ' 
                    ) WITHIN GROUP (ORDER BY ic.key_ordinal) + @CRLF + ')'
                FROM sys.indexes i
                JOIN sys.tables t ON i.object_id = t.object_id
                JOIN sys.schemas s ON t.schema_id = s.schema_id
                JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
                JOIN sys.columns c ON ic.column_id = c.column_id AND ic.object_id = c.object_id
                WHERE i.name = @ObjectName
                GROUP BY i.name, s.name, t.name
            )
            
            WHEN @ObjectType = 'TYPE' THEN (
                SELECT QUOTENAME(tt.name) + ' AS TABLE (' + @CRLF +
                    STRING_AGG(
                        @INDENT + QUOTENAME(c.name) + ' ' + ty.name +
                        CASE 
                            WHEN ty.name IN ('varchar', 'nvarchar', 'char', 'nchar') 
                                THEN '(' + 
                                    CASE 
                                        WHEN c.max_length = -1 THEN 'MAX' 
                                        ELSE 
                                            CASE ty.name
                                                WHEN 'nvarchar' THEN CAST(c.max_length/2 AS NVARCHAR(MAX))
                                                WHEN 'nchar' THEN CAST(c.max_length/2 AS NVARCHAR(MAX))
                                                ELSE CAST(c.max_length AS NVARCHAR(MAX))
                                            END
                                    END + ')'
                            WHEN ty.name IN ('decimal', 'numeric') 
                                THEN '(' + CAST(c.precision AS NVARCHAR(MAX)) + ',' + CAST(c.scale AS NVARCHAR(MAX)) + ')'
                            ELSE '' 
                        END + IIF(c.is_nullable = 0, ' NOT NULL', ' NULL')
                        , @SEPARATOR
                    ) WITHIN GROUP (ORDER BY c.column_id) + @CRLF + ')'
                FROM sys.table_types tt
                JOIN sys.columns c ON tt.type_table_object_id = c.object_id
                JOIN sys.types ty ON c.user_type_id = ty.user_type_id
                WHERE tt.name = @ObjectName
                GROUP BY tt.name
            )
            
            ELSE 'El objeto' + @ObjectType  +'no existe o no es un tipo soportado.'
        END;

    -- Registrar en la tabla de auditoría
    INSERT INTO flyway_object_changes(EventType, ObjectType, ObjectName, SQLCommand, OldDefinition, ChangedBy, ChangeDate)
    VALUES ('BACKUP_OBJECT', @ObjectType, @ObjectName, 'Backup before modification', @OldSchema, SUSER_NAME(), GETDATE());
END;
GO