SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacenado para retornar información de un esquema tarifario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_TariffScheme]
(
	@IdTariffScheme int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdTariffScheme FROM TB_TariffScheme WHERE IdTariffScheme = @IdTariffScheme)
		BEGIN
			SELECT IdTariffScheme, TariffSchemeCode, TariffSchemeName, IdTariffSchemeType
			FROM TB_TariffScheme
			WHERE IdTariffScheme = @IdTariffScheme

			SET @Message = 'Tariff scheme found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Tariff scheme does not exists'
			SET @Flag = 0
		END
END
GO
