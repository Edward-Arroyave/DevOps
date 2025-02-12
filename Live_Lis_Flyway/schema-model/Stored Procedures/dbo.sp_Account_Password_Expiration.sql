SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 14/07/2022
-- Description: Procedimiento almacenado para validar expiración de cuenta y contraseña.
-- =============================================
-- EXEC [sp_Account_Password_Expiration]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Account_Password_Expiration]
AS
BEGIN
    SET NOCOUNT ON

	-- Expiración de cuenta por fecha definida
	UPDATE TB_User
		SET Active = 'False',
			UpdateDate = DATEADD(HOUR,-5,GETDATE())
	--SELECT * FROM TB_User
	WHERE Active = 'True'
		AND AccountExpires = 'True'
		AND ExpirationDate <= DATEADD(HOUR,-5,GETDATE()) 
	
	-- Expiración de cuenta por inactividad
	UPDATE TB_User
		SET Active = 'False',
			UpdateDate = DATEADD(HOUR,-5,GETDATE())
	---SELECT * FROM TB_User
	WHERE Active = 'True'
		AND AccountExpires = 'True'
		AND DATEDIFF(DD,SessionDate ,DATEADD(HOUR,-5,GETDATE())) >= 90 
END
GO
