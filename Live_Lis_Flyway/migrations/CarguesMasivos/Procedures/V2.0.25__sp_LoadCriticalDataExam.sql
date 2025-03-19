/****** Object:  StoredProcedure [dbo].[sp_LoadCriticalDataExam]    Script Date: 19/02/2025 12:02:38 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_LoadCriticalDataExam]
    @CriticalDataExam LoadCriticalDataExam READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

		SELECT A.*
		FROM @CriticalDataExam A
		LEFT JOIN TB_Exam B ON B.ExamCode = A.ExamCode
		LEFT JOIN TB_Analyte C ON C.AnalyteCode = A.NameAnalyte AND C.IdExam = B.IdExam
		LEFT JOIN TB_DataType F ON F.DataType = A.DataType
		--INNER JOIN TB_CriticalDates D ON D.IdAnalyte = C.IdAnalyte
		INNER JOIN TB_ExpectedValue E ON E.ExpectedValue = A.ExpectedValue
		WHERE --D.IdCriticalDates IS NOT NULL OR 
		C.IdAnalyte IS NULL OR B.IdExam IS NULL OR F.IdDataType IS NULL;
    

        INSERT INTO TB_CriticalDates(IdAnalyte, IdDataType, InitialValue, FinalValue, IdExpectedValue, CreationDate, IdUserCreation, Active)
        SELECT C.IdAnalyte, F.IdDataType, A.LowerLimit, A.UpperLimit, E.IdExpectedValue, @Date, @IdUser, 1 Active
        FROM @CriticalDataExam A
		INNER JOIN TB_Exam B ON B.ExamCode = A.ExamCode 
		INNER JOIN TB_Analyte C ON C.AnalyteName = A.NameAnalyte AND C.IdExam = B.IdExam 
		INNER JOIN TB_DataType F ON F.DataType = A.DataType
        --LEFT JOIN TB_CriticalDates D ON D.IdAnalyte = C.IdAnalyte
		LEFT JOIN TB_ExpectedValue E ON E.ExpectedValue = A.ExpectedValue; 
        --WHERE D.IdCriticalDates IS NULL;
        
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

