SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 07/09/2022
-- Description: Procedimientos almacenado para buscar factura electrónica.
-- =============================================
-- EXEC [sp_Consult_ElectronicBilling] '','','','','','','','','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ElectronicBilling]
(
	@InitialDate datetime,
	@FinalDate datetime, 
	@CompanyCode varchar(15),
	@CompanyName varchar(100),
	@IdIdentificationType varchar(2),
	@IdentificationNumber varchar(20),
	@Names varchar(120),
	@LastNames varchar(120),
	@IdPatient varchar(20),
	@InvoiceNumber varchar(15)
)
AS
	DECLARE @IdPatient1 varchar(100)
BEGIN
    SET NOCOUNT ON

	IF @IdPatient != ''
		BEGIN
			SET @IdPatient1 = REPLACE(@IdPatient,'''','')
		END
	ELSE
		BEGIN
			SET @IdPatient1 = CONCAT('',@IdPatient,'')
		END

	SELECT IdBillingOfSale, BillingOfSaleDate, InvoiceNumber, IdPatient, AdmissionSource, PatientName_Entity, PersonType, IdTransaction, IdTransactionStatus, TransactionStatus, IdInvoiceStatus, InvoiceStatus, IdContractType, TotalValueInvoice, PendingValuePayable, InvoiceFile,
		IdElectronicBilling, ElectronicBillingDate, ERPBillingDate, CreditNoteNumber, IdInvoiceStatusCN, IdBillingOfSaleStatus, ElectronicBillingActive, IdCancellationReason, PreBillingActive
	FROM (
		SELECT DISTINCT A.IdBillingOfSale, A.BillingOfSaleDate, EB.InvoiceNumber, 
			CASE WHEN R.IdAdmissionSource IN (4,5) THEN NULL WHEN R.IdAdmissionSource = 1 THEN R.IdPatient END AS IdPatient, L.AdmissionSource,
			CASE WHEN A.IdThirdPerson IS NOT NULL THEN CONCAT_WS(' ', G.Name, G.LastName) 
				WHEN R.IdPersonInCharge IS NOT NULL OR K.IdPersonInCharge IS NOT NULL THEN ISNULL(J.FullName, J2.FullName) ELSE CONVERT(varchar(10),A.IdPatient) END AS PatientName_Entity, 
			CASE WHEN A.IdThirdPerson IS NOT NULL THEN 'Tercera persona' WHEN R.IdPersonInCharge IS NOT NULL THEN 'Acompañante' ELSE 'Paciente' END AS PersonType, 
			EB.IdTransaction, EB.IdTransactionStatus, H.TransactionStatus, EB.IdInvoiceStatus, I.InvoiceStatus, C.IdContractType, EB.IdElectronicBilling, EB.InvoiceFile, EB.TotalValue AS TotalValueInvoice, A.TotalValuePatient - EB.TotalValue AS PendingValuePayable, EB.ElectronicBillingDate, EB.ERPBillingDate,
			M.CreditNoteNumber, M.IdInvoiceStatus AS IdInvoiceStatusCN, A.IdBillingOfSaleStatus, EB.Active AS ElectronicBillingActive, EB.IdCancellationReason, NULL AS PreBillingActive
		FROM TB_ElectronicBilling EB
		LEFT JOIN TB_BillingOfSale A
			ON EB.IdElectronicBilling = A.IdElectronicBilling
		INNER JOIN TR_BillingOfSale_Request B
			ON B.IdBillingOfSale = A.IdBillingOfSale
		INNER JOIN TB_Request R
			ON R.IdRequest = B.IdRequest
		INNER JOIN TB_AdmissionSource L 
			ON L.IdAdmissionSource = R.IdAdmissionSource
		LEFT JOIN TB_Contract C
			ON C.IdContract = R.IdContract
		LEFT JOIN TB_Company D
			ON  D.IdCompany = C.IdCompany
		LEFT JOIN TB_ThirdPerson G
			ON G.IdThirdPerson = A.IdThirdPerson
		LEFT JOIN TB_TransactionStatus H
			ON H.IdTransactionStatus = EB.IdTransactionStatus
		LEFT JOIN TB_InvoiceStatus I
			ON I.IdInvoiceStatus = EB.IdInvoiceStatus
		LEFT JOIN TB_PersonInCharge J
			ON J.IdPersonInCharge = R.IdPersonInCharge
		LEFT JOIN TR_Request_Patient K
			ON K.IdRequest = R.IdRequest
		LEFT JOIN TB_PersonInCharge J2
			ON J2.IdPersonInCharge = K.IdPersonInCharge
		LEFT JOIN TB_CreditNote M
			ON M.IdElectronicBilling = EB.IdElectronicBilling
		WHERE A.IdBillingOfSaleStatus IN (1,3,5,7) -- Estados: "Pagado", "Llego paciente", "Facturación Electrónica", "Anulada"
			AND C.IdContractType = 1
			AND ((CONVERT(varchar(10),A.BillingOfSaleDate,20) BETWEEN CONVERT(varchar(10),@InitialDate,20) AND CONVERT(varchar(10),@FinalDate,20))
					AND (@InitialDate != '' OR  @FinalDate != '') OR (@InitialDate = '' AND @FinalDate = ''))
			AND CASE WHEN @CompanyCode = '' THEN '' ELSE D.CompanyCode END = @CompanyCode
			AND CASE WHEN @CompanyName = '' THEN '' ELSE D.CompanyName END = @CompanyName
			AND CASE WHEN @IdPatient = '' THEN '' ELSE CONVERT(VARCHAR(50),A.IdPatient) END IN (@IdPatient1)
			AND CASE WHEN @InvoiceNumber = '' THEN '' ELSE EB.InvoiceNumber END = @InvoiceNumber

		UNION ALL

		SELECT DISTINCT A.IdPreBilling, A.PreBillingDate, EB.InvoiceNumber, NULL, NULL, D.CompanyName AS PatientName_Entity, 'Entidad-Tercero', 
				EB.IdTransaction, EB.IdTransactionStatus, H.TransactionStatus, EB.IdInvoiceStatus, I.InvoiceStatus, C.IdContractType, EB.IdElectronicBilling, EB.InvoiceFile, EB.TotalValue AS TotalValueInvoice, 
				SUM(F.TotalValueCompany) - EB.TotalValue AS PendingValuePayable, EB.ElectronicBillingDate, EB.ERPBillingDate,
				M.CreditNoteNumber, M.IdInvoiceStatus AS IdInvoiceStatusCN, F.IdBillingOfSaleStatus, EB.Active AS ElectronicBillingActive, EB.IdCancellationReason, A.Active AS PreBillingActive
		FROM TB_ElectronicBilling EB
		LEFT JOIN TB_PreBilling A
			ON EB.IdElectronicBilling = A.IdElectronicBilling
		LEFT JOIN TR_PreBilling_BillingOfSale E
			ON E.IdPreBilling = A.IdPreBilling
		LEFT JOIN TB_BillingOfSale F
			ON F.IdBillingOfSale = E.IdBillingOfSale
		LEFT JOIN TB_Contract C
			ON C.IdContract = A.IdContract
		LEFT JOIN TB_Company D
			ON  D.IdCompany = C.IdCompany
		LEFT JOIN TB_TransactionStatus H
			ON H.IdTransactionStatus = EB.IdTransactionStatus
		LEFT JOIN TB_InvoiceStatus I
			ON I.IdInvoiceStatus = EB.IdInvoiceStatus
		LEFT JOIN TB_CreditNote M
			ON M.IdElectronicBilling = EB.IdElectronicBilling
		WHERE C.IdContractType != 1
			AND ((CONVERT(varchar(10),PreBillingDate,20) BETWEEN CONVERT(varchar(10),@InitialDate,20) AND CONVERT(varchar(10),@FinalDate,20))
					AND (@InitialDate != '' OR  @FinalDate != '') OR (@InitialDate = '' AND @FinalDate = ''))
			AND CASE WHEN @CompanyCode = '' THEN '' ELSE D.CompanyCode END = @CompanyCode
			AND CASE WHEN @CompanyName = '' THEN '' ELSE D.CompanyName END = @CompanyName
			AND CASE WHEN @IdIdentificationType = '' THEN '' ELSE D.IdIdentificationType END = @IdIdentificationType
			AND CASE WHEN @IdentificationNumber = '' THEN '' ELSE D.NIT END = @IdentificationNumber
			AND CASE WHEN @Names = '' THEN '' ELSE D.CompanyName END LIKE '%'+@Names+'%'
			AND CASE WHEN @LastNames = '' THEN '' ELSE D.CompanyName END LIKE '%'+@LastNames+'%'
			AND CASE WHEN @InvoiceNumber = '' THEN '' ELSE EB.InvoiceNumber END = @InvoiceNumber
		GROUP BY A.IdPreBilling, A.PreBillingDate, EB.InvoiceNumber, D.CompanyName,	EB.IdTransaction, EB.IdTransactionStatus, H.TransactionStatus, EB.IdInvoiceStatus, I.InvoiceStatus, C.IdContractType, EB.IdElectronicBilling, EB.InvoiceFile, EB.TotalValue, EB.ElectronicBillingDate, EB.ERPBillingDate,
			M.CreditNoteNumber, M.IdInvoiceStatus, F.IdBillingOfSaleStatus, EB.Active, EB.IdCancellationReason, A.Active
	) SOURCE
	ORDER BY ElectronicBillingDate DESC
END
GO
