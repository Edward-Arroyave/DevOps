SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Paola Tellez Gonzalez
-- Create Date: 01/08/2023
-- Description: Procedimiento almacenado para listar los consentimientos informados para firmar.
-- =============================================
 /*
 EXEC [dbo].[sp_Consult_InformedConsentSignature] '','','','','',''
 */
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_InformedConsentSignature]
(
	@RequestNumber varchar(20),
	@IdPatient int,
	@InitialDate date,
	@FinalDate date,
	@Status varchar(1),
	@AttentionCenter varchar(20),
	@PageSize INT = 100,
	@NumberPage int = 1
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
	DECLARE @SKIPPEDROWS INT, @OriginalSize int
BEGIN
    SET NOCOUNT ON

	SET @OriginalSize = 200
	SET @SKIPPEDROWS = (@NumberPage-1)*@OriginalSize

	IF @InitialDate != '' AND @FinalDate != ''
		BEGIN
			SET @InitialDateTime = @InitialDate
			SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
		END
	ELSE
		BEGIN
			SET @InitialDateTime = '' 
			SET @FinalDateTime = ''
		END

	SELECT IdRequest, RequestNumber, RequestNumAlternative, AttentionCenterName, IdPatient, RequestDate, SignedDocuments, 
	CASE WHEN InformedConsentStatus = 1 THEN 'Firmado' ELSE 'Sin firmar' END AS InformedConsentStatus,
	COUNT(*) OVER () TotalRecords
	FROM (
			SELECT A.IdRequest, A.IdAttentionCenter, C.AttentionCenterName, A.RequestNumber, A.RequestNumAlternative, A.IdPatient, A.RequestDate, CONCAT(ProfessionalSignature, '-', PatientSignature) AS SignedDocuments, 
				CASE WHEN B.ProfessionalSignature != B.PatientSignature THEN 0 ELSE 1 END InformedConsentStatus
			FROM TB_Request A 
			INNER JOIN (
						SELECT IdRequest, COUNT(PatientSignature) AS PatientSignature, COUNT(CASE ProfessionalSignature WHEN 1 THEN 1 ELSE NULL END) AS ProfessionalSignature
						FROM TR_ReqExam_InformConsent
						WHERE Active = 'True'
						GROUP BY IdRequest
						) B
				ON B.IdRequest = A.IdRequest
			INNER JOIN TB_AttentionCenter C
				ON C.IdAttentionCenter = A.IdAttentionCenter
		) SOURCE
	WHERE (CASE WHEN @RequestNumber = '' THEN '' ELSE RequestNumber END = @RequestNumber
			OR CASE WHEN @RequestNumber = '' THEN '' ELSE RequestNumAlternative END = @RequestNumber)
		AND CASE WHEN @IdPatient = '' THEN '' ELSE IdPatient END = @IdPatient
		AND ((RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
								AND (@InitialDateTime != '' OR @FinalDateTime != '')   
									OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND CASE WHEN @Status = '' THEN '' ELSE InformedConsentStatus END = @Status
		AND CASE WHEN @AttentionCenter = '' THEN '' ELSE IdAttentionCenter END = @AttentionCenter
	ORDER BY RequestDate DESC

	OFFSET @SKIPPEDROWS ROWS
	FETCH NEXT @PageSize ROWS ONLY

END
GO
