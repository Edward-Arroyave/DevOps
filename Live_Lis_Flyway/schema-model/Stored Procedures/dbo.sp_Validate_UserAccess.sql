SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 07/03/2022
-- Description: Procedimiento almacenado para validar el acceso de un usuario al sistema.
-- =============================================
--DECLARE @IdUser int,@EncryptedUser varchar(max),@AttentionCenter varchar(50),@Message varchar(100),@Flag bit
--EXEC [sp_Validate_UserAccess] 'dayron.fuentes',1,	@IdUser out, @EncryptedUser out, @AttentionCenter out, @Message out, @Flag out
--SELECT @IdUser,@EncryptedUser,@AttentionCenter,@Message,@Flag 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Validate_UserAccess]
(
	@UserName varchar(50),
	--@IdAttentionCenter int,
	@IdUser int out,
	@EncryptedUser varchar(max) out,
	--@AttentionCenter varchar(50) out,
	@Message varchar(100) out,
	@Flag bit out
)
AS
	DECLARE @IdUsers int
BEGIN
	SET NOCOUNT ON

	SET @IdUsers = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)

	--Validar si el usuario existe y que se encuentre en estado activo
	IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName)
		BEGIN
			-- Validación si el usuario esta en estado activo
			IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND Active = 'True')
				BEGIN
					-- Validación de que el usuario sea correcto y el campo de inicio de sesión sea vacio
					IF NOT EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND SessionDate IS NULL)
						BEGIN
							-- Validación para que si la contraseña ya expiro, se solicite cambio de la misma
							IF NOT EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND PasswordExpires = 'True' AND PasswordExpirationDate <= DATEADD(HOUR,-5,GETDATE()))
								BEGIN		
									--Validación de que el usuario este asociadoa la sede
									IF EXISTS (SELECT IdUser FROM TR_User_AttentionCenter WHERE IdUser = @IdUsers /*AND IdAttentionCenter = @IdAttentionCenter*/)
										BEGIN
											SELECT A.Name, A.LastName, A.UserName, A.Email, /*B.IdRole*/ A.Password  FROM TB_User A /*INNER JOIN TR_User_Role B ON A.IdUser = B.IdUser */WHERE A.UserName = @UserName

											SET @Message = 'Valid user to login'
											SET @Flag = 1
											SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)
											SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
											--SET @AttentionCenter = (SELECT AttentionCenterName FROM TB_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)
										END
									ELSE
										BEGIN
											SET @Message = 'User not associated with the AttentionCenter'
											SET @Flag = 0
											SET @IdUser = 0
											--SET @AttentionCenter = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'User password expired'
									SET @Flag = 0
									SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)
									SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
									--SET @AttentionCenter = 0
								END
						END
					ELSE
						BEGIN
							-- Mensaje de inicio de sesión por primera vez
							SET @Message = 'First time session'
							SET @Flag = 0
							SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)
							SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
							--SET @AttentionCenter = (SELECT AttentionCenterName FROM TB_AttentionCenter WHERE IdAttentionCenter = @IdAttentionCenter)
						END			
				END
			ELSE
				BEGIN
					--Mensaje de usuario inactivo
					SET @Message = 'User inactive'
					SET @Flag = 0
					SET @IdUser = 0
				--	SET @AttentionCenter = 0
				END
		END
	ELSE
		BEGIN
			SET @Message = 'User does not exist'
			SET @Flag = 0
			SET @IdUser = 0
		--	SET @AttentionCenter = 0
		END
END
GO
