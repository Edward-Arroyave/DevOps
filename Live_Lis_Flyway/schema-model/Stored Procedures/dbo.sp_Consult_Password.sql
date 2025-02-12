SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 09/03/2022
-- Description: Procedimiento almacenado para validar contraseña.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Password]
(
	@IdUser int,
	@Password varchar(120) out,
	@Message varchar(30) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdUser FROM TB_User WHERE IdUser = @IdUser)
		BEGIN
			SET @Password = (SELECT Password FROM TB_User WHERE IdUser = @IdUser)
			SET @Message = CONCAT('User password ', @IdUser)
			SET @Flag = 1
		END 
	ELSE
		BEGIN
			SET @Password = 0 
			SET @Message = 'User not found'
			SET @Flag = 0
		END
END
GO
