SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacenado para activar o desactivar un esquema tarifario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_TariffScheme]
(
	@IdTariffScheme int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF NOT EXISTS (SELECT IdTariffScheme FROM TB_Contract WHERE IdTariffScheme = @IdTariffScheme AND Active = 'True')
		BEGIN
			UPDATE TB_TariffScheme
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdTariffScheme = @IdTariffScheme

			SET @Message = 'Successfully updated tariff scheme'
			SET @Flag = 1  
		END
	ELSE
		BEGIN
			SET @Message = 'Tariff scheme associated with a contract'
			SET @Flag = 0
		END
END
GO
