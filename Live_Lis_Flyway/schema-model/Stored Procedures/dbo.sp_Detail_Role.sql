SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/03/2022
-- Description: Procedimiento almacenado para retornar los datos de rol.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Role]
(
	@IdRole int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdRole FROM TB_Role WHERE IdRole = @IdRole)
		BEGIN

			declare @profile int = (select count(*) from TR_Role_Profile where IdRole = @IdRole)
			
			IF @profile =2
				BEGIN
					SELECT IdRole, RoleName, 3 IdProfile, Active, Informative
					FROM TB_Role
					WHERE IdRole = @IdRole
				END
			ELSE
				BEGIN
					SELECT IdRole, RoleName, IdProfile, Active, Informative
					FROM TB_Role
					WHERE IdRole = @IdRole
				END

			SET @Message = 'Role found'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Role does not exists'
			SET @Flag = 0
		END
END
GO
