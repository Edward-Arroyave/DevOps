SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/02/2023
-- Description: Procedimiento almacenado para consultar detalle de arqueo de una caja.
-- =============================================
--EXEC [sp_Detail_BillingBoxBalancing] 29
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_BillingBoxBalancing]
(
	@IdBillingBox int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdBillingBox, B.IdPaymentMethod, D.PaymentMethodName, B.AmountBillingBox, B.AmountSystem, B.Comments
	FROM TB_BillingBox A
	INNER JOIN TB_BillingBoxClosing B	
		ON B.IdBillingBox = A.IdBillingBox
	INNER JOIN TB_PaymentMethod D
		ON D.IdPaymentMethod = B.IdPaymentMethod
	WHERE A.IdBillingBox = @IdBillingBox
		AND A.BillingBoxStatus = 0
END
GO
