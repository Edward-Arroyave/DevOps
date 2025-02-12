SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/09/2022
-- Description: Procedimiento almacenado para consultar solicitud para .
-- =============================================
--DECLARE @Message varchar(50), @Flag bit 
--EXEC [sp_Consult_CancelInvoice]'SETT3558', @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_CancelInvoice]
(
	@InvoiceNumber varchar(15),
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT InvoiceNumber FROM TB_ElectronicBilling WHERE InvoiceNumber = @InvoiceNumber)
		BEGIN
			IF EXISTS (SELECT InvoiceNumber FROM TB_ElectronicBilling WHERE InvoiceNumber = @InvoiceNumber AND Active = 'True')
				BEGIN
					SELECT A.IdElectronicBilling, G.IdContractType, F.IdContract, A.InvoiceNumber, F.RequestNumber, F.IdPatient, F.IdRequestAlternative, F.RequestNumAlternative, F.IdAdmissionSource
					FROM TB_ElectronicBilling A
					INNER JOIN TB_BillingOfSale D
						ON D.IdElectronicBilling = A.IdElectronicBilling
					INNER JOIN TR_BillingOfSale_Request E
						ON E.IdBillingOfSale = D.IdBillingOfSale
					INNER JOIN TB_Request F
						ON F.IdRequest = E.IdRequest
					INNER JOIN TB_Contract G
						ON F.IdContract = G.IdContract
					WHERE A.InvoiceNumber = @InvoiceNumber
						AND A.Active = 'True'

					SET @Message = 'Invoice information found'
					SET @Flag = 1
				END
			ELSE
				BEGIN	
					SET @Message = 'Invoice is in canceled status'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			SET @Message = 'Invoice not found'
			SET @Flag = 0
		END
END
GO
