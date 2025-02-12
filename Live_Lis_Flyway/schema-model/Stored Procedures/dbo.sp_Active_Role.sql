SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/03/2022
-- Description: Procedimiento almacenado para activar o desactivar un rol.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_Role]
(
	@IdRole int,
	@Active bit,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdRole FROM TB_Role WHERE IdRole = @IdRole)
		BEGIN
			IF @Active = 0
				BEGIN
					IF NOT EXISTS (SELECT IdRole FROM TB_User WHERE IdRole = @IdRole)
						BEGIN
							UPDATE TB_Role
								SET Active = @Active,
									IdUserAction = @IdUserAction,
									UpdateDate = DATEADD(HOUR,-5,GETDATE())
							WHERE IdRole = @IdRole

							SET @Message = 'Successfully updated Role'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Role has associated users'
							SET @Flag = 0
						END
				END
			ELSE IF @Active = 1
				BEGIN
					UPDATE TB_Role
						SET Active = @Active,
							IdUserAction = @IdUserAction,
							UpdateDate = DATEADD(HOUR,-5,GETDATE())
					WHERE IdRole = @IdRole

					SET @Message = 'Successfully updated Role'
					SET @Flag = 1
				END
		END
	ELSE
		BEGIN
			SET @Message = 'Role not found'
			SET @Flag = 0
		END
END
GO
