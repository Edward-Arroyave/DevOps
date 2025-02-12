SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 30/03/2022
-- Description: Procedimiento almacenado para validar si el número de registro ya exiten.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Validate_RegistrationNumber]
(
	@RegistrationNumber varchar(20),
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT RegistrationNumber FROM TB_User WHERE RegistrationNumber = @RegistrationNumber)
		BEGIN
			SET @Message = 'Registration number already exists'
			SET @Flag = 1
		END 
	ELSE
		BEGIN
			SET @Message = 'Registration number not exists'
			SET @Flag = 0
		END
END
GO
