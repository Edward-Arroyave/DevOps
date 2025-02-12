SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 09/03/2022
-- Description: Procedimiento almacenado para validar si el nombre de usuario ya existe en base de datos.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Validate_UserName]
(
	@UserName varchar(50),
	@Message varchar(30) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

    IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName)
		BEGIN
			SET @Message = 'UserName already exists'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'UserName not exists'
			SET @Flag = 0
		END
END
GO
