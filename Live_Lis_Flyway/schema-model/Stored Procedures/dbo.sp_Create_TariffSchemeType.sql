SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/04/2022
-- Description: Procedimiento almacenado para crear tipos de esquemas tarifarios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_TariffSchemeType]
(
	@IdTariffSchemeType int,
	@TariffSchemeTypeName varchar(100),
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

    IF @IdTariffSchemeType = 0
		BEGIN
			IF NOT EXISTS (SELECT TariffSchemeTypeName FROM TB_TariffSchemeType WHERE TariffSchemeTypeName = @TariffSchemeTypeName)
				BEGIN
					INSERT INTO TB_TariffSchemeType (TariffSchemeTypeName, CreationDate, IdUserAction, Active)
					VALUES (@TariffSchemeTypeName, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)

					SET @Message = 'Successfully created tariff scheme type'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Tariff scheme type already exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT TariffSchemeTypeName FROM TB_TariffSchemeType WHERE TariffSchemeTypeName = @TariffSchemeTypeName AND IdTariffSchemeType != @IdTariffSchemeType)
				BEGIN
					UPDATE TB_TariffSchemeType
						SET TariffSchemeTypeName = @TariffSchemeTypeName,
							UpdateDate = DATEADD(HOUR,-5,GETDATE()),
							IdUserAction = @IdUserAction
					WHERE IdTariffSchemeType = @IdTariffSchemeType

					SET @Message = 'Successfully updated tariff scheme type'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Tariff scheme type already exists'
					SET @Flag = 0
				END
		END
END
GO
