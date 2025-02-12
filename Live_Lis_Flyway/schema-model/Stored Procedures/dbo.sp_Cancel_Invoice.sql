SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/02/2023
-- Description: Procedimiento almaceanado para anular factura.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Cancel_Invoice] 'SETP990001746',53,1,'Prueba',4, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Cancel_Invoice]
(
	@InvoiceNumber varchar(15) = NULL,
	@IdPreBilling int = NULL,
	@IdContract int,
	@IdInvoiceCancelReason int = NULL,
	@InvoiceCancelReason varchar(max) = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdContractType int, @IdElectronicBilling int, @IdBillingOfSale int
	DECLARE @TotalValue bigint, @TotalAdvanceValue bigint
BEGIN
    SET NOCOUNT ON

	SET @IdContractType = (SELECT IdContractType FROM TB_Contract WHERE IdContract = @IdContract)

	IF @IdContractType != 1
		BEGIN
			IF @InvoiceNumber IS NOT NULL
				BEGIN
					SET @IdElectronicBilling = (SELECT	TOP 1 e.IdElectronicBilling 
												FROM	TB_ElectronicBilling  E
														INNER JOIN TB_BillingOfSale B ON E.IdElectronicBilling = B.IdElectronicBilling
												WHERE	InvoiceNumber = @InvoiceNumber)
					SET @IdPreBilling = (SELECT IdPreBilling FROM TB_PreBilling WHERE IdElectronicBilling = @IdElectronicBilling)

					--- Anular factura electrónica. 	
					UPDATE TB_ElectronicBilling
						SET IdCancellationReason = @IdInvoiceCancelReason,
							CancellationReason = @InvoiceCancelReason,
							Active = 'False',
							IdUserAnnul = @IdUserAction,
							AnnulDate = DATEADD(HOUR, -5,GETDATE())
					WHERE IdElectronicBilling = @IdElectronicBilling
				END

			--- Anular prefactura
			UPDATE TB_PreBilling
				SET Active = 'False'
			WHERE IdPreBilling = @IdPreBilling

			UPDATE TR_PreBilling_BillingOfSale
				SET Active = 'False'
			WHERE IdPreBilling = @IdPreBilling

			--- Cambiar estado de ingreso prefacturado
			UPDATE B
				SET B.PreBilling = 'False'
			FROM TR_PreBilling_BillingOfSale A
			INNER JOIN TB_BillingOfSale B
				ON B.IdBillingOfSale = A.IdBillingOfSale
			WHERE A.IdPreBilling = @IdPreBilling

			UPDATE TR_InstallmentContract_PreBilling
				SET Active = 'False',
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdPreBilling = @IdPreBilling

			UPDATE A	
				SET Crossway = 'False',
					UpdateDate =  DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction
			FROM TR_InstallmentContract_Contract A
			INNER JOIN TR_InstallmentContract_PreBilling B
				ON B.IdInstallmentContract_Contract = A.IdInstallmentContract_Contract
			WHERE B.IdPreBilling = @IdPreBilling

			SET @Message = 'Successfully cancel invoice'
			SET @Flag = 1
		END
	ELSE IF @IdContractType = 1
		BEGIN
			SET @IdElectronicBilling = (SELECT	e.IdElectronicBilling 
										FROM	TB_ElectronicBilling  E
												INNER JOIN TB_BillingOfSale B ON E.IdElectronicBilling = B.IdElectronicBilling
										WHERE	InvoiceNumber = @InvoiceNumber)
			SET @IdBillingOfSale = (SELECT IdBillingOfSale FROM TB_BillingOfSale WHERE IdElectronicBilling = @IdElectronicBilling)

			--- Anular factura electrónica. 
			UPDATE TB_ElectronicBilling
				SET --IdInvoiceStatus = 3,
					IdCancellationReason = @IdInvoiceCancelReason,
					CancellationReason = @InvoiceCancelReason,
					Active = 'False',
					IdUserAnnul = @IdUserAction,
					AnnulDate = DATEADD(HOUR, -5,GETDATE())
			WHERE IdElectronicBilling = @IdElectronicBilling

			--- Anular ingreso
			UPDATE TB_BillingOfSale
				SET IdBillingOfSaleStatus = 7,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdBillingOfSale = @IdBillingOfSale

			UPDATE C
				SET C.IdRequestStatus = 2,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			--SELECT *
			FROM TB_BillingOfSale A
			INNER JOIN TR_BillingOfSale_Request B
				ON B.IdBillingOfSale = A.IdBillingOfSale
			INNER JOIN TB_Request C
				ON C.IdRequest = B.IdRequest
			WHERE A.IdBillingOfSale = @IdBillingOfSale

			UPDATE B
				SET B.Active = 'False'
			FROM TB_BillingOfSale A
			INNER JOIN TR_BillingOfSale_Request C
				ON C.IdBillingOfSale = A.IdBillingOfSale
			INNER JOIN TB_BillOfSalePayment B
				ON B.IdBillingOfSale = A.IdBillingOfSale
			WHERE A.IdBillingOfSale = @IdBillingOfSale

			SET @Message = 'Successfully cancel invoice'
			SET @Flag = 1
		END
END
GO
