SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/06/2022
-- Description: Procedimiento almacenado para activar o desactivar tipo de coloración.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_TypesOfColorations]
(
	@IdTypesOfColorations int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdTypesOfColorations FROM PTO.TB_TypesOfColorations WHERE IdTypesOfColorations = @IdTypesOfColorations)
		BEGIN
			UPDATE PTO.TB_TypesOfColorations
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdTypesOfColorations = @IdTypesOfColorations

			SET @Message = 'Successfully updated Types Of Colorations'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Types Of Colorations not found'
			SET @Flag = 0
		END
END
GO
