SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacendo para consultar el detalle de los servicios de esquemas tarifarios.
-- =============================================
-- EXEC [sp_Consult_TariffScheme_Service] 4
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_TariffScheme_Service]
(
	@IdTariffScheme int
)
AS
BEGIN
    SET NOCOUNT ON

	---Exámenes 
	SELECT DISTINCT A.IdTariffSchemeService, B.TypeOfProcedure, A.IdTariffScheme, A.IdService, C.CUPS, A.IdExam, D.ExamCode, D.ExamName AS ServiceName, A.Value, 
			A.Value_UVR, A.Active, A.Hiring
	FROM TR_TariffScheme_Service A
	INNER JOIN TB_TypeOfProcedure B
		ON B.IdTypeOfProcedure = A.IdTypeOfProcedure
	LEFT JOIN TB_Service C
		ON C.IdService = A.IdService
	LEFT JOIN TB_Exam D
		ON D.IdExam = A.IdExam
	WHERE A.IdTypeOfProcedure = 1 
		AND A.IdTariffScheme = @IdTariffScheme
		AND A.Active = 'True'
		AND D.Active=1
	
	UNION ALL

	--- Grupos de exámenes
	SELECT DISTINCT A.IdTariffSchemeService, D.TypeOfProcedure, A.IdTariffScheme, A.IdService , NULL, A.IdExamGroup, C.ExamGroupCode, C.ExamGroupName, A.Value, 
			A.Value_UVR, A.Active, A.Hiring
	FROM TR_TariffScheme_Service A
	INNER JOIN TB_ExamGroup C
		ON C.IdExamGroup = A.IdExamGroup
			AND C.Active=1
	INNER JOIN TB_TypeOfProcedure D
		ON D.IdTypeOfProcedure = A.IdTypeOfProcedure
	WHERE A.IdTypeOfProcedure != 1
		AND A.IdTariffScheme = @IdTariffScheme
		AND A.Active = 'True'
		AND C.Active=1
END
GO
