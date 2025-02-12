SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 02/02/2023
-- Description: Procedimiento almacenado para cerrar caja.
-- =============================================
--DECLARE @BillingBoxClosing BillingBoxClosing, @Message varchar(50), @Flag bit
--INSERT INTO @BillingBoxClosing (IdPaymentMethod, AmountBillingBox) VALUES 
--(1,520000), 
--(2,50000), 
--(3,80000),
--(4,0),
--(5,589000),
--(6,0),
--(7,0),
--(15,0),
--(16,0),
--(17,0),
--(18,0),
--(19,0),
--(20,0),
--(21,0)


--EXEC [sp_Create_BillingBoxClosing] 11, @BillingBoxClosing, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_BillingBoxClosing]
(
	@IdBillingBox int, 
	@BillingBoxClosing BillingBoxClosing READONLY,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @Consecutive varchar(50), @ClosingNumber varchar(50), @IdPaymentMethod int
BEGIN
    SET NOCOUNT ON

	SET @Consecutive = (SELECT COUNT(ClosingNumber) + 1 FROM TB_BillingBox)
	SET @IdPaymentMethod = (SELECT IdPaymentMethod FROM TB_PaymentMethod WHERE PaymentMethodName = 'Base caja')

	SET @ClosingNumber = (CASE WHEN LEN(@Consecutive) = 1 THEN CONCAT('00000', @Consecutive)
							WHEN LEN(@Consecutive) = 2 THEN CONCAT('0000', @Consecutive)
							WHEN LEN(@Consecutive) = 3 THEN CONCAT('000', @Consecutive)
							WHEN LEN(@Consecutive) = 4 THEN CONCAT('00', @Consecutive)
							WHEN LEN(@Consecutive) = 5 THEN CONCAT('0', @Consecutive)
							WHEN LEN(@Consecutive) >= 6 THEN @Consecutive END)

	IF (SELECT BillingBoxStatus FROM TB_BillingBox WHERE IdBillingBox = @IdBillingBox) = 1
		BEGIN
			-- Ingresa información de dinero recibido
			INSERT INTO TB_BillingBoxClosing (IdBillingBox, IdPaymentMethod, AmountBillingBox)
			SELECT @IdBillingBox, IdPaymentMethod, AmountBillingBox FROM @BillingBoxClosing

			-- Actualizar total recibido por sistema
			UPDATE A	
				SET A.AmountSystem =  ISNULL(B.ValueTotal,0)
			FROM TB_BillingBoxClosing A
			LEFT JOIN (
						SELECT A.IdBillingBox, B.IdPaymentMethod, SUM(B.PaymentValue) ValueTotal
						FROM TB_BillingBox A
						INNER JOIN TB_BillOfSalePayment B
							ON B.IdBillingBox = A.IdBillingBox
						WHERE A.IdBillingBox = @IdBillingBox
							AND B.Active = 'True'
						GROUP BY A.IdBillingBox, B.IdPaymentMethod
					) B
				ON B.IdBillingBox = A.IdBillingBox
					AND B.IdPaymentMethod = A.IdPaymentMethod
			WHERE A.IdBillingBox = @IdBillingBox

			-- Actualizar total abono a entidades
			UPDATE A	
				SET A.AmountSystem = A.AmountSystem + ISNULL(B.ValueTotal,0)
			--SELECT *
			FROM TB_BillingBoxClosing A
			LEFT JOIN (
						SELECT A.IdBillingBox, B.IdPaymentMethod, SUM(B.ContractAmount) ValueTotal
						FROM TB_BillingBox A
						INNER JOIN TB_InstallmentContract B
							ON B.IdBillingBox = A.IdBillingBox
						WHERE A.IdBillingBox = @IdBillingBox
							AND B.Active = 'True'
						GROUP BY A.IdBillingBox, B.IdPaymentMethod
					) B
				ON B.IdBillingBox = A.IdBillingBox
					AND B.IdPaymentMethod = A.IdPaymentMethod
			WHERE A.IdBillingBox = @IdBillingBox

			--Descuento del valor de las devoluciones
			UPDATE A	
				SET A.AmountSystem = A.AmountSystem - ISNULL(B.ValueTotal,0)
			FROM TB_BillingBoxClosing A
			INNER JOIN ( SELECT A.IdBillingBox, B.IdPaymentMethod, SUM(B.Amount) ValueTotal
						FROM TB_BillingBox A
						INNER JOIN TB_ReturnMoneyCompany B
							ON B.IdBillingBox = A.IdBillingBox
						WHERE A.IdBillingBox = @IdBillingBox
						GROUP BY A.IdBillingBox, B.IdPaymentMethod
						) B	ON B.IdBillingBox = A.IdBillingBox
							AND B.IdPaymentMethod = A.IdPaymentMethod
			WHERE A.IdBillingBox = @IdBillingBox


			--Descuento del valor de las cuotas de recuperacion
			UPDATE A	
				SET A.AmountSystem = A.AmountSystem - ISNULL(B.ValueTotal,0)
			FROM	TB_BillingBoxClosing A
					INNER JOIN ( SELECT A.IdBillingBox, SUM(B.value) ValueTotal
								FROM TB_BillingBox A
								INNER JOIN TB_RecoveryFee B
									ON B.IdBillingBox = A.IdBillingBox
								WHERE A.IdBillingBox = @IdBillingBox
								GROUP BY A.IdBillingBox
								) B	ON B.IdBillingBox = A.IdBillingBox
			WHERE A.IdBillingBox = @IdBillingBox

			---Actualizar valor base de caja
			UPDATE A
				SET A.AmountSystem = A.AmountSystem + ISNULL(B.Base,0)
			--SELECT A.AmountSystem, B.Base
			FROM TB_BillingBoxClosing A
			INNER JOIN TB_BillingBox B
				ON B.IdBillingBox = A.IdBillingBox
			WHERE A.IdBillingBox = @IdBillingBox
				AND A.IdPaymentMethod = @IdPaymentMethod

			-- Actualizar la diferencia entre el dinero en el sistema y el dinero recibo
			UPDATE TB_BillingBoxClosing
				SET DifferenceAmounts = (ISNULL(AmountBillingBox,0) - ISNULL(AmountSystem,0))
			WHERE IdBillingBox = @IdBillingBox

			-- Cierre de caja
			UPDATE TB_BillingBox
				SET ClosingDate = DATEADD(HOUR,-5,GETDATE()),
					BillingBoxStatus = 0,
					ClosingNumber = @ClosingNumber,
					BalancingStatus = 0
			WHERE IdBillingBox = @IdBillingBox
		
			SET @Message = 'Successfully billing box closing'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Billing box is already closed'
			SET @Flag = 0
		END
END
GO
