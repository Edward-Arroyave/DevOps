SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/03/2022
-- Description: Procedimiento almacenado para creación de usuario
-- =============================================
--DECLARE @UserContract UserContract, @IdUser_Out int, @Message varchar(50), @Flag bit 

--INSERT INTO @UserContract (IdContract, WaitingResult, PartialResult, FinishedResult) VALUES
--(73,0,0,1)--,(125,1,0,1)--,(),()

--EXEC [sp_Create_User_Prb] 1109,1,1,'852852852','Prueba','DBA',NULL,NULL,'1541','prbdba@dominio.co',NULL,NULL,NULL,NULL,'$argon2id$v=19$m=65536,t=3,p=1$ZCJsarpGm58LoHVtr9qAhA$Rxh7R4fja+LxlQ1LOh2QiE8VKnK3NPrPTTuOS9cWgfc',NULL,NULL,NULL,NULL,NULL,NULL,'9c64e0b8666665486f0357e66429f182c796672edbed93bf31325bf2f85af775',NULL,NULL,NULL,4,NULL,NULL,54,@UserContract,@IdUser_Out out, @Message out, @Flag out
----EXEC [sp_Create_User] 0,0,1,'15479951','dayron','empresa',NULL,'1999-02-11','1231654','userlistest2211@gmail.com',1,48,149,'userlistest2211','$argon2id$v=19$m=65536,t=3,p=1$FMJQY10j01PqwuN+NvafvQ$waYhyOk/t6AvGYZedsB/9RXSfY5o9lZp1ruPpSVzeLk',0,0,NULL,'1,2',1,1,'3f4ff40673acaf827a5fe22dd075b4050263296afe7befc5e38b60fab58cdf64',0,NULL,'',44,null,null,null,null,@IdUser_Out out, @Message out, @Flag out
--SELECT @IdUser_Out, @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_User]
(
	@IdUser int,
	@CompanyUser bit,
	@IdIdentificationType int,
	@IdentificationNumber varchar(20),
	@Name varchar(60),
	@LastName varchar(60),
	@RegistrationNumber varchar(20) = NULL,
	@BirthDate date = NULL,
	@TelephoneNumber varchar(20),
	@Email varchar(100),
	@IdRole int = NULL,
	@IdCountry int = NULL,
	@IdCity int = NULL,
	@UserName varchar(50) = NULL,
	@Password varchar(100),
	@PasswordExpires bit = NULL,
	@IdPasswdRenewalPeriod tinyint = NULL,
	@PasswordExpirationDate date = NULL,
	@Profile varchar(10) = NULL,
	@IdProfession int = NULL,
	@IdEntailmentType int = NULL, 
	@EncryptedUser varchar(500),
	@AccountExpires bit = NULL,
	@ExpirationDate date = NULL,
	@ProfessionalSpeciality varchar(30) = NULL,
	@IdUserAction int,
	@PhotoNameContainer varchar(150) = NULL,
	@SignatureNameContainer varchar(150) = NULL,
	@IdCompany int = NULL,
	@UserContract UserContract READONLY,
	@UserNameAlternative varchar(50) = NULL,
	@IdInstitution int = NULL,
	@IdUser_Out int out,
	@Message varchar(100) out,
	@Flag bit out
)
AS
	DECLARE @IdProfile int, @IdProfessionalSpeciality int, @IdContract int, @Position int, @Position1 int, @IdentificationCode varchar(5)
	DECLARE @TableProfessionalSpeciality table (IdUserSpecial int identity, IdUser int, IdProfessionalSpeciality int)
	DECLARE @TableProfile table (IdUserProfile int, IdUser int, IdProfile int)
	DECLARE @TableContract table (IdUser int, IdContract int)
