SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2023
-- Description: Procedimiento almacenado para crear grupos de exámenes.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Create_ExamGroup] 0,'P190','PERFIL GENERAL',4,1, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_ExamGroup]
(
	@IdExamGroup int, 
	@ExamGroupCode varchar(5), 
	@ExamGroupName varchar(150), 
	@IdTypeOfProcedure int, 
	@IdUserAction int,
	@Score smallint = null,
	@PlanValidity tinyint = null,
	@IdValidityFormat tinyint = null,
	@ActiveValidity tinyint = null,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdExamGroup = 0
		BEGIN
			IF NOT EXISTS (SELECT ExamGroupCode FROM TB_ExamGroup WHERE ExamGroupCode = @ExamGroupCode)
				BEGIN
					IF NOT EXISTS (SELECT ExamGroupName FROM TB_ExamGroup WHERE ExamGroupName = @ExamGroupName)
						BEGIN
							INSERT INTO TB_ExamGroup (ExamGroupCode, ExamGroupName, IdTypeOfProcedure, IdUserAction, Score, PlanValidity, IdValidityFormat, ActiveValidity, Active, CreationDate)
							VALUES (@ExamGroupCode, @ExamGroupName, @IdTypeOfProcedure, @IdUserAction, @Score, @PlanValidity, @IdValidityFormat, @ActiveValidity, 1, DATEADD(HOUR,-5,GETDATE()))

							SET @Message = 'Successfully created exam group'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Exam group code already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Exam group name already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT ExamGroupCode FROM TB_ExamGroup WHERE ExamGroupCode = @ExamGroupCode AND IdExamGroup != @IdExamGroup)
				BEGIN
					IF NOT EXISTS (SELECT ExamGroupName FROM TB_ExamGroup WHERE ExamGroupName = @ExamGroupName AND IdExamGroup != @IdExamGroup)
						BEGIN
							UPDATE TB_ExamGroup
								SET ExamGroupCode = @ExamGroupCode,
									ExamGroupName = @ExamGroupName,
									IdTypeOfProcedure = @IdTypeOfProcedure,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									Score = @Score, 
									PlanValidity = @PlanValidity, 
									IdValidityFormat = @IdValidityFormat, 
									ActiveValidity = @ActiveValidity
							WHERE IdExamGroup = @IdExamGroup

							SET @Message = 'Successfully updated exam group'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Exam group code already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Exam group name already exists'
					SET @Flag = 0
				END
		END
END
GO
