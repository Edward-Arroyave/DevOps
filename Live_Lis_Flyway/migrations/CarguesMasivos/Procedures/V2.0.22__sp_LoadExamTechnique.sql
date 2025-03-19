/****** Object:  StoredProcedure [dbo].[sp_LoadExamTechnique]    Script Date: 19/02/2025 12:00:12 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





CREATE PROCEDURE [dbo].[sp_LoadExamTechnique]
    @ExamTechnique LoadExamTechnique READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

		SELECT B.*
		FROM @ExamTechnique A
		INNER JOIN TB_ExamTechnique B
			ON A.ExamTechnique = B.ExamTechnique;
 
        INSERT INTO TB_ExamTechnique(ExamTechnique, Active, CreationDate, IdUserAction)
        SELECT A.ExamTechnique, 1 AS Active, @Date, @IdUser
        FROM @ExamTechnique A
        LEFT JOIN TB_ExamTechnique B
            ON A.ExamTechnique = B.ExamTechnique
        WHERE B.IdExamTechnique IS NULL;
        
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

