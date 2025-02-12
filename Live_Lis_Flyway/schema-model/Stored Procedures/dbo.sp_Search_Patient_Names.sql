SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- AuthAND:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/11/2021
-- Description: Procedimiento almacenado para buscar paciente pAND nombres.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Search_Patient_Names]
(
	@FirstName varchar(60) = NULL, 
	@SecondName varchar(60) = NULL, 
	@FirstLastName varchar(60) = NULL, 
	@SecondLastName varchar(60) = NULL,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	
BEGIN
	IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName OR SecondName = @SecondName OR FirstLastName = @FirstLastName OR SecondLastName = @SecondLastName)
		BEGIN
			-- Primer apellido, segundo nombre, primer apellido y segundo apellido
			IF @FirstName IS NOT NULL AND @SecondName IS NOT NULL AND @FirstLastName IS NOT NULL AND @SecondLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName AND SecondName = @SecondName AND FirstLastName = @FirstLastName AND SecondLastName = @SecondLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE A.FirstName = @FirstName
								AND A.SecondName = @SecondName
								AND A.FirstLastName = @FirstLastName
								AND A.SecondLastName = @SecondLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Primer nombre, segundo nombre y primer apellido
			ELSE IF @FirstName IS NOT NULL AND @SecondName IS NOT NULL AND @FirstLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName AND SecondName = @SecondName AND FirstLastName = @FirstLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstName = @FirstName
								AND SecondName = @SecondName
								AND FirstLastName = @FirstLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Primer nombre, Primer apellido y segundo apellido
			ELSE IF @FirstName IS NOT NULL AND @FirstLastName IS NOT NULL AND @SecondLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName AND FirstLastName = @FirstLastName AND SecondLastName = @SecondLastName)
						BEGIN						
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstName = @FirstName
								AND FirstLastName = @FirstLastName
								AND SecondLastName = @SecondLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Segundo nombre, Primer apellido y segundo apellido
			ELSE IF @SecondName IS NOT NULL AND @FirstLastName IS NOT NULL AND @SecondLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE SecondName = @SecondName AND FirstLastName = @FirstLastName AND SecondLastName = @SecondLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE SecondName = @SecondName
								AND FirstLastName = @FirstLastName
								AND SecondLastName = @SecondLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Segundo nombre y primer apellido
			ELSE IF @SecondName IS NOT NULL AND @FirstLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE SecondName = @SecondName AND FirstLastName = @FirstLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE SecondName = @SecondName
								AND FirstLastName = @FirstLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END	
			-- Primer nombre y segundo nombre
			ELSE IF @FirstName IS NOT NULL AND @SecondName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName AND SecondName = @SecondName)
						BEGIN		
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstName = @FirstName
								AND SecondName = @SecondName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0 
						END
				END
			-- Primer nombre y primer apellido
			ELSE IF @FirstName IS NOT NULL AND @FirstLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName AND FirstLastName = @FirstLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstName = @FirstName
								AND FirstLastName = @FirstLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Primer nombre y segundo apellido
			ELSE IF @FirstName IS NOT NULL AND @SecondLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName AND SecondLastName = @SecondLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstName = @FirstName
								AND SecondLastName = @SecondLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Primer apellido y segundo apellido
			ELSE IF @FirstLastName IS NOT NULL AND @SecondLastName IS NOT NULL
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstLastName = @FirstLastName AND SecondLastName = @SecondLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstLastName = @FirstLastName
								AND SecondLastName = @SecondLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END 
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			--Primer nombre
			ELSE IF @FirstName IS NOT NULL 
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstName = @FirstName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstName = @FirstName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Primer apellido
			ELSE IF @FirstLastName IS NOT NULL 
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE FirstLastName = @FirstLastName) 
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE FirstLastName = @FirstLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Segundo nombre
			ELSE IF @SecondName IS NOT NULL 
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE SecondName = @SecondName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE SecondName = @SecondName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
			-- Segundo apellido
			ELSE IF @SecondLastName IS NOT NULL 
				BEGIN
					IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE SecondLastName = @SecondLastName)
						BEGIN
							SELECT A.IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names
							FROM TB_Patient A
							INNER JOIN TB_IdentificationType B
								ON B.IdIdentificationType = A.IdIdentificationType
							WHERE SecondLastName = @SecondLastName

							SET @Message = 'Patient found'
							SET @Flag = 1
						END
					ELSE
						BEGIN
							SET @Message = 'Patient not found'
							SET @Flag = 0
						END
				END
		END
	ELSE
		BEGIN
			SET @Message = 'Patient not found'
			SET @Flag = 0
		END
END
GO
