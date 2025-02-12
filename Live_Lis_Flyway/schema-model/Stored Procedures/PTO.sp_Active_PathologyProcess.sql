SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para activar o desactivar proceso de patología.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_PathologyProcess]
(
	@IdPathologyProcess int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdPathologyProcess FROM PTO.TB_PathologyProcess WHERE IdPathologyProcess = @IdPathologyProcess)
		BEGIN
			UPDATE PTO.TB_PathologyProcess
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdPathologyProcess = @IdPathologyProcess

			SET @Message = 'Successfully updated Pathology Process'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Pathology Process not found'
			SET @Flag = 0
		END
END
GO
