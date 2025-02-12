SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para activar o desactivar medio de fijación.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_FixingMedium]
(
	@IdFixingMedium int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdFixingMedium FROM PTO.TB_FixingMedium WHERE IdFixingMedium = @IdFixingMedium)
		BEGIN
			UPDATE PTO.TB_FixingMedium
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdFixingMedium = @IdFixingMedium 

			SET @Message = 'Successfully updated fixing medium'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Fixing medium not found'
			SET @Flag = 0
		END
END
GO
