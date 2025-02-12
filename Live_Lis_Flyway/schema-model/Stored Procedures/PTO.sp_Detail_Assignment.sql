SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para retornar información de asignación para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_Assignment]
(
	@IdAssignment int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdAssignment, IdPatient_Exam, IdUser, AssignmentDateAndTime, IdPathologyProcess
	FROM PTO.TB_Assignment
	WHERE IdAssignment = @IdAssignment
END
GO
