SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/03/20212
-- Description: Procedimiento almacenado para listar los roles asociados a un usuario.
-- =============================================
/*
declare @Message varchar(50), @Flag bit
exec [dbo].[sp_Consult_Role_User] 1753, @Message out, @Flag out
SELECT @Message, @Flag
*/
CREATE PROCEDURE [dbo].[sp_Consult_Role_User]
(
	@IdUser int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdRole FROM TB_User WHERE IdUser = @IdUser)
		BEGIN 
			SELECT A.IdRole, B.RoleName
			FROM TB_User A
			INNER JOIN TB_Role B
				ON B.IdRole = A.IdRole
			WHERE B.Active = 'True'

			SET @Message = 'Roles assigned to the user'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'The user has no assigned role'
			SET @Flag = 0
		END
END
GO
