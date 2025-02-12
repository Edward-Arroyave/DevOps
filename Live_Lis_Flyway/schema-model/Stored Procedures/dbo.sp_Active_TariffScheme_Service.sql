SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacenado para activar o desactivar un servicio en un esquema tarifario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_TariffScheme_Service]
(
	@IdTariffSchemeService int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdTariffSchemeService FROM TR_TariffScheme_Service WHERE IdTariffSchemeService = @IdTariffSchemeService)
		BEGIN
			UPDATE TR_TariffScheme_Service
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdTariffSchemeService = @IdTariffSchemeService

			SET @Message = 'Successfully updated service of tariff scheme'
			SET @Flag = 1  
		END
	ELSE
		BEGIN
			SET @Message = 'Service of tariff scheme not found'
			SET @Flag = 0
		END
END
GO
