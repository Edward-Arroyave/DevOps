SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/12/2022
-- Description: Procedimiento almacenado para relacionar formulario extra a un examen.
-- =============================================
--EXEC [dbo].[sp_Consult_AdditionalForm] 3
-- =============================================
CREATE PROCEDURE [dbo].[sp_Relate_AdditionalForm_Exam]
(
	@IdExam int,
	@IdAdditionalForm int = NULL
)
AS
BEGIN
    SET NOCOUNT ON
	
	UPDATE TB_Exam
		SET IdAdditionalForm = @IdAdditionalForm
	WHERE IdExam = @IdExam
END
GO
