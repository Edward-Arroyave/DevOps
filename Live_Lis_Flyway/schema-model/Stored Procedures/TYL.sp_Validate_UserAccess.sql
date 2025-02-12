SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 2024/02/19
-- Description: Procedimiento almacenado realizar inicio de sesión en Tesoraría y logística Web y Mobile.
-- =============================================
--DECLARE @IdUser int, @EncryptedUser varchar(max), @Message varchar(50), @Flag bit
--EXEC [TYL].[sp_Validate_UserAccess] 2,1,@IdUser out, @EncryptedUser out, @Message out, @Flag out
--SELECT @IdUser, @EncryptedUser, @Message, @Flag
-- =============================================
CREATE PROCEDURE [TYL].[sp_Validate_UserAccess]
(
	@LoginType int, 
	@UserName varchar(50),
	@IdUser int out,
	@EncryptedUser varchar(max) out,
	@Message varchar(100) out,
	@Flag bit out
)
AS
	DECLARE @IdPatient int
BEGIN
    SET NOCOUNT ON

	-- @LoginType = 1 → Inicio de sesión Usuario Tesoreria y Logistica Web
	IF @LoginType = 1 
		BEGIN
			--Validar si el usuario existe 
			IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND CompanyUser = 0)
				BEGIN

					SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName AND CompanyUser = 0 )

					-- Validación si el usuario esta en estado activo
					IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND Active = 1 AND CompanyUser = 0 )
						BEGIN
							IF EXISTS (SELECT UserName 
							FROM TB_User 
							WHERE UserName = @UserName 
							AND AccessWebTreasuryLogistics = 1 AND CompanyUser = 0)
								BEGIN
									-- Validación para que si la contraseña ya expiro, se solicite cambio de la misma
									IF NOT EXISTS (	SELECT UserName 
													FROM TB_User 
													WHERE UserName = @UserName AND PasswordExpires = 1 
													AND PasswordExpirationDate <= DATEADD(HOUR,-5,GETDATE()) )
										BEGIN
											SELECT A.Name, A.LastName, A.Email, A.Password  FROM TB_User A WHERE A.UserName = @UserName

											SET @Message = 'Valid user to login'
											SET @Flag = 1
											SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName  )
											SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
										END
									ELSE
										BEGIN
											SET @Message = 'User password expired'
											SET @Flag = 0
											SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName )
											SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName )
										END
								END
							ELSE
								BEGIN
									SET @Message = 'The user does not have access to the treasury and logistics website'
									SET @Flag = 0
									SET @IdUser = 0
								END
						END
					ELSE
						BEGIN
							--Mensaje de usuario inactivo
							SET @Message = 'User inactive'
							SET @Flag = 0
							SET @IdUser = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'User does not exist'
					SET @Flag = 0
					SET @IdUser = 0
				END
		END

	-- @LoginType = 2 → Inicio de sesión Usuario Tesoreria y Logistica Mobile
	ELSE IF @LoginType = 2
		BEGIN
			--Validar si el usuario existe 
			IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND CompanyUser = 0 )
				BEGIN

					SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName AND CompanyUser = 0 )

					-- Validación si el usuario esta en estado activo
					IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND Active = 1  AND CompanyUser = 0)
						BEGIN
							IF EXISTS (SELECT UserName 
							FROM TB_User 
							WHERE UserName = @UserName 
							AND AccessMobileTreasuryLogistics = 1 )
								BEGIN
									-- Validación para que si la contraseña ya expiro, se solicite cambio de la misma
									IF NOT EXISTS (	SELECT UserName 
													FROM TB_User 
													WHERE UserName = @UserName AND PasswordExpires = 1 
													AND PasswordExpirationDate <= DATEADD(HOUR,-5,GETDATE()) )
										BEGIN
											SELECT A.Name, A.LastName, A.Email, A.Password  FROM TB_User A WHERE A.UserName = @UserName

											SET @Message = 'Valid user to login'
											SET @Flag = 1
											SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName )
											SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName )
										END
									ELSE
										BEGIN
											SET @Message = 'User password expired'
											SET @Flag = 0
											SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName )
											SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
										END
								END
							ELSE
								BEGIN
									SET @Message = 'The user does not have access to mobile treasury and logistics'
									SET @Flag = 0
									SET @IdUser = 0
								END
						END
					ELSE
						BEGIN
							--Mensaje de usuario inactivo
							SET @Message = 'User inactive'
							SET @Flag = 0
							SET @IdUser = 0
						END
				END
			ELSE
				BEGIN
					SET @Message = 'User does not exist'
					SET @Flag = 0
					SET @IdUser = 0
				END
		END
	END
GO
