SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2023
-- Description: Procedimiento almacenado para consultar detalle de grupo de exámenes.
-- =============================================
--EXEC [sp_Detail_ExamGroup] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_ExamGroup]
(
	@IdExamGroup int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdExamGroup, ExamGroupCode, ExamGroupName, IdTypeOfProcedure, Score, PlanValidity, IdValidityFormat, ActiveValidity
	FROM TB_ExamGroup
	WHERE IdExamGroup = @IdExamGroup
END
GO
