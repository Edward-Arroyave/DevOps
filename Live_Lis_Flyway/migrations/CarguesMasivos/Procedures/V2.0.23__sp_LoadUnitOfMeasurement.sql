/****** Object:  StoredProcedure [dbo].[sp_LoadUnitOfMeasurement]    Script Date: 19/02/2025 12:00:54 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[sp_LoadUnitOfMeasurement]
    @UnitOfMeasurement LoadUnitOfMeasurement READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

		SELECT B.*
		FROM @UnitOfMeasurement A
		INNER JOIN TB_UnitOfMeasurement B
			ON A.UnitOfMeasurement = B.UnitOfMeasurement;
    

        INSERT INTO TB_UnitOfMeasurement(UnitOfMeasurement, Active, CreationDate, IdUserAction)
        SELECT A.UnitOfMeasurement, 1 AS Active, @Date, @IdUser
        FROM @UnitOfMeasurement A
        LEFT JOIN TB_UnitOfMeasurement B
            ON A.UnitOfMeasurement = B.UnitOfMeasurement
        WHERE B.IdUnitOfMeasurement IS NULL;
        
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

