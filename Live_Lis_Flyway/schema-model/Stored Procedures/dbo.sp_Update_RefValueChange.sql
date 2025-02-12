SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/12/2022
-- Description: Procedimiento almacenado para crear valor de referencia de Analito.
-- =============================================
--DECLARE @Message varchar(50), @Flag bit
--EXEC [sp_Create_ReferenceValue] 90,9597,3,2,1,0,100,2,1,1,1,100,500,2,'Pruebaaaa upd','2023-05-15',4, @Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_RefValueChange]
(
	@IdRefValueChange int,
	@IdExamTechnique int, 
	@IdMedicalDevice int, 
	@IdReactive int,
	@IdBiologicalSex int, 
	@MinAge int, 
	@MaxAge int, 
	@IdAgeTimeUnit int, 
	@IdUnitOfMeasurement int, 	 
	@IdDataType int, 
	@InitialValue decimal (7,3) = NULL, 
	@FinalValue decimal (7,3) = NULL, 
	@IdExpectedValue int = NULL, 
	@CodificationText varchar(max) = NULL, 
	@ScheduledUpdateDate date,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @IdReferenceValue int
BEGIN
    SET NOCOUNT ON

	SET @IdReferenceValue = (SELECT DISTINCT IdReferenceValue FROM TB_RefValueChange WHERE IdRefValueChange = @IdRefValueChange)

	IF (SELECT IdRefValueChangeStatus FROM TB_RefValueChange WHERE IdRefValueChange = @IdRefValueChange) = 1
		BEGIN
			UPDATE TB_RefValueChange
				SET IdExamTechnique = @IdExamTechnique,
					IdMedicalDevice = @IdMedicalDevice,
					IdReactive = @IdReactive,
					IdBiologicalSex = @IdBiologicalSex,
					MinAge = @MinAge,
					MaxAge = @MaxAge,
					IdAgeTimeUnit = @IdAgeTimeUnit, 
					IdUnitOfMeasurement = @IdUnitOfMeasurement,
					IdDataType = @IdDataType,
					InitialValue = @InitialValue,
					FinalValue = @FinalValue,
					IdExpectedValue = @IdExpectedValue,
					CodificationText = @CodificationText,
					ScheduledUpdateDate = @ScheduledUpdateDate,
					UpdateDate = DATEADD(HOUR,-5,GETDATE()),
					IdUserAction = @IdUserAction	
			WHERE IdRefValueChange = @IdRefValueChange

			IF @ScheduledUpdateDate = CONVERT(DATE,DATEADD(HOUR,-5,GETDATE()))
				BEGIN
					UPDATE TB_ReferenceValue
						SET IdExamTechnique = @IdExamTechnique,
							IdMedicalDevice = @IdMedicalDevice, 
							IdBiologicalSex = @IdBiologicalSex, 
							MinAge = @MinAge, 
							MaxAge = @MaxAge, 
							IdAgeTimeUnit = @IdAgeTimeUnit, 
							IdUnitOfMeasurement = @IdUnitOfMeasurement, 
							IdReactive = @IdReactive, 
							IdDataType = @IdDataType, 
							InitialValue = @InitialValue, 
							FinalValue = @FinalValue, 
							IdExpectedValue = @IdExpectedValue, 
							CodificationText = @CodificationText, 
							UpdateDate = DATEADD(HOUR,-5,GETDATE()), 
							IdUserAction = @IdUserAction
					WHERE IdReferenceValue = @IdReferenceValue

					UPDATE TB_RefValueChange
						SET IdRefValueChangeStatus = 2
					WHERE IdRefValueChange = @IdRefValueChange
				END

			SET @Message = 'Successfully updated reference value'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'Reference values ​​cannot be updated'
			SET @Flag = 0
		END
END
GO
