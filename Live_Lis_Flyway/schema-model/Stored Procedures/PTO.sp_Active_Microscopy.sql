SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/07/2022
-- Description: Procedimiento almacenado para activar o desactivar microscopia.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_Microscopy]
(
	@IdMicroscopy int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdMicroscopy FROM PTO.TB_Microscopy WHERE IdMicroscopy = @IdMicroscopy)
		BEGIN
			UPDATE PTO.TB_Microscopy
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdMicroscopy = @IdMicroscopy

			SET @Message = 'Successfully updated Microscopy'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Microscopy not found'
			SET @Flag = 0
		END
END
GO
