SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 2023/09/15
-- Description: Procedimiento almacenado para validar y/o retornar contraseña asignada a paciente para ingreso a Consulta Web de Resultados
-- =============================================
--DECLARE @Password varchar(120), @Message varchar(50), @Flag bit
--EXEC [WebResult].[sp_Consult_PatientPassword] 1,'', @Password out, @Message out, @Flag out
--SELECT @Password, @Message, @Flag
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Consult_PatientPassword]
(
	@IdIdentificationType int,
	@IdentificationNumber varchar(20),
	@Password varchar(120) out,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF (SELECT ResultWeb_Password FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber) IS NOT NULL
		BEGIN
			SET @Password = (SELECT ResultWeb_Password FROM carehis.TB_Patient_Ext WHERE IdIdentificationType = @IdIdentificationType AND IdentificationNumber = @IdentificationNumber)
			SET @Message = 'Patient has a password assigned'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Password = NULL
			SET @Message = 'Patient does not have a password assigned'
			SET @Flag = 0
		END
END
GO
