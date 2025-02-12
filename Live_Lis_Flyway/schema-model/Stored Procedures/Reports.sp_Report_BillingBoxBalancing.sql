SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      WendyPaola Tellez Gonzalez
-- Create Date: 09/02/2023
-- Description: Procedimiento almacenado para consultar reporte de caja.
-- =============================================
-- EXEC [Reports].[sp_Report_BillingBoxBalancing] '2023-07-05','2023-07-07','',''
-- =============================================
CREATE PROCEDURE [Reports].[sp_Report_BillingBoxBalancing]
(
	@InitialDate date,
	@FinalDate date,
	@IdAttentionCenter VARCHAR(5),
	@BalancingStatus VARCHAR(1)
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
	
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

	SELECT DISTINCT D.RequestDate, M.InvoiceNumber, F.PaymentMethodName, B.ReferenceNumber_CUS, CONCAT_WS(' ', G.Name, G.LastName) AS Responsible,
		CASE WHEN C.IdPatient IS NOT NULL THEN CONVERT(varchar(5),C.IdPatient) ELSE CONCAT_WS(' ', I.Name, I.LastName) END AS PatientName,
		CASE WHEN C.IdPatient IS NOT NULL THEN CONVERT(varchar(5),C.IdPatient) ELSE I.IdentificationNumber END AS Identification, C.IdThirdPerson,
		J.ContractCode, J.ContractName, D.RequestNumber, C.TotalValuePatient AS TotalValue
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing E
		ON E.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_BillOfSalePayment B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TB_Request D
		ON D.IdRequest = C.IdRequest
	INNER JOIN TB_PaymentMethod F
		ON F.IdPaymentMethod = B.IdPaymentMethod
			AND F.IdPaymentMethod = E.IdPaymentMethod
	INNER JOIN TB_User G
		ON G.IdUser	= A.IdUser
	INNER JOIN TB_Contract J
		ON J.IdContract = D.IdContract
	LEFT JOIN TR_PreBilling_BillingOfSale K
		ON K.IdBillingOfSale = C.IdBillingOfSale
	LEFT JOIN TB_PreBilling L
		ON L.IdPreBilling = K.IdPreBilling
	LEFT JOIN TB_ElectronicBilling M
		ON M.IdElectronicBilling = L.IdElectronicBilling
			OR M.IdElectronicBilling = C.IdElectronicBilling
	LEFT JOIN TB_ThirdPerson I
		ON I.IdThirdPerson = C.IdThirdPerson 
	WHERE B.Active = 'True'
		AND A.BillingBoxStatus = 0
		AND ((A.ClosingDate BETWEEN @InitialDateTime AND @FinalDateTime)
		AND (@InitialDateTime != '' OR @FinalDateTime != '')
			OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND CASE WHEN @IdAttentionCenter = '' THEN '' ELSE A.IdAttentionCenter END = @IdAttentionCenter
		AND CASE WHEN @BalancingStatus = '' THEN '' ELSE A.BalancingStatus END = @BalancingStatus

	UNION ALL

	SELECT DISTINCT B.CreationDate, B.InstallmentContractNumber, D.PaymentMethodName, B.ReferenceNumber, CONCAT_WS(' ', F.Name, F.LastName) AS Responsible,
		G.CompanyName, G.NIT, ' ', J.ContractCode, J.ContractName, B.InstallmentContractNumber, C.ContractAmount
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing E
		ON E.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_InstallmentContract B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TR_InstallmentContract_Contract C
		ON C.IdInstallmentContract = B.IdInstallmentContract
	INNER JOIN TB_Contract J
		ON J.IdContract = C.IdContract
	INNER JOIN TB_Company G
		ON G.IdCompany = J.IdCompany
	INNER JOIN TB_PaymentMethod D
		ON D.IdPaymentMethod = B.IdPaymentMethod
			AND D.IdPaymentMethod = B.IdPaymentMethod
	INNER JOIN TB_User F
		ON F.IdUser = A.IdUser
	WHERE C.Active = 'True'
		AND A.BillingBoxStatus = 0
		AND ((B.CreationDate BETWEEN @InitialDateTime AND @FinalDateTime)
		AND (@InitialDateTime != '' OR @FinalDateTime != '')
			OR (@InitialDateTime = '' AND @FinalDateTime = ''))
		AND CASE WHEN @IdAttentionCenter = '' THEN '' ELSE A.IdAttentionCenter END = @IdAttentionCenter
		AND CASE WHEN @BalancingStatus = '' THEN '' ELSE A.BalancingStatus END = @BalancingStatus
END
GO
