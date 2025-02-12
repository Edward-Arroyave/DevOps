SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Paola Tellez Gonzalez
-- Create Date: 01/08/2023
-- Description: Procedimiento almacenado para firmar consentimiento informado.
-- =============================================
-- EXEC [dbo].[sp_Detail_InformedConsentSignature] 70646
-- =============================================
CREATE PROCEDURE [dbo].[sp_Signature_InformedConsent]
(
	@IdReqExam_InformConsent int,
	@InformedConsent varchar(max),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

    UPDATE TR_ReqExam_InformConsent
		SET InformedConsent = @InformedConsent,
			ProfessionalSignature = 1,
			IdUserAction = @IdUserAction,
			ProfessionalSignatureDate = DATEADD(HOUR,-5,GETDATE())
	WHERE IdReqExam_InformConsent = @IdReqExam_InformConsent

	SET @Message = 'Successfully signatured informed consent'
	SET @Flag = 1
END
GO
