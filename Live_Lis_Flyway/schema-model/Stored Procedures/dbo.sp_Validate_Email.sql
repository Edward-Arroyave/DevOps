SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 09/03/2022
-- Description: Procedimiento almacenado para si un correo ya existe en base de datos.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Validate_Email]
(
	@Option int,
	@Email varchar(100),
	@IdUser int out,
	@EncryptedUser varchar(100) out,
	@Message varchar(30) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	--Consultar si existe correo en la tabla usuarios
	IF @Option = 1
		BEGIN
			IF EXISTS (SELECT Email FROM TB_User WHERE Email = @Email)
				BEGIN
					SET @IdUser = (SELECT IdUser FROM TB_User WHERE Email = @Email)
					SET @EncryptedUser = (SELECT EncryptedUser FROM TB_User WHERE Email = @Email)
					SET @Message = 'Email already exists'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @IdUser = 0
					SET @Message = 'Email not exists'
					SET @Flag = 0
				END
		END
	--Consultar si existe correo en la tabla pacientes
	ELSE IF @Option = 2
		BEGIN
			IF EXISTS (SELECT Email FROM TB_Patient WHERE Email = @Email)
				BEGIN
					IF EXISTS (SELECT Email FROM TB_Patient WHERE Email = @Email )
						BEGIN
							SET @IdUser = (SELECT IdPatient FROM TB_Patient WHERE Email = @Email)
							SET @Message = 'Email already exists'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @IdUser = (SELECT IdPatient FROM TB_Patient WHERE Email = @Email)
							SET @Message = 'User is inactive'
							SET @Flag = 0
						END
				END
			ELSE
				BEGIN
					SET @IdUser = 0
					SET @Message = 'Email not exists'
					SET @Flag = 0
				END
		END
END
GO
