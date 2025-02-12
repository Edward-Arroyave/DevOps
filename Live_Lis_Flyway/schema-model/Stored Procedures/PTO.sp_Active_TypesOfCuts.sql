SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/06/2022
-- Description: Procedimiento almacenado para activar o desactivar tipo de cortes.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_TypesOfCuts]
(
	@IdTypesOfCuts int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdTypesOfCuts FROM PTO.TB_TypesOfCuts WHERE IdTypesOfCuts = @IdTypesOfCuts)
		BEGIN
			UPDATE PTO.TB_TypesOfCuts
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdTypesOfCuts = @IdTypesOfCuts

			SET @Message = 'Successfully updated Types Of Cuts'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Types Of Cuts not found'
			SET @Flag = 0
		END
END
GO
