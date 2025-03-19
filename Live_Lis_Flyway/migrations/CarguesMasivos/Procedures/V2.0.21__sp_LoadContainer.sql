/****** Object:  StoredProcedure [dbo].[sp_LoadContainer]    Script Date: 19/02/2025 11:59:14 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_LoadContainer]
    @Container LoadContainer READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
				 
		SELECT A.ContainerName, 1 AS Active, @Date CreationDate, @IdUser IdUserAction
		FROM @Container A
		INNER JOIN TB_ContainerType B
			ON A.ContainerName = B.ContainerTypeName;

        INSERT INTO TB_ContainerType(ContainerTypeName, Active, CreationDate, IdUserAction)
        SELECT A.ContainerName, 1 AS Active, @Date, @IdUser
        FROM @Container A
        LEFT JOIN TB_ContainerType B
            ON A.ContainerName = B.ContainerTypeName
        WHERE B.IdContainerType IS NULL;
        
        IF @@ROWCOUNT <> 0
        BEGIN
            SET @Status = 1;
            SET @StatusMessage = 'Los datos fueron insertados correctamente.';
        END
        ELSE
        BEGIN
            SET @Status = 0;
            SET @StatusMessage = 'No se insertaron datos porque ya existen en la tabla.';
        END
    END TRY
    BEGIN CATCH
        -- Capturar error y retornar mensaje
        SET @Status = -1;
        SET @StatusMessage = ERROR_MESSAGE();
    END CATCH;



END
GO

