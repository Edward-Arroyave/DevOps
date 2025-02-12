SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/02/2023
-- Description: Procedimiento almacenado para consultar arqueo de una caja.
-- =============================================
--EXEC [sp_Consult_BillingBoxBalancing] 4
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_BillingBoxBalancing]
(
	@IdBillingBox int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdBillingBox, A.OpeningDate, A.ClosingDate, B.IdPaymentMethod, D.PaymentMethodName, B.AmountSystem, B.AmountBillingBox, B.DifferenceAmounts
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing B	
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_PaymentMethod D
		ON D.IdPaymentMethod = B.IdPaymentMethod
	LEFT JOIN TB_BillOfSalePayment C
		ON C.IdBillingBox = A.IdBillingBox
	WHERE A.IdBillingBox = @IdBillingBox
		AND A.BalancingStatus = 0

END
GO
