SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/12/20212
-- Description: Procedimiento almacenado para activar o desactivar valores de referencia de un analito.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_ReferenceValue]
(
	@IdReferenceValue int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdReferenceValue FROM TB_ReferenceValue WHERE IdReferenceValue = @IdReferenceValue)
		BEGIN
			UPDATE TB_ReferenceValue
				SET Status = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdReferenceValue = @IdReferenceValue

			SET @Message = 'Successfully updated Reference Value'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Reference Value not found'
			SET @Flag = 0
		END
END
GO
