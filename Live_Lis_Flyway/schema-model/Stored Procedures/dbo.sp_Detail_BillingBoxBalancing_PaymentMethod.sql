SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/02/2023
-- Description: Procedimiento almacenado para consultar arqueo de una caja detallado por medio de pago.
-- =============================================
--EXEC [sp_Detail_BillingBoxBalancing_PaymentMethod] 11,23
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_BillingBoxBalancing_PaymentMethod]
(
	@IdBillingBox int,
	@IdPaymentMethod int
)
AS
	DECLARE @IdPaymentMethodIC int
BEGIN
    SET NOCOUNT ON

	SET @IdPaymentMethodIC = (SELECT IdPaymentMethod FROM TB_PaymentMethod WHERE PaymentMethodName = 'Base caja')


	SELECT A.IdBillingBox, B.IdPaymentMethod, A.IdUser, E.BillingOfSaleDate, G.InvoiceNumber, E.RequestNumber AS ProofOfPayment, ISNULL(E.IdPatient, E.IdThirdPerson) IdPatient, 
		CASE WHEN E.IdPatient IS NOT NULL THEN E.IdPatient 
			ELSE CONCAT_WS(' ', TI2.IdentificationTypeCode, '-', T.IdentificationNumber, T.Name, T.LastName) END AS Patient,
		D.PaymentValue AS TotalValuePatient
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_BillOfSalePayment D
		ON D.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_PaymentMethod C
		ON C.IdPaymentMethod = B.IdPaymentMethod
			AND C.IdPaymentMethod = D.IdPaymentMethod
	INNER JOIN TB_BillingOfSale E
		ON E.IdBillingOfSale = D.IdBillingOfSale
	LEFT JOIN TB_ElectronicBilling G
		ON G.IdElectronicBilling = E.IdElectronicBilling
	LEFT JOIN TB_ThirdPerson T
		ON T.IdThirdPerson = E.IdThirdPerson
	LEFT JOIN TB_IdentificationType TI2
		ON TI2.IdIdentificationType = T.IdIdentificationType
	WHERE A.IdBillingBox = @IdBillingBox	
		AND B.IdPaymentMethod = @IdPaymentMethod

	UNION ALL

	SELECT A.IdBillingBox, B.IdPaymentMethod, A.IdUser, B.CreationDate AS PurchaseDate, B.InstallmentContractNumber, NULL AS ProofOfPayment, B.IdCompany, F.CompanyName, B.ContractAmount
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
		AND C.IdPaymentMethod = @IdPaymentMethod

END
GO
