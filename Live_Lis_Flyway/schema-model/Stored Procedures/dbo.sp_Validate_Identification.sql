SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 30/03/2022
-- Description: Procedimiento almacenado para validar si el nombre de usuario ya existe en base de datos.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Validate_Identification]
(
	@Option int,
	@IdIdentificationType tinyint,
	@IdentificationNumber varchar(20),
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	--Consultar si existe tipo y número de documento en la tabla usuarios
	IF @Option = 1
		BEGIN
			IF EXISTS (SELECT IdUser FROM TB_User WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
				BEGIN
					SET @Message = 'Identification type and number already exists'
					SET @Flag = 1
				END 
			ELSE
				BEGIN
					SET @Message = 'Identification type and number not exists'
					SET @Flag = 0
				END
		END
	--Consultar si existe tipo y número de documento en la tabla Pacientes
	ELSE IF @Option = 2
		BEGIN
			IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
				BEGIN
					SET @Message = 'Identification type and number already exists'
					SET @Flag = 1
				END 
			ELSE
				BEGIN
					SET @Message = 'Identification type and number not exists'
					SET @Flag = 0
				END
		END
END
GO
