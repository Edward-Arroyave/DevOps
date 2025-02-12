SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacenado para crear o actualizar esquema tarifario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_TariffScheme]
(
	@IdTariffScheme int,
	@TariffSchemeCode varchar(10),
	@TariffSchemeName varchar(100),
	@IdTariffSchemeType int,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF @IdTariffScheme = 0
		BEGIN
			IF NOT EXISTS (SELECT * FROM TB_TariffScheme WHERE TariffSchemeCode = @TariffSchemeCode AND TariffSchemeName = @TariffSchemeName)
				BEGIN
					IF NOT EXISTS (SELECT TariffSchemeCode FROM TB_TariffScheme WHERE TariffSchemeCode = @TariffSchemeCode)
						BEGIN
							IF NOT EXISTS (SELECT TariffSchemeName FROM TB_TariffScheme WHERE TariffSchemeName = @TariffSchemeName)
								BEGIN
									INSERT INTO TB_TariffScheme (TariffSchemeCode, TariffSchemeName, IdTariffSchemeType, Active, CreationDate, IdUserAction)
									VALUES (@TariffSchemeCode, @TariffSchemeName, @IdTariffSchemeType, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction)

									SET @Message = 'Successfully created tariff scheme'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'Tariff scheme name already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Tariff scheme code already exists'
							SET @Flag = 0
						END
				END	
			ELSE
				BEGIN
					SET @Message = 'Tariff scheme code and name already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT TariffSchemeCode FROM TB_TariffScheme WHERE TariffSchemeCode = @TariffSchemeCode AND IdTariffScheme != @IdTariffScheme)
				BEGIN
					IF NOT EXISTS (SELECT TariffSchemeName FROM TB_TariffScheme WHERE TariffSchemeName = @TariffSchemeName AND IdTariffScheme != @IdTariffScheme)
						BEGIN
							UPDATE TB_TariffScheme
								SET TariffSchemeCode = @TariffSchemeCode,
									TariffSchemeName = @TariffSchemeName,
									IdTariffSchemeType = @IdTariffSchemeType,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									IdUserAction = @IdUserAction
							WHERE IdTariffScheme= @IdTariffScheme

							SET @Message = 'Successfully updated tariff scheme'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Tariff scheme name already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'Tariff scheme code already exists'
					SET @Flag = 0
				END
		END
END
GO
