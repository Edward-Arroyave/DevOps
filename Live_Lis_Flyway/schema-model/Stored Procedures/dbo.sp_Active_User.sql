SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/03/2022
-- Description: Procedimiento almacenado para activar o desactivar usuario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_User]
(
	@IdUser int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdUser FROM TB_User WHERE IdUser = @IdUser)
		BEGIN
			UPDATE TB_User
				SET Active = @Active,
					IdUserAction = @IdUserAction,
					UpdateDate = DATEADD(HOUR,-5,GETDATE())
			WHERE IdUser = @IdUser

			SET @Message = 'Successfully updated user'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'User not found'
			SET @Flag = 0
		END
END
GO
