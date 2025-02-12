SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/11/20212
-- Description: Procedimiento almacenado para hacer visible o invisible analito.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Visible_Analyte]
(
	@IdAnalyte int,
	@Visible bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdAnalyte FROM TB_Analyte WHERE IdAnalyte = @IdAnalyte)
		BEGIN
			UPDATE TB_Analyte
				SET Visible = @Visible,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdAnalyte = @IdAnalyte

			SET @Message = 'Successfully updated Analyte'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Analyte not found'
			SET @Flag = 0
		END
END
GO
