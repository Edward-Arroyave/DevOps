SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/04/2022
-- Description: Procedimiento almacenado para retornar información de un tipo de esquema tarifario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_TariffSchemeType]
(
	@IdTariffSchemeType int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdTariffSchemeType FROM TB_TariffSchemeType WHERE IdTariffSchemeType = @IdTariffSchemeType)
		BEGIN
			SELECT IdTariffSchemeType, TariffSchemeTypeName
			FROM TB_TariffSchemeType
			WHERE IdTariffSchemeType = @IdTariffSchemeType

			SET @Message = 'Tariff scheme type found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Tariff scheme type does not exists'
			SET @Flag = 0
		END
END
GO
