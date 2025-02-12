SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/04/2023
-- Description: Procedimiento almacenado para generar reporte de Odoo.
-- =============================================
--EXEC [Reports].[sp_Report_Odoo] '2023-06-21', 1
-- =============================================
CREATE PROCEDURE [Reports].[sp_Report_Odoo]
(
	@Date date,
	@IdPaymentMethod int
)
AS
	DECLARE @EndDate datetime
BEGIN
    SET NOCOUNT ON

	SET @EndDate = (dbo.FnS_GetPeriodEndDate(@Date))

	SELECT DISTINCT (CASE WHEN B.IdPaymentMethod = 1 THEN 'CAJA GENERAL'
						WHEN B.IdPaymentMethod = 2 THEN 'CONSIGNACIÓN TARJETAS'
						WHEN B.IdPaymentMethod = 3 THEN 'CLIENTE PAGO CONTADO' END) AS journal_id, 
		CONVERT(varchar(7), B.BillOfSalePaymentDate,21) AS period_id, F.ContractCode AS Ref, CONVERT(DATE,B.BillOfSalePaymentDate) AS Date,  
		H.InvoiceNumber AS Ref1,
		CASE WHEN B.IdPaymentMethod = 2 THEN Q.ApprovalNumber ELSE H.InvoiceNumber END AS Ref2, 
		L.UserName AS Ref3,
		CONCAT_WS(' ', I.AttentionCenterName, I.AttentionCenterCode) AS Name, 
		CASE WHEN E.IdAdmissionSource IN (4,5) THEN NULL WHEN E.IdAdmissionSource = 1 THEN E.IdPatient END AS IdPatient,	
		CASE WHEN C.IdThirdPerson IS NOT NULL THEN CONCAT_WS(' ', M.Name, M.LastName)
			WHEN E.IdPersonInCharge IS NOT NULL THEN O.FullName
			WHEN C.IdPatient IS NOT NULL THEN CONVERT(varchar(10),C.IdPatient) WHEN E.IdPatient IS NOT NULL THEN CONVERT(varchar(10),E.IdPatient) END Partner_id, 		
		CASE WHEN C.IdThirdPerson IS NOT NULL THEN N.IdentificationTypeCode 
			WHEN E.IdPersonInCharge IS NOT NULL THEN N2.IdentificationTypeCode
			WHEN C.IdPatient IS NOT NULL THEN CONVERT(varchar(10),C.IdPatient) WHEN E.IdPatient IS NOT NULL THEN CONVERT(varchar(10),E.IdPatient) END AS Tipo, 	
		CASE WHEN C.IdThirdPerson IS NOT NULL THEN 'Tercera persona' WHEN E.IdPersonInCharge IS NOT NULL THEN 'Acompañante' ELSE 'Paciente' END AS PersonType, 
		J.Account AS Account_id, CONVERT(DATE,@EndDate) As FechaVencimiento, B.PaymentValue AS Credit,
		H.InvoiceNumber AS Referencia_Conciliación
	FROM TB_BillingBox A
	INNER JOIN TB_BillOfSalePayment B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TR_BillingOfSale_Request D
		ON D.IdBillingOfSale = C.IdBillingOfSale
	INNER JOIN TB_Request E
		ON E.IdRequest = D.IdRequest
	INNER JOIN TB_Contract F
		ON F.IdContract = E.IdContract
	INNER JOIN TB_Company K
		ON K.IdCompany = F.IdCompany
	INNER JOIN TB_PaymentMethod G
		ON G.IdPaymentMethod = B.IdPaymentMethod
	INNER JOIN TB_ElectronicBilling H
		ON H.IdElectronicBilling = C.IdElectronicBilling
			AND H.IdInvoiceStatus != 3
	INNER JOIN TB_AttentionCenter I
		ON I.IdAttentionCenter = E.IdAttentionCenter
	INNER JOIN TB_User L
		ON L.IdUser = A.IdUser
	LEFT JOIN TB_BankAccount J
		ON J.IdBankAccount = B.IdBankAccount
	LEFT JOIN TB_ThirdPerson M
		ON M.IdThirdPerson = C.IdThirdPerson
	LEFT JOIN TB_IdentificationType N
		ON N.IdIdentificationType = M.IdIdentificationType
	LEFT JOIN TB_PersonInCharge O
		ON O.IdPersonInCharge = E.IdPersonInCharge
	LEFT JOIN TB_IdentificationType N2
		ON N2.IdIdentificationType = O.IdIdentificationType
	LEFT JOIN TB_TransactionalLog_CredBank Q
		ON Q.IdBillingOfSale = C.IdBillingOfSale
			AND Q.ApprovalNumber != ''
	WHERE F.IdContractType = 1
		AND CONVERT(date,B.BillOfSalePaymentDate) = @Date 
		AND G.IdPaymentMethod = @IdPaymentMethod

	UNION ALL

	SELECT DISTINCT (CASE WHEN B.IdPaymentMethod = 1 THEN 'CAJA GENERAL'
						WHEN B.IdPaymentMethod = 2 THEN 'CONSIGNACIÓN TARJETAS'
						WHEN B.IdPaymentMethod = 3 THEN 'CLIENTE PAGO CONTADO' END) AS journal_id, 
		CONVERT(varchar(7), B.BillOfSalePaymentDate,21) AS period_id, F.ContractCode AS Ref, CONVERT(DATE,B.BillOfSalePaymentDate) AS Date,  
		E.RequestNumber AS Ref1, 
		CASE WHEN B.IdPaymentMethod = 2 THEN Q.ApprovalNumber ELSE E.RequestNumber END AS Ref2, 
		L.UserName AS Ref3,
		CONCAT_WS(' ', I.AttentionCenterName, I.AttentionCenterCode) AS Name, 
		CASE WHEN E.IdAdmissionSource IN (4,5) THEN NULL WHEN E.IdAdmissionSource = 1 THEN E.IdPatient END AS IdPatient,
		K.CompanyName AS Partner_id, M.IdentificationTypeCode AS Tipo, 
		'Compañia' AS PersonType, 
		J.Account AS Account_id, CONVERT(DATE,@EndDate) As FechaVencimiento, B.PaymentValue AS Credit,
		E.RequestNumber AS Referencia_Conciliación
	FROM TB_BillingBox A
	INNER JOIN TB_BillOfSalePayment B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_BillingOfSale C
		ON C.IdBillingOfSale = B.IdBillingOfSale
	INNER JOIN TR_BillingOfSale_Request D
		ON D.IdBillingOfSale = C.IdBillingOfSale
	INNER JOIN TB_Request E
		ON E.IdRequest = D.IdRequest
	INNER JOIN TB_Contract F
		ON F.IdContract = E.IdContract
	INNER JOIN TB_Company K
		ON K.IdCompany = F.IdCompany
	INNER JOIN TB_IdentificationType M
		ON M.IdIdentificationType = K.IdIdentificationType
	INNER JOIN TB_PaymentMethod G
		ON G.IdPaymentMethod = B.IdPaymentMethod
	LEFT JOIN TB_ElectronicBilling H
		ON H.IdElectronicBilling = C.IdElectronicBilling
			AND H.IdInvoiceStatus != 3
	INNER JOIN TB_AttentionCenter I
		ON I.IdAttentionCenter = E.IdAttentionCenter
	INNER JOIN TB_User L
		ON L.IdUser = A.IdUser
	LEFT JOIN TB_BankAccount J
		ON J.IdBankAccount = B.IdBankAccount
	LEFT JOIN TB_TransactionalLog_CredBank Q
		ON Q.IdBillingOfSale = C.IdBillingOfSale
			AND Q.ApprovalNumber != ''
	WHERE F.IdContractType = 4
		AND CONVERT(date,B.BillOfSalePaymentDate) = @Date 
		AND G.IdPaymentMethod = @IdPaymentMethod

	UNION ALL
	
	SELECT DISTINCT (CASE WHEN B.IdPaymentMethod = 1 THEN 'CAJA GENERAL'
						WHEN B.IdPaymentMethod = 2 THEN 'CONSIGNACIÓN TARJETAS'
						WHEN B.IdPaymentMethod = 3 THEN 'CLIENTE PAGO CONTADO' END) AS journal_id, 
		CONVERT(varchar(7), B.CreationDate,21) AS period_id, F.ContractCode AS Ref, CONVERT(DATE,B.CreationDate) AS Date,  CONCAT_WS('-', K.NIT, F.ContractCode) AS Ref1, CONCAT_WS('-', K.NIT, F.ContractCode) AS Ref2, L.UserName AS Ref3,
		CONCAT_WS(' ', M.AttentionCenterName, M.AttentionCenterCode) AS Name, NULL, K.NIT AS Partner_id, D.IdentificationTypeCode AS Tipo, 'Compañia', J.Account AS Account_id, CONVERT(DATE,@EndDate) As FechaVencimiento, C.ContractAmount AS Credit,
		CONCAT_WS('-', K.NIT, F.ContractCode) AS Referencia_Conciliación
	FROM TB_BillingBox A
	INNER JOIN TB_InstallmentContract B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TR_InstallmentContract_Contract C
		ON C.IdInstallmentContract = B.IdInstallmentContract
	INNER JOIN TB_Contract F
		ON F.IdContract = C.IdContract
	INNER JOIN TB_Company K
		ON K.IdCompany = F.IdCompany
	INNER JOIN TB_IdentificationType D
		ON D.IdIdentificationType = K.IdIdentificationType
	INNER JOIN TB_PaymentMethod G
		ON G.IdPaymentMethod = B.IdPaymentMethod
	INNER JOIN TB_User L
		ON L.IdUser = A.IdUser
	INNER JOIN TB_AttentionCenter M
		ON M.IdAttentionCenter = A.IdAttentionCenter
	LEFT JOIN TB_BankAccount J
		ON J.IdBankAccount = B.IdBankAccount
	WHERE CONVERT(date,B.CreationDate)= @Date
		AND G.IdPaymentMethod = @IdPaymentMethod
		AND C.Active = 'True'
END
GO
