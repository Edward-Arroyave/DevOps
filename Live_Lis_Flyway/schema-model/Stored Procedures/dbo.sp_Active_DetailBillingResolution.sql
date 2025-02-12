SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/08/2022
-- Description: Procedimiento almacenado para activar o desactivar un detalle de resolución de facturación.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_DetailBillingResolution]
(
	@IdDetailBillingResolution int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdDetailBillingResolution FROM TB_DetailBillingResolution WHERE IdDetailBillingResolution = @IdDetailBillingResolution)
		BEGIN
			UPDATE TB_DetailBillingResolution
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdDetailBillingResolution = @IdDetailBillingResolution

			SET @Message = 'Successfully updated detail billing resolution'
			SET @Flag = 1  
		END
	ELSE
		BEGIN
			SET @Message = 'Detail billing resolution not found'
			SET @Flag = 0
		END
END
GO
