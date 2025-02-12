SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/04/2022
-- Description: Procedimiento almacenado para activar o desactivar un tipo de esquema tarifario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_TariffSchemeType]
(
	@IdTariffSchemeType int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdTariffSchemeType FROM TB_TariffSchemeType WHERE IdTariffSchemeType = @IdTariffSchemeType)
		BEGIN
			UPDATE TB_TariffSchemeType
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdTariffSchemeType = @IdTariffSchemeType

			SET @Message = 'Successfully updated tariff scheme type'
			SET @Flag = 1  
		END
	ELSE
		BEGIN
			SET @Message = 'Tariff scheme type not found'
			SET @Flag = 0
		END
END
GO
