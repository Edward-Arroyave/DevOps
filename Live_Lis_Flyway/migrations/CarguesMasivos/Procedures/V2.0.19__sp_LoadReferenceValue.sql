/****** Object:  StoredProcedure [dbo].[sp_LoadReferenceValue]    Script Date: 19/02/2025 11:56:38 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_LoadReferenceValue]
    @ReferenceValueList LoadReferenceValue READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    BEGIN TRY
        
		DECLARE @RefValueChange TABLE (
            IdReferenceValue INT
        );

       
		INSERT INTO TB_ReferenceValue (
            IdAnalyte, IdExamTechnique, IdReactive, IdMedicalDevice, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit,
            IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText,
            ScheduledUpdateDate, Status, Active, CreationDate, IdUserAction
        )
        OUTPUT inserted.IdReferenceValue INTO @RefValueChange
        SELECT 
            B.IdAnalyte, C.IdExamTechnique, H.IdReactive, D.IdMedicalDevice, E.IdBiologicalSex, A.MinAge, A.MaxAge, F.IdTimeUnit,
            G.IdUnitOfMeasurement, I.IdDataType, A.InitialValue, A.FinalValue, J.IdExpectedValue, A.CodificationText,
            @Date AS ScheduledUpdateDate, 1 AS Status, 1 AS Active, DATEADD(HOUR, -5, GETDATE()) AS CreationDate, @IdUser AS IdUserAction
        FROM @ReferenceValueList A
        INNER JOIN TB_Analyte B ON B.AnalyteCode = A.AnalyteCode
        INNER JOIN TB_ExamTechnique C ON C.ExamTechnique = A.ExamTechnique
		INNER JOIN TB_Reactive H ON H.Reactive = A.Reactive
        INNER JOIN TB_MedicalDevice D ON D.MedicalDevice = A.MedicalDevice
        INNER JOIN TB_BiologicalSex E ON E.BiologicalSex = A.BiologicalSex
        INNER JOIN TB_TimeUnit F ON F.TimeUnit = A.AgeTimeUnit
        INNER JOIN TB_UnitOfMeasurement G ON G.UnitOfMeasurement = A.UnitOfMeasurement
        INNER JOIN TB_DataType I ON I.DataType = A.DataType
        LEFT JOIN TB_ExpectedValue J ON J.ExpectedValue = A.ExpectedValue;

        
		INSERT INTO TB_RefValueChange (
            IdReferenceValue, ChangeConsec, IdExamTechnique, IdMedicalDevice, IdReactive, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit,
            IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, ScheduledUpdateDate,
            IdRefValueChangeStatus, CreationDate, IdUserAction
        )
        SELECT 
            IdReferenceValue, 0 AS ChangeConsec, IdExamTechnique, IdMedicalDevice, IdReactive, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit,
            IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, ScheduledUpdateDate,
            2 AS IdRefValueChangeStatus, DATEADD(HOUR, -5, GETDATE()) AS CreationDate, @IdUser AS IdUserAction
        FROM TB_ReferenceValue
        WHERE IdReferenceValue IN (SELECT IdReferenceValue FROM @RefValueChange);


        SET @Status = 1;
        SET @StatusMessage = 'La operación se completó exitosamente.';
    END TRY
    BEGIN CATCH
        SET @Status = 0;
        SET @StatusMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO

