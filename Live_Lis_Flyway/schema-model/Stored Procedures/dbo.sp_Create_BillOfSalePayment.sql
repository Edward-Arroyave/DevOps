SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/08/2022
-- Description: Procedimiento almacenado para registrar pago realizados a una factura.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_BillOfSalePayment]
(
	@IdBillingOfSale int,
	@IdPaymentMethod int,
	@PaymentValue bigint,
	@ReferenceNumber_CUS varchar(20) = NULL,
	@IdBankAccount int = NULL,
	@IdUserAction int,
	@Balance bigint out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdBillingBox int
BEGIN
    SET NOCOUNT ON

	SET @IdBillingBox = (SELECT IdBillingBox FROM TB_BillingBox WHERE IdUser = @IdUserAction AND BillingBoxStatus = 1)

    IF EXISTS (SELECT IdBillingOfSale FROM TB_BillingOfSale WHERE IdBillingOfSale = @IdBillingOfSale)
		BEGIN
			IF (SELECT ISNULL(SUM(PaymentValue),0) FROM TB_BillOfSalePayment WHERE IdBillingOfSale = @IdBillingOfSale) < (SELECT TotalValuePatient FROM TB_BillingOfSale WHERE IdBillingOfSale = @IdBillingOfSale)
				BEGIN
					IF (SELECT A.TotalValuePatient - ISNULL(SUM(B.PaymentValue),0) FROM TB_BillingOfSale A LEFT JOIN TB_BillOfSalePayment B ON B.IdBillingOfSale = A.IdBillingOfSale WHERE A.IdBillingOfSale = @IdBillingOfSale GROUP BY A.TotalValuePatient) >= @PaymentValue
						BEGIN
							INSERT INTO TB_BillOfSalePayment(IdBillingOfSale, BillOfSalePaymentDate, IdPaymentMethod, PaymentValue, ReferenceNumber_CUS, IdBankAccount, IdBillingBox, IdUserAction, CreationDate)
							VALUES (@IdBillingOfSale, DATEADD(HOUR,-5,GETDATE()), @IdPaymentMethod, @PaymentValue, @ReferenceNumber_CUS, @IdBankAccount, @IdBillingBox, @IdUserAction, DATEADD(HOUR,-5,GETDATE()))

							SET @Balance = (SELECT (A.TotalValuePatient - ISNULL(SUM(B.PaymentValue),0)) Balance
											FROM TB_BillingOfSale A 
											LEFT JOIN TB_BillOfSalePayment B 
												ON B.IdBillingOfSale = A.IdBillingOfSale 
											WHERE A.IdBillingOfSale = @IdBillingOfSale
											GROUP BY A.TotalValuePatient)

							SET @Message = 'Successfully created billing of sale payment'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Payment value is greater than the balance'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Total value of the completed billing of sale payment'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			SET @Message = 'billing of sale does not exist'
			SET @Flag = 0
		END
END
GO