BEGIN
    SET NOCOUNT ON

	IF @CompanyUser = 0
		BEGIN
			IF @IdUser = 0
				BEGIN
					-- Se valida si el usuario recibido ya existe
					IF EXISTS (SELECT UserName FROM TB_User WHERE UserName = @UserName AND CompanyUser = 0)
						BEGIN
							SET @Message = 'User already exists'
							SET @Flag = 0
						END
					-- Se valida si el tipo y número de documento recibido ya existe
					ELSE IF EXISTS (SELECT IdIdentificationType, IdentificationNumber FROM TB_User WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber AND CompanyUser = 0)
						BEGIN
							SET @Message = 'Document number already exists'
							SET @Flag = 0
						END
					-- Se valida si el correo ya existe
					ELSE IF EXISTS (SELECT RegistrationNumber FROM TB_User WHERE RegistrationNumber = @RegistrationNumber)
						BEGIN
							SET @Message = 'RegistrationNumber already exists'
							SET @Flag = 0
						END
					ELSE IF EXISTS (SELECT Email FROM TB_User WHERE Email = @Email AND CompanyUser = 0)
						BEGIN
							SET @Message = 'Mail already exists'
							SET @Flag = 0
						END
					ELSE
						BEGIN
							INSERT INTO TB_User (IdIdentificationType,IdentificationNumber,Name,LastName,BirthDate, IdCountry, IdCity, TelephoneNumber,Email, IdRole,UserName, Password, PasswordExpires, IdPasswdRenewalPeriod, PasswordExpirationDate, AccountExpires, ExpirationDate, RegistrationNumber, IdProfession, IdEntailmentType, EncryptedUser, PhotoNameContainer, SignatureNameContainer, CompanyUser, CreationDate, IdUserAction, Active, UserNameAlternative, IdInstitution)
							VALUES (@IdIdentificationType, @IdentificationNumber, @Name, @LastName, @BirthDate, @IdCountry, @IdCity, @TelephoneNumber, @Email, @IdRole, @UserName, @Password, @PasswordExpires, @IdPasswdRenewalPeriod, @PasswordExpirationDate, @AccountExpires, @ExpirationDate, @RegistrationNumber, @IdProfession, @IdEntailmentType, @EncryptedUser, @PhotoNameContainer, @SignatureNameContainer, @CompanyUser, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1, @UserNameAlternative, @IdInstitution)

							SET @IdUser_Out = SCOPE_IDENTITY()
							SET @IdUser = SCOPE_IDENTITY()

							-- Validar si la variable no este vacia.
							IF (@ProfessionalSpeciality != '') OR (@ProfessionalSpeciality IS NULL)
								BEGIN
									SET @ProfessionalSpeciality = @ProfessionalSpeciality + ','

									-- Validar que la posición de coma en la variable @Speciality sea diferente de 0
									WHILE PATINDEX('%,%', @ProfessionalSpeciality) <> 0
										BEGIN
											--Con la función Patindex asignar el valor a la varible @Position de acuerdo con la posición de la coma en la variable @Speciality
											SELECT @Position =  PATINDEX('%,%', @ProfessionalSpeciality)

											-- Asignar el valor de la variable antes de la posición de la coma
											SELECT @IdProfessionalSpeciality = LEFT(@ProfessionalSpeciality, @Position -1)

											SET @IdProfessionalSpeciality = (SELECT IdProfessionalSpeciality FROM TB_ProfessionalSpeciality WHERE IdProfessionalSpeciality = @IdProfessionalSpeciality)

											-- Inserta información en la tabla relación entre usuario y especialidad
											INSERT INTO TR_User_ProfessionalSpeciality (IdUser, IdProfessionalSpeciality, Active)
											VALUES (@IdUser, @IdProfessionalSpeciality, 1)

											-- Con la función STUFF se reemplaza la primera coma en la variable @Speciality por un espacio en blanco.
											SELECT @ProfessionalSpeciality = STUFF(@ProfessionalSpeciality, 1, @Position, '')
										END
								END
									
					
							IF (@Profile != '' OR @Profile IS NOT NULL)
								BEGIN
									SET @Profile = @Profile + ','

										-- Validar que la posición de coma en la variable @Profile sea diferente de 0
										WHILE PATINDEX('%,%', @Profile) <> 0
											BEGIN
												--Con la función Patindex asignar el valor a la varible @Position de acuerdo con la posición de la coma en la variable @Profile
												SELECT @Position1 = PATINDEX('%,%', @Profile)
												-- Asignar el valor de la variable antes de la posición de la coma
												SELECT @IdProfile = LEFT(@Profile, @Position1 -1)

												SET @IdProfile = (SELECT IdProfile FROM TB_Profile WHERE IdProfile = @IdProfile)

												-- Inserta información en la tabla relación entre usuario y perfil
												INSERT INTO TR_User_Profile (IdUser, IdProfile, CreationDate, IdUserAction, Active)
												VALUES (@IdUser, @IdProfile, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, 1)

												-- Con la función STUFF se reemplaza la primera coma en la variable @Profile por un espacio en blanco.
												SELECT @Profile = STUFF(@Profile, 1, @Position1,'')
										END
								END

							SET @Message = 'User created successfully'
							SET @Flag = 1
						END
				END
			ELSE
				BEGIN
					IF EXISTS (SELECT IdUser FROM TB_User WHERE IdUser = @IdUser)
						BEGIN
							UPDATE TB_User
								SET IdIdentificationType = @IdIdentificationType,
									IdentificationNumber = @IdentificationNumber,
									Name = @Name,
									LastName = @LastName,
									BirthDate = @BirthDate,
									IdCountry = @IdCountry,
									IdCity = @IdCity,
									TelephoneNumber = @TelephoneNumber,
									Email = @Email,
									IdRole = @IdRole,
									UserName = @UserName,
									PasswordExpires = @PasswordExpires,
									IdPasswdRenewalPeriod = @IdPasswdRenewalPeriod,
									PasswordExpirationDate = @PasswordExpirationDate,
									AccountExpires = @AccountExpires,
									ExpirationDate = @ExpirationDate,
									RegistrationNumber = @RegistrationNumber,
									IdProfession = @IdProfession,
									IdEntailmentType = @IdEntailmentType,
									EncryptedUser = @EncryptedUser,
									UpdateDate = DATEADD(HOUR,-5,GETDATE()),
									UserNameAlternative = @UserNameAlternative,
									IdInstitution = @IdInstitution,
									IdUserAction = @IdUserAction
							WHERE IdUser = @IdUser

							---- Validar si la variable no está vacia.
							IF (@ProfessionalSpeciality != '') OR (@ProfessionalSpeciality IS NULL)
								BEGIN
									SET @ProfessionalSpeciality = @ProfessionalSpeciality + ','

									-- Validar que la posición de coma en la variable @Speciality sea diferente de 0
									WHILE PATINDEX('%,%',@ProfessionalSpeciality) <> 0
										BEGIN
											--Con la función Patindex asignar el valor a la varible @Position de acuerdo con la posición de la coma en la variable @Speciality
											SELECT @Position = PATINDEX('%,%', @ProfessionalSpeciality)
											-- Asignar el valor de la variable antes de la posición de la coma
											SELECT @IdProfessionalSpeciality = LEFT(@ProfessionalSpeciality, @Position -1)

											INSERT INTO @TableProfessionalSpeciality (IdUser, IdProfessionalSpeciality)
											(SELECT DISTINCT IdUser, @IdProfessionalSpeciality FROM TR_User_ProfessionalSpeciality WHERE IdUser = @IdUser)

											--Con la función STUFF se reemplaza la primera coma en la variable @Speciality por un espacio en blanco.
											SELECT @ProfessionalSpeciality =  STUFF(@ProfessionalSpeciality,1,@Position,'')
										END

										--Con la instrucción MERGE se comparan los datos de la tabla TR_User_Speciality y los de la variable tipo tabla @TableSpeciality.
										MERGE TR_User_ProfessionalSpeciality  AS TARGET
										USING
											(SELECT IdUserSpecial, IdUser, IdProfessionalSpeciality, 1 as Active FROM @TableProfessionalSpeciality) SOURCE
										ON TARGET.IdUser = SOURCE.IdUser
											AND TARGET.IdProfessionalSpeciality = SOURCE.IdProfessionalSpeciality
										-- Cuando la información no coincide en TR_User_Speciality, inserta la información en la misma.
										WHEN NOT MATCHED BY TARGET
										THEN
											INSERT (IdUser, IdProfessionalSpeciality, Active)
											VALUES
												(
												SOURCE.IdUser,
												SOURCE.IdProfessionalSpeciality,
												SOURCE.Active
												)
										-- Cuando la información no coincide en la tabla @TableSpeciality
										WHEN NOT MATCHED BY SOURCE AND TARGET.IdUser = @IdUser AND TARGET.Active = 1
											THEN
												--Actualizar el estado a inactivo
												UPDATE
													SET TARGET.Active = 0
										WHEN MATCHED AND TARGET.Active = 0
											THEN
												UPDATE
													SET TARGET.Active = 1;

								END

							---Validar si la variable no está vacia.
							IF (@Profile != '' OR @Profile IS NOT NULL)
								BEGIN
									SET @Profile = @Profile + ','
										
										-- Validar que la posición de coma en la variable @Role sea diferente de 0
										WHILE PATINDEX('%,%',@Profile) <> 0
											BEGIN
												--Con la función Patindex asignar el valor a la varible @Position de acuerdo con la posición de la coma en la variable @Role
												SELECT @Position = PATINDEX('%,%', @Profile)
												-- Asignar el valor de la variable antes de la posición de la coma
												SELECT @IdProfile = LEFT(@Profile, @Position -1)

												BEGIN
													--Insertar información de una variable tipo tabla.
													INSERT INTO @TableProfile (IdUser, IdProfile)
													VALUES (@IdUser, @IdProfile)
													--(SELECT DISTINCT IdUser, @IdProfile FROM TR_User_Profile WHERE IdUser = @IdUser)
												END

												--Con la función STUFF se reemplaza la primera coma en la variable @Role por un espacio en blanco.
												SELECT @Profile =  STUFF(@Profile,1,@Position,'')
											END

											--Con la instrucción MERGE se comparan los datos de la tabla TR_User_Speciality y los de la variable tipo tabla @TableSpeciality.
											MERGE TR_User_Profile  AS TARGET
											USING
												(SELECT IdUserProfile, IdUser, IdProfile, 1 as Active, DATEADD(HOUR,-5,GETDATE()) UpdateDate FROM @TableProfile) SOURCE
											ON TARGET.IdUser = SOURCE.IdUser
												AND TARGET.IdProfile = SOURCE.IdProfile
											-- Cuando la información no coincide en TR_User_Speciality, inserta la información en la misma.
											WHEN NOT MATCHED BY TARGET
											THEN
												INSERT (IdUser, IdProfile, CreationDate, IdUserAction, Active)
												VALUES
													(
													SOURCE.IdUser,
													SOURCE.IdProfile,
													SOURCE.UpdateDate,
													@IdUserAction,
													SOURCE.Active
													)
											-- Cuando la información no coincide en la tabla @TableSpeciality
											WHEN NOT MATCHED BY SOURCE AND TARGET.IdUser = @IdUser AND TARGET.Active = 1
												THEN
													--Actualizar el estado a inactivo
													UPDATE
														SET TARGET.Active = 0,
															TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
															TARGET.IdUserAction = @IdUserAction
											WHEN MATCHED AND TARGET.Active = 0
												THEN
													UPDATE
														SET TARGET.Active = 1,
															TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
															TARGET.IdUserAction = @IdUserAction;
								END

							SET @Message = CONCAT('User ', @IdUser, ' updated successfully')
							SET @IdUser_Out = @IdUser
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = CONCAT('User ', @IdUser, ' not found')
							SET @IdUser_Out = @IdUser
							SET @Flag = 0
						END
				END
		END
	ELSE IF @CompanyUser = 1
		BEGIN
			IF @IdUser = 0
				BEGIN
					IF NOT EXISTS (SELECT IdUser FROM TB_User WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber AND CompanyUser = 1 AND Removed = 0)
						BEGIN
							IF NOT EXISTS (SELECT Email FROM TB_User WHERE Email = @Email AND CompanyUser = 1 AND Removed = 0)
								BEGIN
									SET @IdentificationCode = (SELECT IdentificationTypeCode FROM TB_IdentificationType WHERE IdIdentificationType = @IdIdentificationType)

									INSERT INTO TB_User (IdIdentificationType, IdentificationNumber, Name, LastName, Email, UserName, Password, TelephoneNumber, EncryptedUser, CompanyUser, IdCompany, IdUserAction, Active, CreationDate, IdInstitution)
									VALUES (@IdIdentificationType, @IdentificationNumber, @Name, @LastName, @Email, CONCAT(@IdentificationCode, @IdentificationNumber), @Password, @TelephoneNumber, @EncryptedUser, @CompanyUser, @IdCompany, @IdUserAction, 1, DATEADD(HOUR,-5,GETDATE()), @IdInstitution)

									SET @IdUser = SCOPE_IDENTITY()
									SET @IdUser_Out = @IdUser
									SET @Message = 'User created successfully'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'Email already exists'
									SET @Flag = 0
								END
						END
					ELSE
						BEGIN
							SET @Message = 'Username already exists'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					IF NOT EXISTS (SELECT IdUser FROM TB_User WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber AND CompanyUser = 1 AND Removed = 0 AND IdUser != @IdUser)
						BEGIN
							IF NOT EXISTS (SELECT Email FROM TB_User WHERE Email = @Email AND CompanyUser = 1 AND Removed = 0 AND IdUser != @IdUser)
								BEGIN
									SET @IdentificationCode = (SELECT IdentificationTypeCode FROM TB_IdentificationType WHERE IdIdentificationType = @IdIdentificationType)

									UPDATE TB_User
										SET IdIdentificationType = @IdIdentificationType,
											IdentificationNumber = @IdentificationNumber,
											Name = @Name,
											LastName = @LastName,
											Email = @Email,
											UserName = CONCAT(@IdentificationCode, @IdentificationNumber),
											TelephoneNumber = @TelephoneNumber,
											EncryptedUser = @EncryptedUser,
											IdCompany = @IdCompany,
											UpdateDate = DATEADD(HOUR,-5,GETDATE()),
											IdUserAction = @IdUserAction,
											IdInstitution = @IdInstitution
									WHERE IdUser = @IdUser

									SET @IdUser_Out = @IdUser
									SET @Message = 'User updated successfully'
									SET @Flag = 1
								END
							ELSE
								BEGIN
									SET @Message = 'Email already exists'
									SET @Flag = 0
								END
						END
					ELSE	
						BEGIN
							SET @Message = 'Username already exists'
							SET @Flag = 0
						END
				END		

			IF @IdUser != '' AND @IdUser IS NOT NULL
				BEGIN
					MERGE TR_User_Contract  AS TARGET
					USING @UserContract SOURCE
					ON TARGET.IdUser = @IdUser
						AND TARGET.IdContract = SOURCE.IdContract
					WHEN NOT MATCHED BY TARGET
					THEN
						INSERT (IdUser, IdContract, WaitingResult, PartialResult, FinishedResult)
						VALUES
							(
							@IdUser,
							SOURCE.IdContract,
							SOURCE.WaitingResult,
							SOURCE.PartialResult,
							SOURCE.FinishedResult
							)
					WHEN NOT MATCHED BY SOURCE AND TARGET.IdUser = @IdUser AND TARGET.Active = 1
						THEN
							UPDATE
								SET TARGET.Active = 0
					WHEN MATCHED
						THEN
							UPDATE
								SET TARGET.Active = 1,
									TARGET.WaitingResult = SOURCE.WaitingResult,
									TARGET.PartialResult = SOURCE.PartialResult,
									TARGET.FinishedResult = SOURCE.FinishedResult;
				END
		END
END
GO
