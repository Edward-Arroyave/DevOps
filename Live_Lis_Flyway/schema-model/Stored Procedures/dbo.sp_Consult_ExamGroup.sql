SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/08/2023
-- Description: Procedimiento almacenado para consultar todos los grupos de exámenes.
-- =============================================
--EXEC [sp_Detail_ExamGroup] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ExamGroup]
AS
BEGIN
    SET NOCOUNT ON

	SELECT	A.IdExamGroup, A.IdTypeOfProcedure, B.TypeOfProcedure, A.ExamGroupCode, A.ExamGroupName, A.Active,
			A.Score, A.PlanValidity, A.IdValidityFormat, A.ActiveValidity
	FROM TB_ExamGroup A
	INNER JOIN TB_TypeOfProcedure B
		ON B.IdTypeOfProcedure = A.IdTypeOfProcedure
END
GO
