SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/08/2023
-- Description: Procedimiento almacenado para listar exámenes/grupos de exámenes de acuerdo con el tipo de procedimiento.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_TypeOfProceduree_Exam]
(
	@IdTypeOfProcedure int
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdTypeOfProcedure = 1
		BEGIN
			SELECT IdExam, ExamCode, CONCAT(ExamCode,' - ', ExamName) AS ExamName
			FROM TB_Exam
			WHERE Active = 'True'
		END
	ELSE
		BEGIN
			SELECT IdExamGroup, ExamGroupCode, CONCAT(ExamGroupCode, ' - ', ExamGroupName) AS ExamGroupName
			FROM TB_ExamGroup
			WHERE IdTypeOfProcedure = @IdTypeOfProcedure
				AND Active = 'True'
		END
END
GO
