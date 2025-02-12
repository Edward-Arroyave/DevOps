SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2023
-- Description: Procedimiento almacenado para relacionar exámenes a grupo de exámenes.
-- =============================================
--DECLARE @ExamGroup_Exam ExamGroup_Exam, @Message varchar(50), @Flag bit
--INSERT INTO @ExamGroup_Exam (IdExam, IdService) VALUES
--(3,NULL),
--(19,NULL),
--(44,NULL),
--(45,NULL)
--EXEC [sp_Relate_ExamGroup_Exam] 8,@ExamGroup_Exam, 4, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Relate_ExamGroup_Exam]
(
	@IdExamGroup int,
	@ExamGroup_Exam ExamGroup_Exam READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	MERGE TR_ExamGroup_Exam AS TARGET
	USING @ExamGroup_Exam AS SOURCE
		ON TARGET.IdExamGroup = @IdExamGroup
			AND TARGET.IdExam = SOURCE.IdExam
			AND ISNULL(TARGET.IdService,0) = ISNULL(SOURCE.IdService, 0)
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdExamGroup, IdExam, IdService)
		VALUES
			(
			@IdExamGroup,
			SOURCE.IdExam,
			SOURCE.IdService
			)
	WHEN MATCHED
		THEN
			UPDATE
				SET TARGET.Active = 1
	WHEN NOT MATCHED BY SOURCE AND IdExamGroup = @IdExamGroup
		THEN
			UPDATE
				SET TARGET.Active = 0;

	SET @Flag = 1
	SET @Message = 'Successfully related exams to group of exams'			
END
GO
