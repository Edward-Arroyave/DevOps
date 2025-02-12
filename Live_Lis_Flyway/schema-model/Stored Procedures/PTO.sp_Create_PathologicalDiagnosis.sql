SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 19/07/2022
-- Description: Procedimiento almacenado para crear/actualizar diagnosticos patologicos.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Create_PathologicalDiagnosis]
(
	@IdPathologicalDiagnosis int, 
	@IdPatient_Exam int, 
	@DiagnosisDate datetime,
	@IdPrincipalDiagnosis int, 
	@IdSecondaryDiagnosis int, 
	@IdTertiaryDiagnosis int, 
	@IdPathologyClassification int, 
	@IdDiagnosticUser int,
	@DiagnosticDescription text,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdPathologicalDiagnosis = 0
		BEGIN
			INSERT INTO PTO.TB_PathologicalDiagnosis(IdPatient_Exam, DiagnosisDate, IdPrincipalDiagnosis, IdSecondaryDiagnosis, IdTertiaryDiagnosis, IdPathologyClassification, IdDiagnosticUser, DiagnosticDescription)
			VALUES (@IdPatient_Exam, @DiagnosisDate, @IdPrincipalDiagnosis, @IdSecondaryDiagnosis, @IdTertiaryDiagnosis, @IdPathologyClassification, @IdDiagnosticUser, @DiagnosticDescription)

			SET @Message = 'Successfully created pathological diagnosis'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			UPDATE PTO.TB_PathologicalDiagnosis
				SET IdPatient_Exam = @IdPatient_Exam,
					DiagnosisDate = @DiagnosisDate,
					IdPrincipalDiagnosis = @IdPrincipalDiagnosis, 
					IdSecondaryDiagnosis = @IdSecondaryDiagnosis,
					IdTertiaryDiagnosis = @IdTertiaryDiagnosis, 
					IdPathologyClassification = @IdPathologyClassification,
					IdDiagnosticUser = @IdDiagnosticUser,
					DiagnosticDescription = @DiagnosticDescription
			WHERE IdPathologicalDiagnosis = @IdPathologicalDiagnosis

			SET @Message = 'Successfully updated pathological diagnosis'
			SET @Flag = 1
		END
END
GO
