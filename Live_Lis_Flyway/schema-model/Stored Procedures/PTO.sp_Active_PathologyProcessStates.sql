SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para activar o desactivar estado de proceso de patología.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_PathologyProcessStates]
(
	@IdPathologyProcessStates int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdPathologyProcessStates FROM PTO.TB_PathologyProcessStates WHERE IdPathologyProcessStates = @IdPathologyProcessStates)
		BEGIN
			UPDATE PTO.TB_PathologyProcessStates
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdPathologyProcessStates = @IdPathologyProcessStates

			SET @Message = 'Successfully updated Pathology Process States'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Pathology Process States not found'
			SET @Flag = 0
		END
END
GO
