SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/09/2022
-- Description: Procedimiento almacenado para consultar solicitudes.
-- =============================================
/*
EXEC [sp_Consult_Request] '','','','','2024083005739','','','','',200,1
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Request]
(
	@IdIdentificationType int,
	@IdentificationNumber varchar(100),
	@InitialDate datetime,
	@FinalDate datetime,
	@RequestNumber varchar(15),
	@RequestNumAlternative varchar (20) = '',
	@RequestStatus varchar(5),
	@Received varchar(1),
	@AttentionCenter varchar(5),
	@PageSize INT = 100,
	@NumberPage int = 1
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
	declare @SKIPPEDROWS INT, @OriginalSize int
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

		select IdentificationNumber,IdPatient, IdIdentificationType,FirstName, SecondName, FirstLastName, SecondLastName 
		into #Patient
		from carehis.TB_Patient_Ext
		
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 06/02/2024
-- Se quita el top en la consulta debido a agregacion de paginacion de resultados y se agrega a la consulta COUNT(*) OVER () TotalRecords
-- Pruebas:		Realizadas con El Inge Willinton Morales
-- Antes:	SELECT TOP 1000 A.IdRequest,
-- Ahora:	SELECT A.IdRequest,
-- =============================================

	SELECT  A.IdRequest, A.IdAdmissionSource, G.AdmissionSource, A.RequestNumber, A.RequestNumAlternative, I.AttentionCenterName, A.IdPatient, A.RequestDate, 
	F.InvoiceNumber, E.ContractCode, D.RequestStatus,		CONCAT_WS('', J.FirstName, ' ', J.SecondName, ' ', J.FirstLastName, ' ', J.SecondLastName) AS PatientName, 
	CONCAT_WS('',K.IdentificationTypeCode,' - ',J.IdentificationNumber) AS IdentificationNumber, IdDoctor, A.ReceiptDate, A.RecoveryFee,
		CASE WHEN MIN(DISTINCT H.Received) = 1 THEN 1 ELSE 0 END AS Received, COUNT(*) OVER () TotalRecords
	FROM TB_Request A
	INNER JOIN TR_BillingOfSale_Request B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TB_RequestStatus D
		ON D.IdRequestStatus = A.IdRequestStatus
	INNER JOIN TB_Contract E
		ON E.IdContract = A.IdContract
	INNER JOIN TB_AdmissionSource G
		ON G.IdAdmissionSource = A.IdAdmissionSource
	INNER JOIN TB_AttentionCenter I
		ON I.IdAttentionCenter = ISNULL(A.IdAttentionCenterOrigin,A.IdAttentionCenter)
	INNER JOIN #Patient J
		ON J.IdPatient = A.IdPatient
	INNER JOIN TB_IdentificationType K
		ON K.IdIdentificationType = J.IdIdentificationType
	LEFT JOIN TB_ElectronicBilling F
		ON F.IdElectronicBilling = C.IdElectronicBilling
	LEFT JOIN (
				SELECT DISTINCT IdRequest,
					CASE WHEN IdSampleRegistrationStatus = 1 THEN 1 ELSE 0 END Received
				FROM TB_SampleRegistration 
				GROUP BY IdRequest, IdSampleRegistrationStatus
				) H
		ON H.IdRequest = A.IdRequest
	WHERE A.IdAdmissionSource != 5
		AND CASE WHEN @IdentificationNumber = '' THEN '' ELSE J.IdentificationNumber END = @IdentificationNumber
		AND CASE WHEN @IdIdentificationType = '' THEN '' ELSE J.IdIdentificationType END = @IdIdentificationType
		AND ((A.RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
		AND (@InitialDateTime != '' OR @FinalDateTime != '')
			OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND ((CASE WHEN @RequestNumber = '' THEN '' ELSE A.RequestNumber END LIKE '%'+@RequestNumber+'%')
			OR (CASE WHEN @RequestNumber = '' THEN '' ELSE F.InvoiceNumber END LIKE '%'+@RequestNumber+'%'))
		AND (CASE WHEN @RequestNumAlternative = '' THEN '' ELSE A.RequestNumAlternative END LIKE '%'+@RequestNumAlternative+'%')
		AND CASE WHEN @RequestStatus = '' THEN '' ELSE A.IdRequestStatus END = @RequestStatus
		AND CASE WHEN @Received = '' THEN '' ELSE H.Received END = @Received
		AND CASE WHEN @AttentionCenter = '' THEN '' ELSE ISNULL(A.IdAttentionCenterOrigin,A.IdAttentionCenter) END = @AttentionCenter
	GROUP BY A.IdRequest, A.IdAdmissionSource, G.AdmissionSource, A.RequestNumber, A.RequestNumAlternative, I.AttentionCenterName, A.IdPatient, A.RequestDate, F.InvoiceNumber, E.ContractCode, D.RequestStatus,
			 J.FirstName, J.SecondName, J.FirstLastName, J.SecondLastName, K.IdentificationTypeCode, J.IdentificationNumber, IdDoctor, A.ReceiptDate, A.RecoveryFee
	ORDER BY A.RequestDate DESC

	OFFSET @SKIPPEDROWS ROWS
	FETCH NEXT @PageSize ROWS ONLY

END
GO
