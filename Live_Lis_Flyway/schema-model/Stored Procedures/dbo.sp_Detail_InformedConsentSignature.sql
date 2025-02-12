SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Paola Tellez Gonzalez
-- Create Date: 01/08/2023
-- Description: Procedimiento almacenado para listar los consentimientos informados para firmar en una solicitud especifica.
-- =============================================
-- EXEC [dbo].[sp_Detail_InformedConsentSignature] 70646
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_InformedConsentSignature]
(
	@IdRequest int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdReqExam_InformConsent, B.IdRequest, B.CreationDate, A.IdInformedConsent, C.InformedConsent AS InformedConsentName, A.InformedConsent, 
		CASE WHEN ProfessionalSignature = 1 THEN 'Firmado' ELSE 'Sin firmar' END InformedConsentStatus
	FROM TR_ReqExam_InformConsent A
	INNER JOIN TB_Request B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_InformedConsent C
		ON C.IdInformedConsent = A.IdInformedConsent
	WHERE A.IdRequest = @IdRequest
		AND A.Active = 'True'
END
GO
