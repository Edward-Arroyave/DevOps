SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para activar o desactivar plantilla.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_Template]
(
	@IdTemplate int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdTemplate FROM PTO.TB_Template WHERE IdTemplate = @IdTemplate)
		BEGIN
			UPDATE PTO.TB_Template
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdTemplate = @IdTemplate

			SET @Message = 'Successfully updated Template'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Template not found'
			SET @Flag = 0
		END
END
GO
