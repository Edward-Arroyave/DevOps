SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para activar o desactivar parte del cuerpo.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Active_BodyPart]
(
	@IdBodyPart int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdBodyPart FROM PTO.TB_BodyPart WHERE IdBodyPart = @IdBodyPart)
		BEGIN
			UPDATE PTO.TB_BodyPart
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdBodyPart = @IdBodyPart

			SET @Message = 'Successfully updated BodyPart'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'BodyPart not found'
			SET @Flag = 0
		END
END
GO
