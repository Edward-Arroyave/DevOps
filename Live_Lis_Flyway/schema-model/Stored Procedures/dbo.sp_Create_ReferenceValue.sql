SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/12/2022
-- Description: Procedimiento almacenado para crear valor de referencia de Analito.
-- =============================================
/*
begin tran
DECLARE @Message varchar(50), @Flag bit
EXEC [sp_Create_ReferenceValue] 1701,12975,2,1,0,0,110,3,219,19,2,15,60,8,'','2023-10-16',2, @Message out, @Flag out
SELECT @Message, @Flag
rollback
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_ReferenceValue]
(
	@IdReferenceValue int,
	@IdAnalyte int, 
	@IdMedicalDevice int, 
	@IdReactive int,
	@IdBiologicalSex int, 
	@MinAge int, 
	@MaxAge int, 
	@IdAgeTimeUnit int, 
	@IdExamTechnique int = NULL, 
	@IdUnitOfMeasurement int = NULL, 	 
	@IdDataType int = NULL, 
	@InitialValue varchar (30) = NULL, 
	@FinalValue varchar (30) = NULL, 
	@IdExpectedValue int = NULL, 
	@CodificationText varchar(max) = NULL, 
	@ScheduledUpdateDate date = NULL,
	@QualitativeInitialValue bit = NULL,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
	DECLARE @ChangeConsec int = 1
BEGIN
    SET NOCOUNT ON

	IF @IdReferenceValue = 0
		BEGIN
			INSERT INTO TB_ReferenceValue (IdAnalyte, IdExamTechnique, IdMedicalDevice, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, IdUnitOfMeasurement, IdReactive, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, ScheduledUpdateDate, Status, Active, CreationDate, IdUserAction, QualitativeInitialValue)
			VALUES (@IdAnalyte, @IdExamTechnique, @IdMedicalDevice, @IdBiologicalSex, @MinAge, @MaxAge, @IdAgeTimeUnit, @IdUnitOfMeasurement, @IdReactive, @IdDataType, @InitialValue, @FinalValue, @IdExpectedValue, @CodificationText, @ScheduledUpdateDate, 1, 1, DATEADD(HOUR,-5,GETDATE()), @IdUserAction, @QualitativeInitialValue) 
			
			SET @IdReferenceValue = SCOPE_IDENTITY ()

			INSERT INTO TB_RefValueChange (IdReferenceValue, ChangeConsec, IdExamTechnique, IdMedicalDevice, IdReactive, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, ScheduledUpdateDate, IdRefValueChangeStatus, CreationDate, IdUserAction) --, QualitativeInitialValue)
			VALUES (@IdReferenceValue, 0, @IdExamTechnique, @IdMedicalDevice, @IdReactive, @IdBiologicalSex, @MinAge, @MaxAge, @IdAgeTimeUnit, @IdUnitOfMeasurement, @IdDataType, @InitialValue, @FinalValue, @IdExpectedValue, @CodificationText, DATEADD(HOUR,-5,GETDATE()), 2, DATEADD(HOUR,-5,GETDATE()), @IdUserAction) --, @QualitativeInitialValue)

			SET @Message = 'Successfully created reference value'
			SET @Flag = 1
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT IdReferenceValue FROM TB_RefValueChange WHERE IdReferenceValue = @IdReferenceValue AND IdRefValueChangeStatus = 1)
				BEGIN
					SET @ChangeConsec = @ChangeConsec + (SELECT COUNT(*) FROM TB_RefValueChange WHERE IdReferenceValue = @IdReferenceValue AND ChangeConsec != 0)

					INSERT INTO TB_RefValueChange (IdReferenceValue, ChangeConsec, IdExamTechnique, IdMedicalDevice, IdReactive, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, ScheduledUpdateDate, IdRefValueChangeStatus, CreationDate, IdUserAction) --, QualitativeInitialValue)
					VALUES (@IdReferenceValue, @ChangeConsec, @IdExamTechnique, @IdMedicalDevice, @IdReactive, @IdBiologicalSex, @MinAge, @MaxAge, @IdAgeTimeUnit, @IdUnitOfMeasurement, @IdDataType, @InitialValue, @FinalValue, @IdExpectedValue, @CodificationText, @ScheduledUpdateDate, CASE WHEN @ScheduledUpdateDate = CONVERT(DATE,DATEADD(HOUR,-5,GETDATE())) THEN 2 ELSE 1 END, DATEADD(HOUR,-5,GETDATE()), @IdUserAction) --, @QualitativeInitialValue)

					IF @ScheduledUpdateDate = CONVERT(DATE,DATEADD(HOUR,-5,GETDATE()))
						BEGIN
							UPDATE TB_ReferenceValue
								SET IdAnalyte = @IdAnalyte,
									IdExamTechnique = @IdExamTechnique,
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
									QualitativeInitialValue = @QualitativeInitialValue,
									--Status = 1, 
									--Active = 1, 
									UpdateDate = DATEADD(HOUR,-5,GETDATE()), 
									IdUserAction = @IdUserAction
							WHERE IdReferenceValue = @IdReferenceValue
						END

					SET @Message = 'Successfully updated reference value'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Reference value already has a change scheduled'
					SET @Flag = 0
				END
		END
END
GO
