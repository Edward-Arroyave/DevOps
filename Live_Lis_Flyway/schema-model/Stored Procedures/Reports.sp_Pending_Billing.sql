SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 11/05/2022
-- Description: Procedimiento almacenado para generar reporte de "Pendiente Facturar".
-- =============================================
-- EXEC [Reports].[sp_Pending_Billing] '2023-07-06','2023-07-06'
-- =============================================
CREATE PROCEDURE [Reports].[sp_Pending_Billing]
(
	@InitialDate date,
	@FinalDate date
)
AS
	DECLARE @InitialDateTime datetime, @FinalDateTime datetime, @ConsultSQL NVARCHAR(4000), @Contract varchar(50)
BEGIN
    SET NOCOUNT ON

	SET @InitialDateTime = @InitialDate
	SET @FinalDateTime = DATEADD(DAY,1,DATEADD(SECOND,-1,CONVERT(datetime,@FinalDate)))
	
	SET @ConsultSQL = 'SELECT CONVERT(varchar(6), A.RequestDate,112) AS Month, CONVERT(varchar(10), A.RequestDate,112) AS Prefijo, A.IdPatient, A.RequestDate, E.CompanyName, CONCAT(E.NIT, ''-'', E.VerificationDigit) AS NIT,
							STUFF((SELECT '','' + G.PaymentMethodName
									FROM TB_BillOfSalePayment F
									INNER JOIN TB_PaymentMethod G
										ON G.IdPaymentMethod = F.IdPaymentMethod
									WHERE F.IdBillingOfSale = C.IdBillingOfSale
									FOR XML PATH('''')),1,1,'''') AS PaymentMethodName, 
							STUFF((SELECT '','' + H.Account
									FROM TB_BillOfSalePayment F
									INNER JOIN TB_BankAccount H
										ON H.IdBankAccount = F.IdBankAccount
									WHERE F.IdBillingOfSale = C.IdBillingOfSale
									FOR XML PATH('''')),1,1,'''') AS Account,
							I.CommercialZoneName, '''' AS SellerCode, M.CityName, 
							CASE WHEN D.IdContractType = 1 THEN ISNULL(C.TotalValuePatient,0) ELSE ISNULL(C.TotalValueCompany,0) END AS TotalValue, 
							D.IdContract, D.ContractName, J.ContractDeadline, K.InvoiceNumber
						FROM TB_Request A
						INNER JOIN TR_BillingOfSale_Request B
							ON B.IdRequest = A.IdRequest
						INNER JOIN TB_BillingOfSale C
							ON C.IdBillingOfSale = B.IdBillingOfSale
						INNER JOIN TB_Contract D
							ON D.IdContract = A.IdContract
						INNER JOIN TB_Company E
							ON E.IdCompany = D.IdCompany
						INNER JOIN TB_BillOfSalePayment F
							ON F.IdBillingOfSale = C.IdBillingOfSale
						INNER JOIN TB_BillingBox N
							ON N.IdBillingBox = F.IdBillingBox
						INNER JOIN TB_AttentionCenter L
							ON L.IdAttentionCenter = A.IdAttentionCenter
						INNER JOIN TB_City M
							ON M.IdCity = L.IdCity
						LEFT JOIN TB_BankAccount H
							ON H.IdBankAccount = F.IdBankAccount
						LEFT JOIN TB_CommercialZone I
							ON I.IdCommercialZone = E.IdCommercialZone
						LEFT JOIN TB_ContractDeadline J
							ON J.IdContractDeadline = D.IdContractDeadline
						LEFT JOIN TB_ElectronicBilling K
							ON K.IdElectronicBilling = C.IdElectronicBilling
						WHERE K.InvoiceNumber IS NULL
							AND F.Active = ''True''
							AND CONVERT(varchar(25),A.RequestDate,20) BETWEEN '''+CONVERT(varchar(25),@InitialDateTime,20)+''' AND '''+CONVERT(varchar(25),@FinalDateTime,20)+'''
						ORDER BY 1'

	EXEC (@ConsultSQL)
END
GO
