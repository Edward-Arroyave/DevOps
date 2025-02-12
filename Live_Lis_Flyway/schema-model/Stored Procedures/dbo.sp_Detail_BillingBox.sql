SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/02/2023
-- Description: Procedimiento almacenado para consultar información detallada de movimientos de caja.
-- =============================================
--EXEC [sp_Detail_BillingBox] 141
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_BillingBox]
(
	@IdBillingBox int
)
AS
	DECLARE @IdPaymentMethod int
BEGIN
    SET NOCOUNT ON

	SET @IdPaymentMethod = (SELECT IdPaymentMethod FROM TB_PaymentMethod WHERE PaymentMethodName = 'Base caja')

	SELECT DISTINCT A.IdBillingBox, B.IdPaymentMethod, C.PaymentMethodName, E.BillingOfSaleDate,  
		G.InvoiceNumber, E.RequestNumber AS ProofOfPayment, ISNULL(E.IdPatient, E.IdThirdPerson) IdPatient, 
		ISNULL(CONVERT(VARCHAR(10),E.IdPatient),
		CONCAT_WS(' ',TI2.IdentificationTypeCode, '-', T.IdentificationNumber, T.Name, T.LastName)) Patient,
		D.PaymentValue AS TotalValuePatient
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_BillOfSalePayment D
		ON D.IdBillingBox = A.IdBillingBox
			AND D.IdPaymentMethod = B.IdPaymentMethod
	INNER JOIN TB_PaymentMethod C
		ON C.IdPaymentMethod = B.IdPaymentMethod
	LEFT JOIN TB_BillingOfSale E
		ON E.IdBillingOfSale = D.IdBillingOfSale
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = E.IdElectronicBilling
	LEFT JOIN TB_ThirdPerson T
		ON T.IdThirdPerson = E.IdThirdPerson
	LEFT JOIN TB_IdentificationType TI2
		ON TI2.IdIdentificationType = T.IdIdentificationType
	WHERE A.IdBillingBox = @IdBillingBox	
	GROUP BY A.IdBillingBox, B.IdPaymentMethod, C.PaymentMethodName, E.BillingOfSaleDate, G.InvoiceNumber, E.RequestNumber, E.IdPatient, E.IdThirdPerson, 
		TI2.IdentificationTypeCode, T.IdentificationNumber, T.Name, T.LastName, D.PaymentValue

	UNION ALL

	SELECT A.IdBillingBox, C.IdPaymentMethod, D.PaymentMethodName, B.CreationDate, B.InstallmentContractNumber, NULL AS ProofOfPayment, G.IdContract, F.CompanyName, G.ContractAmount
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing C
		ON C.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_InstallmentContract B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_PaymentMethod D
		ON D.IdPaymentMethod = C.IdPaymentMethod
			AND D.IdPaymentMethod = B.IdPaymentMethod
	INNER JOIN TR_InstallmentContract_Contract G
		ON G.IdInstallmentContract = B.IdInstallmentContract
	INNER JOIN TB_Contract E
		ON E.IdContract = G.IdContract
	INNER JOIN TB_Company F
		ON F.IdCompany = E.IdCompany
	WHERE A.IdBillingBox = @IdBillingBox
END
GO
