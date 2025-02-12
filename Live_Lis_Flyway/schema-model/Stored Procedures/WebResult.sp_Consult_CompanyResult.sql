SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/09/2023
-- Description: Procedimiento almacenado para consultar lo resultados de pacientes en contratos asociados a un tercero.
-- =============================================
-- EXEC [WebResult].[sp_Consult_CompanyResult] 1058,'','','','','','',''
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Consult_CompanyResult]
(
	@IdCompanyUser int,
	@IdContract varchar(50),
	@IdAttentionCenter varchar(10),
	@RequestNumber varchar(15),
	@IdentificationNumber varchar(20),
	@InitialDate date,
	@FinalDate date, 
	@RequestStatus varchar(1)
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime, @IdCompany int
BEGIN
    SET NOCOUNT ON

	SET @IdCompany = (SELECT IdCompany FROM TB_User WHERE IdUser = @IdCompanyUser)

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
		
	SELECT IdRequest, IdContract, ContractName, RequestDate, RequestNumber, IdPatient, PatientName, IdAttentionCenter, AttentionCenterName,
		CASE WHEN IdRequestStatus = 1 THEN 'En espera de resultados'
			WHEN IdRequestStatus = 2 THEN 'Resultados parciales'
			WHEN IdRequestStatus = 3 THEN 'Finalizados' END AS RequestStatus
	FROM (
		SELECT A.IdRequest, A.IdContract, CONCAT(C.ContractCode, ' - ', C.ContractName) AS ContractName, F.WaitingResult, F.PartialResult, F.FinishedResult, A.RequestDate, A.RequestNumber, A.IdPatient, G.IdentificationNumber, CONCAT_WS(' ', H.IdentificationTypeCode, G.IdentificationNumber, G.FirstName, G.SecondName, G.FirstLastName, G.SecondLastName) AS PatientName, A.IdAttentionCenter, D.AttentionCenterName,
			CASE WHEN A.IdRequestStatus IN (3,4,5) THEN 1
				WHEN A.IdRequestStatus IN (1,6) THEN 2
				WHEN A.IdRequestStatus IN (9,10) THEN 3 END AS IdRequestStatus
		FROM TB_Request A
		INNER JOIN TB_RequestStatus B
			ON B.IdRequestStatus = A.IdRequestStatus
		INNER JOIN TB_Contract C
			ON C.IdContract = A.IdContract
		INNER JOIN TB_AttentionCenter D
			ON D.IdAttentionCenter = A.IdAttentionCenter
		INNER JOIN TB_Company E
			ON E.IdCompany = C.IdCompany
		INNER JOIN TR_User_Contract F
			ON F.IdContract = C.IdContract
		INNER JOIN carehis.TB_Patient_Ext G
			ON G.IdPatient = A.IdPatient
		INNER JOIN carehis.TB_IdentificationType_Ext H
			ON H.IdIdentificationType = G.IdIdentificationType
		WHERE C.IdCompany = @IdCompany
			AND F.IdUser = @IdCompanyUser
			AND F.Active = 'True'
		) SOURCE
	WHERE (CASE WHEN WaitingResult = 'True' THEN IdRequestStatus END = 1
			OR CASE WHEN PartialResult = 'True' THEN IdRequestStatus END = 2
			OR CASE WHEN FinishedResult = 'True' THEN IdRequestStatus END = 3)
		AND CASE WHEN @IdContract = '' THEN '' ELSE IdContract END = @IdContract
		AND CASE WHEN @IdAttentionCenter = '' THEN '' ELSE IdAttentionCenter END = @IdAttentionCenter
		AND CASE WHEN @RequestNumber = '' THEN '' ELSE RequestNumber END = @RequestNumber
		AND CASE WHEN @IdentificationNumber = '' THEN '' ELSE IdentificationNumber END = @IdentificationNumber
		AND ((RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
			AND (@InitialDateTime != '' OR @FinalDateTime != '')
				OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND CASE WHEN @RequestStatus = '' THEN '' ELSE IdRequestStatus END = @RequestStatus
	ORDER BY 4 DESC

END
GO
