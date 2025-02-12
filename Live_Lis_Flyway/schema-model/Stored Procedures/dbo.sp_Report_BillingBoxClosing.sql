SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Wendy Paola Tellez Gonzalez
-- Create Date: 11/04/2023
-- Description: Procedimiento almacenado para generar información de cierre de caja.
-- =============================================
-- EXEC [sp_Report_BillingBoxClosing] 148
-- =============================================
CREATE PROCEDURE [dbo].[sp_Report_BillingBoxClosing]
(
	@IdBillingBox int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdBillingBox, A.ClosingNumber, A.OpeningDate, A.ClosingDate, A.BalancingDate, A.IdUser, B.UserName AS UserNameCashier , CONCAT_WS(' ', B.Name, B.LastName) AS Cashier, B.SignatureNameContainer  AS CashierSignature,
		A.IdUserBalancing, B2.UserName AS UserNameBalancing,  CONCAT_WS(' ', B2.Name, B2.LastName) AS UserBalancing, B2.SignatureNameContainer AS UserBalancingSignature, A.Base
	FROM TB_BillingBox A
	INNER JOIN TB_User B
		ON B.IdUser = A.IdUser
	LEFT JOIN TB_User B2
		ON B2.IdUser = A.IdUserBalancing
	WHERE A.IdBillingBox = @IdBillingBox
	
	
	SELECT C.IdPaymentMethod, C.PaymentMethodName, B.AmountBillingBox, B.AmountSystem, B.DifferenceAmounts
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing B
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_PaymentMethod C
		ON C.IdPaymentMethod = B.IdPaymentMethod
	WHERE A.IdBillingBox = @IdBillingBox
		AND (B.AmountBillingBox != 0
		OR B.AmountSystem != 0
		OR B.DifferenceAmounts != 0)
	
	SELECT DISTINCT C.IdPaymentMethod AS IdPayment_Method, H.PaymentMethodName AS PaymentMethod, C.BillOfSalePaymentDate AS MovementDate, 
		CASE WHEN B.IdContractType = 4 THEN CONCAT('ANTICIPO No ', D.RequestNumber, ' POR CONCEPTO DE COPAGO') ELSE F.InvoiceNumber END AS Concept, 
		CASE WHEN D.IdThirdPerson IS NOT NULL THEN CONCAT_WS(' ', G.Name, G.LastName) ELSE CONVERT(varchar(10),D.IdPatient) END AS Patient, 
		CASE WHEN D.IdThirdPerson IS NOT NULL THEN 'Tercero' ELSE 'Paciente' END AS Responsible, 
		J.CompanyName, C.PaymentValue
	FROM TB_BillingBox A
	INNER JOIN TB_BillOfSalePayment C
		ON C.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_PaymentMethod H
		ON H.IdPaymentMethod = C.IdPaymentMethod
	INNER JOIN TB_BillingOfSale D
		ON D.IdBillingOfSale = C.IdBillingOfSale
	INNER JOIN TR_BillingOfSale_Request I
		ON I.IdBillingOfSale = D.IdBillingOfSale
	INNER JOIN TB_Request E
		ON E.IdRequest = I.IdRequest
	INNER JOIN TB_Contract B
		ON B.IdContract = E.IdContract
	INNER JOIN TB_Company J
		ON J.IdCompany = B.IdCompany
	LEFT JOIN TB_ElectronicBilling F
		ON F.IdElectronicBilling = D.IdElectronicBilling
	LEFT JOIN TB_ThirdPerson G
		ON G.IdThirdPerson = D.IdThirdPerson
	WHERE A.IdBillingBox = @IdBillingBox
		AND C.Active = 'True'
	
	UNION ALL
	
	SELECT DISTINCT H.IdPaymentMethod, D.PaymentMethodName, H.CreationDate, CONCAT('ANTICIPO No ', H.InstallmentContractNumber, ' POR CONCEPTO DE ABONO A TERCEROS') AS Concept, C.CompanyName, 'Entidad', C.CompanyName, I.ContractAmount
	FROM TB_BillingBox A
	INNER JOIN TB_InstallmentContract H
		ON H.IdBillingBox = A.IdBillingBox
	INNER  JOIN TR_InstallmentContract_Contract I
		ON I.IdInstallmentContract = H.IdInstallmentContract
	INNER JOIN TB_Contract B
		ON B.IdContract = I.IdContract
	INNER JOIN TB_Company C
		ON C.IdCompany = B.IdCompany
	INNER JOIN TB_PaymentMethod D
		ON D.IdPaymentMethod = H.IdPaymentMethod
	WHERE A.IdBillingBox = @IdBillingBox
		AND I.Active = 'True'
	ORDER BY 2
END
GO
