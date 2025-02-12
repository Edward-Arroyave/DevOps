SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 07/03/2022
-- Description: Procedimiento almacenado para cambiar contraseña de un usuario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Reset_UserPassword]
(
	@Password varchar(120),
	@EncryptedUser varchar(max),
	@FirstTime bit,
	@URL bit,
	@Message varchar(60) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

    IF EXISTS (SELECT IdUser FROM TB_User WHERE EncryptedUser = @EncryptedUser)
		BEGIN
			IF @FirstTime = 'True'
				BEGIN
					UPDATE TB_User
						SET SessionDate = DATEADD(HOUR,-5,GETDATE()),
						Password = @Password,
						PasswordExpirationDate = CASE WHEN (SELECT PasswordExpires FROM TB_User WHERE EncryptedUser = @EncryptedUser) = 1 THEN DATEADD(DAY,30,GETDATE()) ELSE NULL END,
						UpdateDate = DATEADD(HOUR,-5,GETDATE())
					WHERE EncryptedUser = @EncryptedUser
				END
			ELSE
				IF @URL = 'True'
					BEGIN
						IF (SELECT DATEDIFF(MINUTE, EncryptedUserDate, DATEADD(HOUR,-5,GETDATE())) FROM TB_User WHERE EncryptedUser = @EncryptedUser) <= 5
							BEGIN
								UPDATE TB_User
									SET Password = @Password,
									PasswordExpirationDate = CASE WHEN (SELECT PasswordExpires FROM TB_User WHERE EncryptedUser = @EncryptedUser) = 1 THEN DATEADD(DAY,30,GETDATE()) ELSE NULL END,
									UpdateDate = DATEADD(HOUR,-5,GETDATE())
								WHERE EncryptedUser = @EncryptedUser

								SET @Message = 'Password changed successfully'
								SET @Flag = 1
							END
						ELSE
							BEGIN
								SET @Message = 'Expired token'
								SET @Flag = 0
							END
					END
				ELSE
					BEGIN
						UPDATE TB_User
							SET Password = @Password,
							PasswordExpirationDate = CASE WHEN (SELECT PasswordExpires FROM TB_User WHERE EncryptedUser = @EncryptedUser) = 1 THEN DATEADD(DAY,30,GETDATE()) ELSE NULL END,
							UpdateDate = DATEADD(HOUR,-5,GETDATE())
						WHERE EncryptedUser = @EncryptedUser

						SET @Message = 'Password changed successfully'
						SET @Flag = 1
					END
		END
	ELSE
		BEGIN
			SET @Message = 'Unable to update password because user cannot be found'
			SET @Flag = 0
		END
END

GO
