SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para buscar paciente por tipo y número de documento.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Search_Patient]
(
	@IdIdentificationType int = NULL,
	@IdentificationNumber varchar(20),
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN

    SET NOCOUNT ON

	IF @IdIdentificationType IS NOT NULL
		BEGIN
			IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
				BEGIN
					SELECT IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names 
					FROM TB_Patient A
					INNER JOIN TB_IdentificationType B
						ON B.IdIdentificationType = A.IdIdentificationType
					WHERE A.IdIdentificationType = @IdIdentificationType
						AND A.IdentificationNumber = @IdentificationNumber
					
					SET @Message = 'Patient found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Patient not found'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE IdentificationNumber = @IdentificationNumber)
				BEGIN
					SELECT IdPatient, CONCAT_WS(' - ', B.IdentificationTypeCode, A.IdentificationNumber) Identification, CONCAT_WS(' ', A.FirstName, A.SecondName, A.FirstLastName, A.SecondLastName) Names 
					FROM TB_Patient A
					INNER JOIN TB_IdentificationType B
						ON B.IdIdentificationType = A.IdIdentificationType
					WHERE A.IdentificationNumber = @IdentificationNumber

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
GO
