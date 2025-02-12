SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/08/2023
-- Description: Procedimiento almaceando para cargar consentimientos informados.
-- =============================================
--DECLARE @ReqExam_InformConsent ReqExam_InformConsent

--INSERT @ReqExam_InformConsent (IdRequest, IdExam, IdInformedConsent, InformedConsent)
--VALUES (69328,1,11,'Consentimiento informado UDP')

--EXEC [dbo].[sp_Load_RequestInformedConsent] @ReqExam_InformConsent
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_RequestInformedConsent]
(
	@ReqExam_InformConsent ReqExam_InformConsent READONLY
)
AS
	DECLARE @IdRequest int
BEGIN
    SET NOCOUNT ON

	SET @IdRequest = (SELECT DISTINCT IdRequest FROM @ReqExam_InformConsent)

	MERGE TR_ReqExam_InformConsent AS TARGET
	USING @ReqExam_InformConsent AS SOURCE
		ON TARGET.IdRequest = SOURCE.IdRequest 
			AND TARGET.IdInformedConsent = SOURCE.IdInformedConsent
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdRequest, IdInformedConsent, InformedConsent, PatientSignature, ProfessionalSignature, Active)
		VALUES
			(
			SOURCE.IdRequest, 
			SOURCE.IdInformedConsent, 
			SOURCE.InformedConsent,
			'True',
			SOURCE.ProfessionalSignature,
			'True'
			)
	WHEN NOT MATCHED BY SOURCE AND TARGET.IdRequest = @IdRequest AND TARGET.Active = 'True'
		THEN
			UPDATE
				SET TARGET.Active = 'False'
	WHEN MATCHED AND TARGET.Active = 'False'
		THEN
			UPDATE
				SET TARGET.InformedConsent = SOURCE.InformedConsent,
					TARGET.Active = 'True';
				
END
GO
