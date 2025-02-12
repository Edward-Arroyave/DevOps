SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/09/2023
-- Description: Procedimiento almacenado realizar inicio de sesión.
-- =============================================
--DECLARE @IdUser int, @EncryptedUser varchar(max), @Message varchar(50), @Flag bit
--EXEC [WebResult].[sp_Validate_UserAccess] 2,1,'15479951789400121',@IdUser out, @EncryptedUser out, @Message out, @Flag out
--SELECT @IdUser, @EncryptedUser, @Message, @Flag
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Validate_UserAccess]
(
	@LoginType int, 
	@IdIdentificationType int = NULL,  
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

	SET @IdPatient = (SELECT IdPatient FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @UserName)

	-- @LoginType = 1 → Inicio de sesión Usuario del Sistema 
	IF @LoginType = 1 
		BEGIN
			--Validar si el usuario existe y que se encuentre en estado activo
			IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND CompanyUser = 'False')
				BEGIN
					SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName AND CompanyUser = 'False')

					-- Validación si el usuario esta en estado activo
					IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND Active = 'True')
						BEGIN
							IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND AccessResultWeb = 'True')
								BEGIN
									-- Validación de que el usuario sea correcto y el campo de inicio de sesión sea vacio
									IF NOT EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND SessionDate IS NULL)
										BEGIN
											-- Validación para que si la contraseña ya expiro, se solicite cambio de la misma
											IF NOT EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND PasswordExpires = 'True' AND PasswordExpirationDate <= DATEADD(HOUR,-5,GETDATE()))
												BEGIN		
													--Validación de que el usuario este asociadoa la sede
													IF EXISTS (SELECT IdUser FROM TR_User_AttentionCenter WHERE IdUser = @IdUser)
														BEGIN
															SELECT A.Name, A.LastName, A.Email, A.Password  FROM TB_User A WHERE A.UserName = @UserName

															SET @Message = 'Valid user to login'
															SET @Flag = 1
															SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)
															SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
														END
													ELSE
														BEGIN
															SET @Message = 'User not associated with the AttentionCenter'
															SET @Flag = 0
															SET @IdUser = 0
														END
												END
											ELSE
												BEGIN
													SET @Message = 'User password expired'
													SET @Flag = 0
													SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)
													SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
												END
										END
									ELSE
										BEGIN
											SELECT A.Name, A.LastName, A.Email, A.Password  FROM TB_User A WHERE A.UserName = @UserName
											
											-- Mensaje de inicio de sesión por primera vez
											SET @Message = 'First time session'
											SET @Flag = 0
											SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)
											SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName)
										END
								END
							ELSE
								BEGIN
									SET @Message = 'User does not have access to the results portal'
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
	-- @LoginType = 2 → Inicio de sesión usuario empresa.
	ELSE IF @LoginType = 2
		BEGIN
			--Validar si el usuario existe y que se encuentre en estado activo
			IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName  AND CompanyUser = 'True' AND Removed = 'False')
				BEGIN
					SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName AND CompanyUser = 'True' AND Removed = 'False')

					-- Validación si el usuario esta en estado activo
					IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND Active = 'True' AND Removed = 'False')
						BEGIN
							-- Validación de que el usuario sea correcto y el campo de inicio de sesión sea vacio
							IF NOT EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND SessionDate IS NULL AND Removed = 'False')
								BEGIN
									SELECT A.Name, A.LastName, A.Email, A.Password  FROM TB_User A WHERE A.UserName = @UserName AND Removed = 'False'

									SET @Message = 'Valid user to login'
									SET @Flag = 1
									SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName AND Removed = 'False')
									SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName AND Removed = 'False')
								END
							ELSE
								BEGIN
									SELECT A.Name, A.LastName, A.Email, A.Password  FROM TB_User A WHERE A.UserName = @UserName AND Removed = 'False'

									-- Mensaje de inicio de sesión por primera vez
									SET @Message = 'First time session'
									SET @Flag = 0
									SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName AND Removed = 'False')
									SET @EncryptedUser = (SELECT  EncryptedUser FROM TB_User WHERE UserName = @UserName AND Removed = 'False')
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
	--- @LoginType = 3 → Inicio de sesión de pacientes
	ELSE IF @LoginType = 3
		BEGIN
			--Validar si el usuario existe y que se encuentre en estado activo
			IF EXISTS (SELECT IdentificationNumber FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @UserName)
				BEGIN
					IF EXISTS (SELECT IdPatient FROM carehis.TB_Patient_Ext WHERE IdPatient = @IdPatient AND Active_LIS = 'True')
						BEGIN
							IF EXISTS (SELECT IdPatient FROM carehis.TB_Patient_Ext WHERE IdPatient = @IdPatient AND AccessResultWeb = 'True')
								BEGIN	
									IF EXISTS (SELECT B.IdRequest FROM carehis.TB_Patient_Ext A INNER JOIN TB_Request B ON B.IdPatient = A.IdPatient WHERE A.IdIdentificationType = @IdIdentificationType AND A.IdentificationNumber = @UserName)
										BEGIN
											IF EXISTS (SELECT IdPatient FROM carehis.TR_Patient_DataProcPolicy_Ext WHERE IdPatient = @IdPatient AND DataBaseSource = 2 AND AcceptDataProcessingPolicy = 'True' AND ExpirationDataProcessingPolicy >= CONVERT(date,DATEADD(HOUR,-5,GETDATE())))
												BEGIN
													-- Validación de que el usuario sea correcto y el campo de inicio de sesión sea vacio
													IF NOT EXISTS (SELECT IdentificationNumber FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @UserName AND ResultWeb_SessionDate IS NULL)
														BEGIN
															SELECT CONCAT(FirstName, ' ', SecondName) AS Name, CONCAT(FirstLastName, ' ', SecondLastName) AS LastName, Email, ResultWeb_Password AS Password, DataBaseSource  FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @UserName

															SET @Message = 'Valid user to login'
															SET @Flag = 1
															SET @IdUser = (SELECT IdPatient FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @UserName)
															SET @EncryptedUser = (SELECT ResultWeb_EncryptedPatient FROM carehis.TB_Patient_Ext WHERE IdentificationNumber = @UserName)
														END
													ELSE
														BEGIN
															SELECT CONCAT(FirstName, ' ', SecondName) AS Name, CONCAT(FirstLastName, ' ', SecondLastName) AS LastName, Email, ResultWeb_Password AS Password, DataBaseSource  FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @UserName

															-- Mensaje de inicio de sesión por primera vez
															SET @Message = 'First time session'
															SET @Flag = 0
															SET @IdUser = (SELECT IdPatient FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @UserName)
															SET @EncryptedUser = (SELECT ResultWeb_EncryptedPatient FROM carehis.TB_Patient_Ext WHERE IdentificationNumber = @UserName)
														END
												END
											ELSE
												BEGIN
													SET @Message = 'Data processing policy not accepted'
													SET @Flag = 0
													SET @IdUser = 0
												END
										END
									ELSE
										BEGIN
											SET @Message = 'User has no requests'
											SET @Flag = 0
											SET @IdUser = 0
										END
								END
							ELSE
								BEGIN
									SET @Message = 'Patient does not have access to results portal'
									SET @Flag = 0
									SET @IdUser = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Inactive patient'
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
