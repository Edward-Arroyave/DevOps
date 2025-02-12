SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/05/2022
-- Description: Procedimiento almacenado para generar reporte "Registro de Caja"
-- =============================================
-- EXEC [Reports].[sp_BillingBox_Registration] '2023-07-01','2023-10-15'
-- =============================================
CREATE PROCEDURE [Reports].[sp_BillingBox_Registration]
(
	@InitialDate date,
	@FinalDate date
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime
BEGIN
    SET NOCOUNT ON

	SET @InitialDateTime = @InitialDate
	SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))

	SELECT F.AttentionCenterName, E.RequestNumber, E.RequestNumAlternative, G.ContractCode, G.ContractName, 
		CASE WHEN E.IdAdmissionSource IN (4,5) THEN NULL WHEN E.IdAdmissionSource = 1 THEN E.IdPatient END AS IdPatient,	
		CASE WHEN C.IdThirdPerson IS NOT NULL THEN 'Tercera persona' WHEN E.IdPersonInCharge IS NOT NULL THEN 'Acompañante' ELSE 'Paciente' END AS PersonType, 
		CASE WHEN C.IdThirdPerson IS NOT NULL THEN N.IdentificationTypeCode 
			WHEN E.IdPersonInCharge IS NOT NULL THEN N2.IdentificationTypeCode
			WHEN C.IdPatient IS NOT NULL THEN CONVERT(varchar(10),C.IdPatient) WHEN E.IdPatient IS NOT NULL THEN CONVERT(varchar(10),E.IdPatient) END AS Tipo,
		CASE WHEN C.IdThirdPerson IS NOT NULL THEN  M.IdentificationNumber
			WHEN E.IdPersonInCharge IS NOT NULL THEN O.IdentificationNumber
			WHEN C.IdPatient IS NOT NULL THEN CONVERT(varchar(10),C.IdPatient) WHEN E.IdPatient IS NOT NULL THEN CONVERT(varchar(10),E.IdPatient) END AS IdentificationNumber,
		CASE WHEN C.IdThirdPerson IS NOT NULL THEN CONCAT_WS(' ', M.Name, M.LastName)
			WHEN E.IdPersonInCharge IS NOT NULL THEN O.FullName
			WHEN C.IdPatient IS NOT NULL THEN CONVERT(varchar(10),C.IdPatient) WHEN E.IdPatient IS NOT NULL THEN CONVERT(varchar(10),E.IdPatient) END Partner_id, 		
		E.RequestDate, '' AS InstallmentConcept, H.PaymentMethodName,
		CONCAT(I.NIT, '-', I.VerificationDigit) AS NIT, 
		CASE WHEN G.IdContractType = 1 THEN 'Contado' ELSE 'Cuenta' END AS AccountantAccount, B.PaymentValue, 0 AS Discount, J.UserName, L.ApprovalNumber,
		CASE WHEN G.IdContractType = 1 THEN K.InvoiceNumber ELSE E.RequestNumber END AS DepositNumber, 
		CASE WHEN B.Active = 1 THEN 'ACEPTADO' ELSE 'ANULADO' END AS PaymentStatus,
		CASE 
			WHEN G.IdContractType = 1 THEN 'Facturación particular'
			WHEN G.IdContractType = 2 OR (G.IdContractType = 4 AND G.IdGenerateCopay_CM = 1) THEN 'Cuenta'
			WHEN G.IdContractType = 4 AND G.IdGenerateCopay_CM != 1 THEN 'Copago'
			ELSE 'Contado'
		END Concept
	FROM TB_BillingBox A
	INNER JOIN TB_BillOfSalePayment B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TR_BillingOfSale_Request D
		ON D.IdBillingOfSale = C.IdBillingOfSale
	INNER JOIN TB_Request E
		ON E.IdRequest = D.IdRequest
	INNER JOIN TB_AttentionCenter F
		ON F.IdAttentionCenter = A.IdAttentionCenter
	INNER JOIN TB_Contract G
		ON G.IdContract = E.IdContract
	INNER JOIN TB_PaymentMethod H
		ON H.IdPaymentMethod = B.IdPaymentMethod
	INNER JOIN TB_Company I
		ON I.IdCompany = G.IdCompany
	INNER JOIN TB_User J
		ON J.IdUser = A.IdUser
	LEFT JOIN TB_TransactionalLog_CredBank L
		ON L.IdBillingOfSale = C.IdBillingOfSale
	LEFT JOIN TB_ElectronicBilling K
		ON K.IdElectronicBilling = C.IdElectronicBilling
	LEFT JOIN TB_ThirdPerson M
		ON M.IdThirdPerson = C.IdThirdPerson
	LEFT JOIN TB_PersonInCharge O
		ON O.IdPersonInCharge = E.IdPersonInCharge
	LEFT JOIN TB_IdentificationType N
		ON N.IdIdentificationType = M.IdIdentificationType
	LEFT JOIN TB_IdentificationType N2
		ON N2.IdIdentificationType = O.IdIdentificationType
	WHERE A.OpeningDate BETWEEN @InitialDateTime AND @FinalDateTime
	
	UNION ALL
	
	SELECT C.AttentionCenterName, B.InstallmentContractNumber, NULL, E.ContractCode, E.ContractName, NULL, 'Tercero - Empresa',I.IdentificationTypeCode, H.NIT, H.CompanyName, B.CreationDate, '', F.PaymentMethodName, CONCAT(H.NIT, '-', H.VerificationDigit) AS NIT,
		CASE WHEN E.IdContractType = 1 THEN 'Contado' ELSE 'Cuenta' END AS AccountantAccount, D.ContractAmount, 0, G.UserName, NULL, B.InstallmentContractNumber,
		CASE WHEN B.Active = 1 THEN 'ACEPTADO' ELSE 'ANULADO' END AS PaymentStatus,
		CASE 
			WHEN E.IdContractType = 1 THEN 'Facturación particular'
			WHEN E.IdContractType = 2 OR (E.IdContractType = 4 AND E.IdGenerateCopay_CM = 1) THEN 'Cuenta'
			WHEN E.IdContractType = 2 AND E.IdGenerateCopay_CM != 1 THEN 'Copago'
			ELSE 'Contado'
		END Concept
	FROM TB_BillingBox A
	INNER JOIN TB_InstallmentContract B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_AttentionCenter C
		ON C.IdAttentionCenter = A.IdAttentionCenter
	INNER JOIN TR_InstallmentContract_Contract D
		ON D.IdInstallmentContract = B.IdInstallmentContract
	INNER JOIN TB_Contract E
		ON E.IdContract = D.IdContract
	INNER JOIN TB_PaymentMethod F
		ON F.IdPaymentMethod = B.IdPaymentMethod
	INNER JOIN TB_User G
		ON G.IdUser = A.IdUser
	INNER JOIN TB_Company H
		ON H.IdCompany = E.IdCompany
	INNER JOIN TB_IdentificationType I
		ON I.IdIdentificationType = H.IdIdentificationType
	WHERE A.OpeningDate BETWEEN @InitialDateTime AND @FinalDateTime
END
GO
