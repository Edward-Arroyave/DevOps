SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para activar o desactivar clasificación de patología.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_PathologyClassification]
(
	@IdPathologyClassification int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdPathologyClassification FROM PTO.TB_PathologyClassification WHERE IdPathologyClassification = @IdPathologyClassification)
		BEGIN
			UPDATE PTO.TB_PathologyClassification
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdPathologyClassification = @IdPathologyClassification

			SET @Message = 'Successfully updated Pathology Classification'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Pathology Classification not found'
			SET @Flag = 0
		END
END
GO
