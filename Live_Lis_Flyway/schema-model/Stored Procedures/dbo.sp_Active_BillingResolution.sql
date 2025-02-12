SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para activar o desactivar una resolución de facturación.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_BillingResolution]
(
	@IdBillingResolution int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdBillingResolution FROM TB_BillingResolution WHERE IdBillingResolution = @IdBillingResolution)
		BEGIN
			UPDATE TB_BillingResolution
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdBillingResolution = @IdBillingResolution

			SET @Message = 'Successfully updated billing resolution'
			SET @Flag = 1  
		END
	ELSE
		BEGIN
			SET @Message = 'Billing resolution not found'
			SET @Flag = 0
		END
END
GO
