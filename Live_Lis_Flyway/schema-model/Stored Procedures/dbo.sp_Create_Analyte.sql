SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/11/20212
-- Description: Procedimiento almacenado para crear analito.
-- =============================================
--EXEC [sp_Consult_Analyte] '','','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Analyte]
(
	@IdAnalyte int,
	@IdExam int, 
	@AnalyteName varchar(250), 
	@IdSampleType int, 
	@IdExamTechnique int = NULL, 
	@IdUnitOfMeasurement int, 
	@Comments varchar(max),
	@ResultFormula varchar(max) = NULL,
	@IdDataType int,
	@InitialValue decimal (15,8) = NULL,
	@FinalValue decimal (15,8) = NULL,
	@IdExpectedValue int = NULL,
	@CodificationText varchar(max) = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @ExamCode varchar(10), @AnalyteCode varchar(10), @Consecutive int = 1
BEGIN
    SET NOCOUNT ON

	SET @ExamCode = (SELECT ExamCode FROM TB_Exam WHERE IdExam = @IdExam)
	SET @Consecutive = @Consecutive + (SELECT COUNT(*) FROM TB_Analyte WHERE IdExam = @IdExam AND AnalyteCode != @ExamCode)
	SET @AnalyteCode = CONCAT(@ExamCode, '-', @Consecutive)

	IF @IdAnalyte = 0
		BEGIN
			IF NOT EXISTS (SELECT AnalyteName FROM TB_Analyte WHERE AnalyteName = @AnalyteName AND IdExam = @IdExam)
				BEGIN
					INSERT INTO TB_Analyte (IdExam, AnalyteCode, AnalyteName, IdSampleType, IdExamTechnique, IdUnitOfMeasurement, Comments, ResultFormula, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, Visible, Active, CreationDate, IdUserAction)
					VALUES (@IdExam, @AnalyteCode, @AnalyteName, @IdSampleType, @IdExamTechnique, @IdUnitOfMeasurement, @Comments, @ResultFormula, @IdDataType, @InitialValue, @FinalValue, @IdExpectedValue, @CodificationText, 1, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

					SET @Message = 'Successfully created analyte'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Analyte already exist'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT * FROM TB_Analyte WHERE AnalyteName = @AnalyteName AND IdAnalyte != @IdAnalyte)
				BEGIN
					UPDATE TB_Analyte
						SET IdExam = @IdExam,
							AnalyteName = @AnalyteName,
							IdSampleType = @IdSampleType,
							IdExamTechnique = @IdExamTechnique,
							IdUnitOfMeasurement = @IdUnitOfMeasurement,
							Comments = @Comments,
							ResultFormula = @ResultFormula,
							IdDataType = @IdDataType, 
							InitialValue = @InitialValue,
							FinalValue = @FinalValue,
							IdExpectedValue = @IdExpectedValue,
							CodificationText = @CodificationText,
							Visible = 1,
							Active = 1,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdAnalyte = @IdAnalyte

					SET @Message = 'Successfully updated analyte'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Analyte already exist'
					SET @Flag = 0
				END
		END
END
GO
