SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/11/20212
-- Description: Procedimiento almacenado para activar o desactivar examen.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_Exam]
(
	@IdExam int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdExam FROM TB_Exam WHERE IdExam = @IdExam)
		BEGIN
			UPDATE TB_Exam
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdExam = @IdExam

			SET @Message = 'Successfully updated Exam'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Exam not found'
			SET @Flag = 0
		END
END
GO
