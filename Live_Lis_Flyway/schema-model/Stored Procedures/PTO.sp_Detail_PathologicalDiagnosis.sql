SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/07/2022
-- Description: Procedimiento almacenado para retornar detalle de diagnostico patologico.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_PathologicalDiagnosis]
(
	@IdPathologicalDiagnosis int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPathologicalDiagnosis, IdPatient_Exam, DiagnosisDate, IdPrincipalDiagnosis, IdSecondaryDiagnosis, IdTertiaryDiagnosis, IdPathologyClassification, IdDiagnosticUser, DiagnosticDescription
	FROM PTO.TB_PathologicalDiagnosis
	WHERE IdPathologicalDiagnosis = @IdPathologicalDiagnosis
END
GO
