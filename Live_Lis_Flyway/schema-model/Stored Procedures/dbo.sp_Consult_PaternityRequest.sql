SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/04/2023
-- Description: Procedimiento almacenado para consultar solicitudes de paternidad.
-- =============================================
-- EXEC [sp_Consult_PaternityRequest] 2,'','','','','','','3695',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_PaternityRequest]
(
	@Source int,
	@InitialDate date,
	@FinalDate date,
	@RequestNumber varchar(15),
	@RequestStatus varchar(5),
	@RequestType varchar(1),
	@InvoiceNumber varchar(15),
	@IdExam varchar(10),
	@IdUser int,
	@IdAttentionCenter int = NULL,
	@IdOrigin int = ''
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

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
	
	--- Consulta Gestión de Solicitudes	
	IF @Source = 1
		BEGIN
			SELECT A.IdRequest, C.IdBillingOfSale, A.RequestNumber, D.InvoiceNumber, A.RequestDate, 
				CASE WHEN A.AuthorityRequest = 'True' THEN 'Autoridad' WHEN A.AuthorityRequest = 'False' THEN 'Particular' END AS RequestType, 
				A.IdRequestStatus, E.RequestStatus, D.InvoiceFile, D.IdTransactionStatus, F.TransactionStatus, A.IdAttentionCenter, G.AttentionCenterName
			FROM TB_Request A
			INNER JOIN TR_BillingOfSale_Request B
				ON B.IdRequest = A.IdRequest
			INNER JOIN TB_BillingOfSale C
				ON C.IdBillingOfSale = B.IdBillingOfSale
			INNER JOIN TB_RequestStatus E
				ON E.IdRequestStatus = A.IdRequestStatus
			LEFT JOIN TB_ElectronicBilling D
				ON D.IdElectronicBilling = C.IdElectronicBilling
			LEFT JOIN TB_TransactionStatus F
				ON F.IdTransactionStatus = D.IdTransactionStatus
			INNER JOIN TB_AttentionCenter G
				ON A.IdAttentionCenter = G.IdAttentionCenter
			WHERE A.IdAdmissionSource = 5
				AND ((A.RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
					AND (@InitialDateTime != '' OR @FinalDateTime != '')
						OR (@InitialDateTime = '' AND @FinalDateTime = ''))
					AND (CASE WHEN @RequestNumber = '' THEN '' ELSE A.RequestNumber END LIKE '%'+@RequestNumber+'%')
					AND (CASE WHEN @InvoiceNumber = '' THEN '' ELSE D.InvoiceNumber END LIKE '%'+@InvoiceNumber+'%')
					AND (CASE WHEN @RequestType = '' THEN '' ELSE A.AuthorityRequest END) = @RequestType
					AND CASE WHEN @RequestStatus = '' THEN '' ELSE A.IdRequestStatus END = @RequestStatus
					AND CASE WHEN @IdOrigin = '' THEN '' ELSE A.IdOrigin END = @IdOrigin
				AND (@IdAttentionCenter is null or A.IdAttentionCenter = @IdAttentionCenter)
			ORDER BY A.RequestDate DESC
		END
	-- Consulta Cargue de Resultados
	ELSE IF @Source = 2
		BEGIN
			SELECT A.IdRequest, A.RequestNumber, A.RequestDate, 
				CASE WHEN A.AuthorityRequest = 'True' THEN 'Autoridad' WHEN A.AuthorityRequest = 'False' THEN 'Particular' END AS RequestType,
				C.IdExam, D.ExamName, B.IdResultPaterReqStatus, E.ResultPaterReqStatus, B.Confirmation, B.ConfirmationDate, A.IdAttentionCenter, G.AttentionCenterName
			FROM TB_Request A
			INNER JOIN TB_ResultPaternityRequest B
				ON B.IdRequest = A.IdRequest
			INNER JOIN TR_Request_Exam C
				ON C.IdRequest = A.IdRequest
			INNER JOIN TB_Exam D
				ON D.IdExam = C.IdExam
			INNER JOIN TB_ResultPaterReqStatus E
				ON E.IdResultPaterReqStatus = B.IdResultPaterReqStatus
			INNER JOIN (SELECT IdRequest, MAX(CONVERT(int,Titular)) AS Titular
						FROM TR_Request_Patient
						GROUP BY IdRequest) F
				ON F.IdRequest = A.IdRequest
			INNER JOIN TB_AttentionCenter G
				ON A.IdAttentionCenter = G.IdAttentionCenter
			WHERE F.Titular = 1
				AND ((A.RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
					AND (@InitialDateTime != '' OR @FinalDateTime != '')
						OR (@InitialDateTime = '' AND @FinalDateTime = ''))
					AND (CASE WHEN @RequestNumber = '' THEN '' ELSE A.RequestNumber END LIKE '%'+@RequestNumber+'%')
					AND (CASE WHEN @RequestType = '' THEN '' ELSE A.AuthorityRequest END) = @RequestType
					AND (CASE WHEN @IdExam = '' THEN '' ELSE C.IdExam END) = @IdExam
					AND CASE WHEN @RequestStatus = '' THEN '' ELSE B.IdResultPaterReqStatus END = @RequestStatus
					AND CASE WHEN @IdOrigin = '' THEN '' ELSE A.IdOrigin END = @IdOrigin
				AND (@IdAttentionCenter is null or A.IdAttentionCenter = @IdAttentionCenter)
			ORDER BY A.RequestDate DESC
		END
	--- Consulta de Resultados
	ELSE IF @Source = 3
		BEGIN
			SELECT DISTINCT A.IdRequest, A.RequestNumber, A.RequestDate, 
				CASE WHEN A.AuthorityRequest = 'True' THEN 'Autoridad' WHEN A.AuthorityRequest = 'False' THEN 'Particular' END AS RequestType,
				A.IdRequestStatus, C.RequestStatus, CONCAT('Enviados - ', B.SendNotification) AS SendNotification, CONCAT('Enviados - ', B.SendResults) AS SendMail
				, A.IdAttentionCenter, G.AttentionCenterName
			FROM TB_Request A
			INNER JOIN TB_ResultPaternityRequest B
				ON B.IdRequest = A.IdRequest
			INNER JOIN TB_RequestStatus C
				ON C.IdRequestStatus = A.IdRequestStatus
			INNER JOIN TB_AttentionCenter G
				ON A.IdAttentionCenter = G.IdAttentionCenter
			WHERE C.IdRequestStatus IN (1,6)
				AND B.IdResultPaterReqStatus IN (2,3)
				AND ((A.RequestDate BETWEEN @InitialDateTime AND @FinalDateTime)
					AND (@InitialDateTime != '' OR @FinalDateTime != '')
						OR (@InitialDateTime = '' AND @FinalDateTime = ''))
					AND (CASE WHEN @RequestNumber = '' THEN '' ELSE A.RequestNumber END LIKE '%'+@RequestNumber+'%')
					AND (CASE WHEN @RequestType = '' THEN '' ELSE A.AuthorityRequest END) = @RequestType
					AND CASE WHEN @RequestStatus = '' THEN '' ELSE A.IdRequestStatus END = @RequestStatus
					AND CASE WHEN @IdOrigin = '' THEN '' ELSE A.IdOrigin END = @IdOrigin
				AND (@IdAttentionCenter is null or A.IdAttentionCenter = @IdAttentionCenter)
			ORDER BY A.RequestDate DESC
		END

	INSERT INTO History.TH_ConsultPaternityRequest (InitialDate, FinalDate, RequestNumber, IdRequestStatus, IdRequestType, InvoiceNumber, IdExam, IdUser)
	VALUES (CASE WHEN @InitialDate = '' THEN NULL ELSE @InitialDate END, CASE WHEN @FinalDate = '' THEN NULL ELSE @FinalDate END, CASE WHEN @RequestNumber = '' THEN NULL ELSE @RequestNumber END, CASE WHEN @RequestStatus = '' THEN NULL ELSE @RequestStatus END, CASE WHEN @RequestType = '' THEN NULL ELSE @RequestType END, CASE WHEN @InvoiceNumber = '' THEN NULL ELSE @InvoiceNumber END, @IdExam, @IdUser)
END
GO
