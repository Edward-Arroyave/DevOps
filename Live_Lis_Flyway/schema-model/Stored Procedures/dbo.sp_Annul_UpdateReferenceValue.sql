SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/05/2023
-- Description: Procedimiento almacenado para anular programación de cambio de valores de referencia.
-- =============================================
--DECLARE @Message varchar(60), @Flag bit 
--EXEC [sp_Annul_UpdateReferenceValue] 2,53,4,@Message out, @Flag out
--SELECT @Message, @Flag
-- =============================================
CREATE PROCEDURE [dbo].[sp_Annul_UpdateReferenceValue]
(
	@Option int, -- 1 → Anular 2 → Retornar
	@IdRefValueChange int,
	@IdUserAction int,
	@Message varchar(60) out,
	@Flag bit out
)
AS
	DECLARE @IdReferenceValue int, @IdRefValueChangeReturn int, @ChangeConsec int = 1
BEGIN
    SET NOCOUNT ON

	SET @IdReferenceValue = (SELECT DISTINCT IdReferenceValue FROM TB_RefValueChange WHERE IdRefValueChange = @IdRefValueChange)
	
	-- 1 → Anular
	IF @Option = 1
		BEGIN
			IF (SELECT IdRefValueChangeStatus FROM TB_RefValueChange WHERE IdRefValueChange = @IdRefValueChange) = 1
				BEGIN 
					UPDATE TB_RefValueChange
						SET IdRefValueChangeStatus = 3,
							IdUserAction = @IdUserAction
					WHERE IdRefValueChange = @IdRefValueChange

					SET @Message = 'Successfully canceled reference value'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'Reference value update cannot be cancel'
					SET @Flag = 0
				END
		END
	-- 2 → Retornar
	ELSE IF @Option = 2
		BEGIN
			IF (SELECT IdRefValueChangeStatus FROM TB_RefValueChange WHERE IdRefValueChange = @IdRefValueChange) = 2 AND NOT EXISTS (SELECT IdRefValueChangeStatus FROM TB_RefValueChange WHERE IdReferenceValue = @IdReferenceValue AND IdRefValueChangeStatus = 1 AND IdRefValueChange != @IdReferenceValue)
				BEGIN
					SET @ChangeConsec = @ChangeConsec + (SELECT COUNT(*) FROM TB_RefValueChange WHERE IdReferenceValue = @IdReferenceValue AND ChangeConsec != 0)
					SET @IdRefValueChangeReturn = (SELECT IdRefValueChange
													FROM (
														SELECT IdRefValueChange, ROW_NUMBER () OVER (PARTITION BY IdReferenceValue ORDER BY ChangeConsec DESC) Unico
														FROM TB_RefValueChange
														WHERE IdReferenceValue = @IdReferenceValue
															AND IdRefValueChangeStatus = 2
															AND IdRefValueChange != @IdRefValueChange
														) SOURCE
													WHERE Unico = 1)

					INSERT INTO TB_RefValueChange (IdReferenceValue, ChangeConsec, IdExamTechnique, IdMedicalDevice, IdReactive, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, ScheduledUpdateDate, IdRefValueChangeStatus, CreationDate, IdUserAction)
					SELECT IdReferenceValue, @ChangeConsec, IdExamTechnique, IdMedicalDevice, IdReactive, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, DATEADD(HOUR,-5,GETDATE()), 4, DATEADD(HOUR,-5,GETDATE()), @IdUserAction
					FROM TB_RefValueChange
					WHERE IdRefValueChange = @IdRefValueChangeReturn

					UPDATE A
						SET IdExamTechnique = B.IdExamTechnique,
							IdMedicalDevice = B.IdMedicalDevice,
							IdReactive = B.IdReactive,
							IdBiologicalSex = B.IdBiologicalSex,
							MinAge = B.MinAge,
							MaxAge = B.MaxAge,
							IdAgeTimeUnit = B.IdAgeTimeUnit,
							IdUnitOfMeasurement = B.IdUnitOfMeasurement,
							IdDataType = B.IdDataType,
							InitialValue = B.InitialValue,
							FinalValue = B.FinalValue,
							IdExpectedValue = B.IdExpectedValue,
							CodificationText = B.CodificationText
					FROM TB_ReferenceValue A
					INNER JOIN TB_RefValueChange B
						ON B.IdReferenceValue = A.IdReferenceValue
					WHERE A.IdReferenceValue = @IdReferenceValue
						AND B.IdRefValueChange = @IdRefValueChangeReturn

					SET @Message = 'Successfully updated reference value'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'It is not possible to return change of reference values'
					SET @Flag = 0
				END
		END
END
GO
