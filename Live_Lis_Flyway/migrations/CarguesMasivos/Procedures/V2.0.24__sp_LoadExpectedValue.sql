/****** Object:  StoredProcedure [dbo].[sp_LoadExpectedValue]    Script Date: 19/02/2025 12:01:35 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO






CREATE PROCEDURE [dbo].[sp_LoadExpectedValue]
    @ExpectedValue LoadExpectedValue READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
		SELECT B.*
		FROM @ExpectedValue A
		INNER JOIN TB_ExpectedValue B
			ON A.ExpectedValue = B.ExpectedValue;
    
 
		INSERT INTO TB_ExpectedValue(ExpectedValue, Active, CreationDate, IdUserAction)
        SELECT A.ExpectedValue, 1 AS Active, @Date, @IdUser
        FROM @ExpectedValue A
        LEFT JOIN TB_ExpectedValue B
            ON A.ExpectedValue = B.ExpectedValue
        WHERE B.IdExpectedValue IS NULL;
        
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

