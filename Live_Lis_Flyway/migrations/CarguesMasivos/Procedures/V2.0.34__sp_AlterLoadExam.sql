
-- Hacer el respaldo obligatorio antes de cualquier cambio

exec SaveSchemaBackup 'sp_LoadExam';
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[sp_LoadExam]
    @ExamList LoadExam READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status BIT OUTPUT,
    @Message NVARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ErrorList TABLE (
        ExamCode VARCHAR(20),
        ErrorMessage NVARCHAR(MAX)
    );

    DECLARE @InsertedExams TABLE (
        IdExam INT,
        ExamCode VARCHAR(20)
    );

    -- Capturar errores por registros no insertados
    INSERT INTO @ErrorList (ExamCode, ErrorMessage)
    SELECT 
        A.ExamCode, 
        'Faltan datos en las tablas de parametrización.' +
        CASE 
            WHEN B.IdExamTechnique IS NULL THEN ' Falasdfasdf' 
            WHEN C.IdExamType IS NULL THEN ' Falta el dato IdExamType' 
            WHEN D.IdSection IS NULL THEN 'pruebas cambios' 
            WHEN E.IdTemplate IS NULL THEN ' Falta el dato IdTemplate' 
            WHEN F.IdBiologicalSex IS NULL THEN ' asdfasdfasdf' 
            WHEN G.IdTimeUnit IS NULL THEN ' Falta el dato IdTimeUnit' 
            WHEN I.IdContainerType IS NULL THEN ' Falta el dato IdContainerType'
            WHEN K.IdTimeUnit IS NULL THEN ' asdfasdft'
            WHEN L.ExamCode IS NOT NULL THEN ' El Código del Examen ya existe.' 
        END
    FROM @ExamList A
    LEFT JOIN TB_ExamTechnique B ON A.ExamTechnique = B.ExamTechnique
    LEFT JOIN TB_ExamType C ON A.ExamType = C.ExamType
    LEFT JOIN TB_Section D ON A.Section = D.SectionName
    LEFT JOIN TB_Template E ON A.Template = E.TemplateName
    LEFT JOIN TB_BiologicalSex F ON A.BiologicalSex = F.BiologicalSex
    LEFT JOIN TB_TimeUnit G ON A.AgeTimeUnit = G.TimeUnit
    LEFT JOIN TB_ContainerType I ON A.ContainerType = I.ContainerTypeName
    LEFT JOIN TB_TimeUnit K ON A.PlanTimeUnit = K.TimeUnit
    LEFT JOIN TB_Exam L ON A.ExamCode = L.ExamCode
    WHERE B.IdExamTechnique IS NULL
        OR C.IdExamType IS NULL
        OR D.IdSection IS NULL
        OR E.IdTemplate IS NULL
        OR F.IdBiologicalSex IS NULL
        OR G.IdTimeUnit IS NULL
        OR I.IdContainerType IS NULL
        OR K.IdTimeUnit IS NULL
        OR L.ExamCode IS NOT NULL;

    -- Insertar datos válidos y capturar los IdExam insertados
    INSERT INTO TB_Exam (CreationDate, IdUserAction,
        GroupType, IdTypeOfProcedure, ExamCode, ExamName, ExamTitle, VisibleResult, IdExamTechnique, 
        IdExamType, Priority, LevelOfComplexity, Confidential, PrintResults, DeliveryOpportunity, 
        ControlOpportunity, Decimal, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday, 
        IdSection, IdTemplate, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, SampleConditions, 
        AmbientTemperature, RefrigeratedTemperture, FrozenTemperature, TakingFrequency, IdTimeUnit, 
        PBS, EpidemiologicalNotification, Score, PlanValidity, IdValidityFormat, Active
    )
    OUTPUT INSERTED.IdExam, INSERTED.ExamCode INTO @InsertedExams
    SELECT DATEADD(HOUR,-5,GETDATE()), @IdUser,
        CASE WHEN A.GroupType = 'SI' THEN 1 ELSE 0 END, 1, A.ExamCode, A.ExamName, A.ExamTitle,
        CASE WHEN A.Visible = 'SI' THEN 1 ELSE 0 END, B.IdExamTechnique, C.IdExamType, 
        CASE WHEN A.Priority = 'SI' THEN 1 ELSE 0 END, A.LevelOfComplexity, 
        CASE WHEN A.Confidential = 'SI' THEN 1 ELSE 0 END, CASE WHEN A.NotPrintResults = 'NO' THEN 1 ELSE 0 END, 
        A.DeliveryOpportunity, A.ControlOpportunity, A.Decimal, 
        CASE WHEN A.ProcessingDays LIKE '%LUNES%' OR A.ProcessingDays LIKE '%TODOS LOS DIAS%' THEN 1 ELSE 0 END,
        CASE WHEN A.ProcessingDays LIKE '%MARTES%' OR A.ProcessingDays LIKE '%TODOS LOS DIAS%' THEN 1 ELSE 0 END,
        CASE WHEN A.ProcessingDays LIKE '%MIERCOLES%' OR A.ProcessingDays LIKE '%TODOS LOS DIAS%' THEN 1 ELSE 0 END,
        CASE WHEN A.ProcessingDays LIKE '%JUEVES%' OR A.ProcessingDays LIKE '%TODOS LOS DIAS%' THEN 1 ELSE 0 END,
        CASE WHEN A.ProcessingDays LIKE '%VIERNES%' OR A.ProcessingDays LIKE '%TODOS LOS DIAS%' THEN 1 ELSE 0 END,
        CASE WHEN A.ProcessingDays LIKE '%SABADO%' OR A.ProcessingDays LIKE '%TODOS LOS DIAS%' THEN 1 ELSE 0 END,
        CASE WHEN A.ProcessingDays LIKE '%TODOS LOS DIAS%' THEN 1 ELSE 0 END,
        D.IdSection, E.IdTemplate, F.IdBiologicalSex, A.MinAge, A.MaxAge, G.IdTimeUnit,
        A.SampleConditions, A.AmbientTemperature, 
        A.RefrigeratedTemperture, A.FrozenTemperature, A.TakingFrequency, K.IdTimeUnit, 
        CASE WHEN A.PBS = 'SI' THEN 1 ELSE 0 END, CASE WHEN A.EpidemiologicalNotification = 'SI' THEN 1 ELSE 0 END, 
        CASE WHEN A.AssociateScore = 'SI' THEN A.Score ELSE NULL END, A.PlanValidity, K.IdTimeUnit, 1
    FROM @ExamList A
    INNER JOIN TB_ExamTechnique B ON A.ExamTechnique = B.ExamTechnique
    INNER JOIN TB_ExamType C ON A.ExamType = C.ExamType
    INNER JOIN TB_Section D ON A.Section = D.SectionName
    INNER JOIN TB_Template E ON A.Template = E.TemplateName
    INNER JOIN TB_BiologicalSex F ON A.BiologicalSex = F.BiologicalSex
    INNER JOIN TB_TimeUnit G ON A.AgeTimeUnit = G.TimeUnit
    INNER JOIN TB_ContainerType I ON A.ContainerType = I.ContainerTypeName
    INNER JOIN TB_TimeUnit K ON A.PlanTimeUnit = K.TimeUnit
    LEFT JOIN TB_Exam L ON A.ExamCode = L.ExamCode
    WHERE L.ExamCode IS NULL


    INSERT INTO TR_Exam_SampleType (IdExam, IdSampleType, IdContainerType, Volume, IdVolumeMeasure, Active, AmbientTemperature, RefrigeratedTemperture, FrozenTemperature, Required)
    SELECT IdExam, C.IdSampleType, D.IdContainerType, B.Volume, null, 1, B.AmbientTemperature, B.RefrigeratedTemperture, B.FrozenTemperature, null
	FROM @InsertedExams A
	Inner Join @ExamList B on A.ExamCode = B.ExamCode
	Inner Join TB_SampleType C on C.SampleType = B.SampleType
	Inner Join TB_ContainerType D on D.ContainerTypeName = B.ContainerType

    -- Devolver mensaje y errores
    IF EXISTS (SELECT 1 FROM @ErrorList)
    BEGIN
        SET @Status = 0;
        SELECT * FROM @ErrorList;
        SET @Message = 'Algunos registros no se inserasdfasd tardsfasdfción.';
    END
    ELSE
    BEGIN
        SET @Status = 1;
        SET @Message = 'Operación exitosa. asdfasdfasd on insertados correctamente.';
    END
END
GO

