SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado unificar paciente
-- =============================================
CREATE PROCEDURE [dbo].[sp_Unify_Patient]
(
    @IdIdentificationType_Old int, 
	@IdentificationNumber_Old varchar(20), 
	@IdIdentificationType_New int, 
	@IdentificationNumber_New varchar(20), 
	@IdUserAction int,
	@Message varchar(80) out,
	@Flag bit out
)
AS
	DECLARE @IdPatient_Old int, @IdPatient_New int
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE IdIdentificationType = @IdIdentificationType_Old AND IdentificationNumber = @IdentificationNumber_Old)
		BEGIN
			SET @IdPatient_Old = (SELECT IdPatient FROM TB_Patient WHERE IdIdentificationType = @IdIdentificationType_Old AND IdentificationNumber = @IdentificationNumber_Old)
			
			IF EXISTS (SELECT IdPatient FROM TB_Patient WHERE IdIdentificationType = @IdIdentificationType_New AND IdentificationNumber = @IdentificationNumber_New)
				BEGIN
					SET @IdPatient_New = (SELECT IdPatient FROM TB_Patient WHERE IdIdentificationType = @IdIdentificationType_New AND IdentificationNumber = @IdentificationNumber_New)

					DELETE TB_Patient
					WHERE IdPatient = @IdPatient_Old

					SET @Message = 'Successful patient unification'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'No patient found'
					SET @Flag = 0
				END
		END 
	ELSE
		BEGIN
			SET @Message = 'No patient found'
			SET @Flag = 0
		END
END
GO
