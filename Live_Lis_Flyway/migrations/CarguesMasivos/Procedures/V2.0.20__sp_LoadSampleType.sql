/****** Object:  StoredProcedure [dbo].[sp_LoadSampleType]    Script Date: 19/02/2025 11:57:49 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_LoadSampleType]
    @SampleType LoadSampleType READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

		-- Devolver los registros que no cumplen con las condiciones para el insert
		SELECT A.AlternativeCode, A.SampleType
		FROM @SampleType A
		INNER JOIN TB_SampleType B 
			ON A.AlternativeCode = B.AlternativeCode 
			AND A.SampleType = B.SampleType;

        -- Insertar los registros que no existen en TB_SampleType
        INSERT INTO TB_SampleType (AlternativeCode, SampleType, Active, CreationDate, IdUserAction)
        SELECT A.AlternativeCode, A.SampleType, 1 AS Active, @Date, @IdUser
        FROM @SampleType A
        LEFT JOIN TB_SampleType B 
            ON A.AlternativeCode = B.AlternativeCode 
            AND A.SampleType = B.SampleType
        WHERE B.IdSampleType IS NULL;
        
        -- Verificar si hubo inserciones
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

