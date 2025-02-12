SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/02/2023
-- Description: Procedimiento almacenado para consultar arqueo de una caja.
-- =============================================
--EXEC [sp_Consult_BillingBox] 1,'','','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Confirm_BillingBoxBalancing]
(
	@IdBillingBox int,
	@IdUserBalancing int,
	@Comments varchar(max),
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdBillingBox FROM TB_BillingBox WHERE IdBillingBox = @IdBillingBox)
		BEGIN
			IF EXISTS (SELECT IdBillingBox FROM TB_BillingBox WHERE IdBillingBox = @IdBillingBox AND BillingBoxStatus = 0 AND BalancingStatus = 0)
				BEGIN
					UPDATE TB_BillingBox
						SET Comments = @Comments,
							IdUserBalancing = @IdUserBalancing,
							BalancingDate = DATEADD(HOUR,-5,GETDATE()),
							BalancingStatus = 1
					WHERE IdBillingBox = @IdBillingBox

					SET @Message = 'Successfully confirmed billing box balance'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Billing box balance has already been confirmed'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			SET @Message = 'Billing box not found'
			SET @Flag = 0
		END
END
GO
