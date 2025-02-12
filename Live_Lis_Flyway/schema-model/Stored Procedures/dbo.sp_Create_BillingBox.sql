SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 25/01/2023
-- Description: Procedmiento almacenado para crear caja y relacionar usuarios.
-- =============================================
--DECLARE @BillingBoxName varchar(200), @Message varchar(50), @Flag bit
--EXEC [sp_Create_BillingBox] 4,10,200000,@BillingBoxName out, @Message out, @Flag out
--SELECT @BillingBoxName, @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_BillingBox]
(
	@IdUser int,
	@IdAttentionCenter int, 
	@Base bigint, 
	@BillingBoxName varchar(200) out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @Consecutive varchar(50), @BillingBoxCode varchar(5), @BillingBox varchar(50), @AttentionCenter varchar(70), @UserName varchar(50)
BEGIN
    SET NOCOUNT ON

	SET @Consecutive = (SELECT COUNT(IdBillingBox) + 1 FROM TB_BillingBox WHERE CONVERT(date,OpeningDate) = CONVERT(date, DATEADD(HOUR,-5,GETDATE())) AND IdAttentionCenter = @IdAttentionCenter)
	
	SET @BillingBoxCode = (CASE WHEN LEN(@Consecutive) = 1 THEN CONCAT('00', @Consecutive)
							WHEN LEN(@Consecutive) = 2 THEN CONCAT('0', @Consecutive)
							WHEN LEN(@Consecutive) >= 3 THEN @Consecutive END)

	SET @AttentionCenter = (SELECT REPLACE(AttentionCenterName,' ','') FROM TB_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter) 
	SET @UserName = (SELECT UserName FROM TB_User WHERE IdUser = @IdUser) 
	SET @BillingBox = CONCAT(@UserName,@AttentionCenter,@BillingBoxCode)

	-- Validar que el usuario no tenga cajas abiertas previamente
	IF NOT EXISTS (SELECT DISTINCT BillingBoxStatus FROM TB_BillingBox WHERE IdUser = @IdUser AND BillingBoxStatus = 1)
		BEGIN
			IF (SELECT ManualBalancing FROM TB_Business) = 'True'
				BEGIN
					IF NOT EXISTS (SELECT DISTINCT BillingBoxStatus FROM TB_BillingBox WHERE IdUser = @IdUser AND BillingBoxStatus = 0 AND BalancingStatus = 0)
						BEGIN
							INSERT INTO TB_BillingBox (OpeningDate, IdUser, IdAttentionCenter, BillingBoxCode, BillingBoxName, Base, BillingBoxStatus)
							VALUES (DATEADD(HOUR,-5,GETDATE()), @IdUser, @IdAttentionCenter, @BillingBoxCode, @BillingBox, @Base, 1)

							SET @BillingBoxName = @BillingBox
							SET @Message = 'Successfully opened billing box'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							 SET @Message = 'User has pending billingbox to confirm counting'
							 SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					INSERT INTO TB_BillingBox (OpeningDate, IdUser, IdAttentionCenter, BillingBoxCode, BillingBoxName, Base, BillingBoxStatus)
					VALUES (DATEADD(HOUR,-5,GETDATE()), @IdUser, @IdAttentionCenter, @BillingBoxCode, @BillingBox, @Base, 1)

					SET @BillingBoxName = @BillingBox
					SET @Message = 'Successfully opened billing box'
					SET @Flag = 1
				END
		END
	ELSE
		BEGIN
			SET @Message = 'User has an open billing box'
			SET @Flag = 0
		END
END
GO
