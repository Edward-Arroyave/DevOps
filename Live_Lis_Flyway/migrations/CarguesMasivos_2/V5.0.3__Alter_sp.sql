/****** Object:  StoredProcedure [dbo].[sp_LoadAnalyte]    Script Date: 11/03/2025 8:24:22 a. m. ******/


SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

EXEC SaveSchemaBackup 'sp_LoadAnalyte';
GO
ALTER PROCEDURE [dbo].[sp_LoadAnalyte]
(
    @AnalyteList [LoadAnalyte] READONLY, 
    @IdUser INT,                  
    @Date DATETIME,
    @status INT OUTPUT,           
    @statusMessage NVARCHAR(500) OUTPUT 
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        DECLARE @InsertedAnalyte TABLE (IdAnalyte INT, AnalyteCode VARCHAR(40), AnalyteName VARCHAR(250));

        -- Carga de AnalyteExam, asegurando que los datos estén correctos
        WITH AnalyteExam AS
        (
            SELECT 
                B.ExamCode, 
                B.IdExam, 
                COUNT(DISTINCT A.IdAnalyte) AS AnalyteCode
            FROM TB_Analyte A
            RIGHT JOIN TB_Exam B 
                ON A.IdExam = B.IdExam AND A.Active = 1
            INNER JOIN @AnalyteList C 
                ON C.CodeExam = B.ExamCode
            GROUP BY B.ExamCode, B.IdExam
        )
        INSERT INTO TB_Analyte 
        (
            IdExam, AnalyteCode, AnalyteName, IdExamTechnique, 
            IdUnitOfMeasurement, Comments, IdDataType, 
            InitialValue, FinalValue, IdExpectedValue, CodificationText, 
            Visible, IdUserAction, CreationDate, Position, AnalyteTypeComment, 
            AnalyteMicrobiologyResult, Decimal, DecimalAutoComplete
        )
        OUTPUT INSERTED.IdAnalyte, INSERTED.AnalyteCode, INSERTED.AnalyteName INTO @InsertedAnalyte
        SELECT 
            A.IdExam, 
            A.ExamCode + CASE WHEN GroupType = 'SI' THEN '-' + CAST((A.AnalyteCode + ROW_NUMBER() OVER (PARTITION BY A.ExamCode ORDER BY B.NameAnalyte)) AS VARCHAR) ELSE '' END AS AnalyteCode,
            B.NameAnalyte, 
            D.IdExamTechnique,
            E.IdUnitOfMeasurement,
            B.Comments,
            F.IdDataType,
            CASE WHEN B.InitialValue = '' THEN NULL ELSE B.InitialValue END,
            CASE WHEN B.FinalValue = '' THEN NULL ELSE B.FinalValue END,
            G.IdExpectedValue,
            B.CodificationText,
            CASE WHEN B.Visible = 'SI' THEN 1 ELSE 0 END AS Visible,
            @IdUser,
            @Date,
            A.AnalyteCode + ROW_NUMBER() OVER (PARTITION BY A.ExamCode ORDER BY B.NameAnalyte) AS Position,
            CASE WHEN B.AnalyteTypeComments = 'SI' THEN 1 ELSE 0 END AS AnalyteTypeComment,
            CASE WHEN B.AnalyteMicrobiologyResult = 'SI' THEN 1 ELSE 0 END AS AnalyteMicrobiologyResult,
            B.Decimal,
            CASE WHEN B.DecimalAutoComplete = 'SI' THEN 1 ELSE 0 END AS DecimalAutoComplete
        FROM AnalyteExam A
        INNER JOIN @AnalyteList B 
            ON A.ExamCode = B.CodeExam
        LEFT JOIN TB_ExamTechnique D 
            ON D.ExamTechnique = B.ExamTechnique
        LEFT JOIN TB_UnitOfMeasurement E 
            ON E.UnitOfMeasurement = B.UnitOfMeasurement
        LEFT JOIN TB_DataType F 
            ON F.DataType = B.DataType
        LEFT JOIN TB_ExpectedValue G 
            ON G.ExpectedValue = B.ExpectedValue
        WHERE 
            B.CodeExam IS NOT NULL 
            AND B.NameAnalyte IS NOT NULL 
            AND B.Visible IS NOT NULL 
            AND B.AnalyteTypeComments IS NOT NULL 
            AND B.DataType IS NOT NULL
            AND (
                (B.AnalyteTypeComments = 'SI' AND B.Comments IS NOT NULL) OR 
                (B.AnalyteTypeComments = 'NO' AND B.DataType = 'Numérico' 
                    AND B.UnitOfMeasurement IS NOT NULL AND E.IdUnitOfMeasurement IS NOT NULL 
                    AND B.InitialValue IS NOT NULL AND B.FinalValue IS NOT NULL 
                    AND B.DecimalAutoComplete IS NOT NULL AND B.Decimal IS NOT NULL 
                    AND B.AnalyteMicrobiologyResult IS NOT NULL) OR 
                (B.AnalyteTypeComments = 'NO' AND B.DataType = 'Texto' 
                    AND B.UnitOfMeasurement IS NOT NULL AND E.IdUnitOfMeasurement IS NOT NULL 
                    AND B.ExpectedValue IS NOT NULL AND G.IdExpectedValue IS NOT NULL  
                    AND B.DecimalAutoComplete IS NOT NULL AND B.Decimal IS NOT NULL 
                    AND B.AnalyteMicrobiologyResult IS NOT NULL) OR 
                (B.AnalyteTypeComments = 'NO' AND B.DataType = 'Texto codificado' 
                    AND B.UnitOfMeasurement IS NOT NULL AND E.IdUnitOfMeasurement IS NOT NULL 
                    AND B.CodificationText IS NOT NULL AND B.DecimalAutoComplete IS NOT NULL 
                    AND B.Decimal IS NOT NULL AND B.AnalyteMicrobiologyResult IS NOT NULL)
            );

        -- Validación y generación de mensajes de error
        SELECT 
            A.*,
            CASE 
                WHEN B.IdAnalyte IS NOT NULL THEN 'Insertado correctamente'
                WHEN A.CodeExam IS NULL THEN 'CodeExam es nulo'
                WHEN A.NameAnalyte IS NULL THEN 'NameAnalyte es nulo'
                WHEN A.Visible IS NULL THEN 'Visible es nulo'
                WHEN A.AnalyteTypeComments IS NULL THEN 'AnalyteTypeComments es nulo'
                WHEN A.DataType IS NULL THEN 'DataType es nulo'
                WHEN NOT EXISTS (SELECT 1 FROM TB_ExamTechnique WHERE ExamTechnique = A.ExamTechnique) THEN 'ExamTechnique no existe en TB_ExamTechnique'
                WHEN NOT EXISTS (SELECT 1 FROM TB_DataType WHERE DataType = A.DataType) THEN 'DataType no existe en TB_DataType'
                WHEN (A.UnitOfMeasurement IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TB_UnitOfMeasurement WHERE UnitOfMeasurement = A.UnitOfMeasurement)) 
                THEN 'UnitOfMeasurement no existe en TB_UnitOfMeasurement'
                WHEN (A.ExpectedValue IS NOT NULL AND NOT EXISTS (SELECT 1 FROM TB_ExpectedValue WHERE ExpectedValue = A.ExpectedValue)) 
                THEN 'ExpectedValue no existe en TB_ExpectedValue'
                WHEN (A.AnalyteTypeComments = 'SI' AND A.Comments IS NULL) THEN 'AnalyteTypeComments es SI pero Comments es nulo'
                WHEN (A.AnalyteTypeComments = 'NO' AND A.DataType = 'Numérico' 
                      AND (A.UnitOfMeasurement IS NULL OR A.InitialValue IS NULL OR A.FinalValue IS NULL 
                           OR A.DecimalAutoComplete IS NULL OR A.Decimal IS NULL OR A.AnalyteMicrobiologyResult IS NULL)) 
                THEN 'Faltan datos para DataType Numérico'
                WHEN (A.AnalyteTypeComments = 'NO' AND A.DataType = 'Texto' 
                      AND (A.UnitOfMeasurement IS NULL OR A.ExpectedValue IS NULL 
                           OR A.DecimalAutoComplete IS NULL OR A.Decimal IS NULL OR A.AnalyteMicrobiologyResult IS NULL)) 
                THEN 'Faltan datos para DataType Texto'
                WHEN (A.AnalyteTypeComments = 'NO' AND A.DataType = 'Texto codificado' 
                      AND (A.UnitOfMeasurement IS NULL OR A.CodificationText IS NULL 
                           OR A.DecimalAutoComplete IS NULL OR A.Decimal IS NULL OR A.AnalyteMicrobiologyResult IS NULL)) 
                THEN 'Faltan datos para DataType Texto codificado'
                ELSE 'No se insertó por razones desconocidas'
            END AS message
        FROM @AnalyteList A
        LEFT JOIN @InsertedAnalyte B 
            ON B.AnalyteCode LIKE (A.CodeExam + '%');

        SET @status = 1;
        SET @statusMessage = 'Proceso finalizado.';
    END TRY
    BEGIN CATCH
        SET @status = 0;
        SET @statusMessage = ERROR_MESSAGE();
    END CATCH
END;
GO


/****** Object:  StoredProcedure [dbo].[sp_LoadArea]    Script Date: 11/03/2025 8:24:33 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 03/02/2025
-- Description: Procedimiento almacenado para cargue masivo de area.
-- =============================================
/*
DECLARE @LoadArea LoadArea, @Message varchar(50), @Flag bit
INSERT INTO @LoadArea (PostponementCode, PostponementName)
VALUES 
('12345','Prueba posponer'),
('54321','Cargue prueba')
EXEC [sp_LoadArea] @LoadArea,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
EXEC SaveSchemaBackup 'sp_LoadArea';
GO
ALTER PROCEDURE [dbo].[sp_LoadArea]
(
	@LoadArea LoadArea READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
		DECLARE @InsertedArea table (IdArea int, AreaName varchar(50))

		INSERT INTO RYS.TB_Area(AreaName, CreationDate, IdUserAction, Active)
		output inserted.IdArea, inserted.AreaName into @InsertedArea
		SELECT DISTINCT A.AreaName,DATEADD(HOUR,-5,GETDATE()),@IdUserAction, 1 
		FROM @LoadArea A
		LEFT JOIN RYS.TB_Area B ON B.AreaName = A.AreaName
		WHERE B.IdArea IS NULL and A.AreaName <> ''

		Select A.*,
		Case
			when B.IdArea IS not null then 'Registro ingresado.'
			when C.IdArea is not null then 'Error: El area ya existe'
			when A.AreaName = '' then 'Error: El nombre de area esta vacio'
		end [Message]
		FROM @LoadArea A
		LEFT JOIN @InsertedArea B ON A.AreaName = B.AreaName
		LEFT JOIN RYS.TB_Area C ON C.AreaName = A.AreaName

		SET @Flag = 1;
		SET @Message = 'Area cargada con exito.'

END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadCommercialHouses]    Script Date: 11/03/2025 8:24:43 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de casa comercial.
-- =============================================
/*
DECLARE @LoadCommercialHouse LoadCommercialHouse, @Message varchar(50), @Flag bit
INSERT INTO @LoadCommercialHouse (CommercialHouseName)
VALUES 
('Casa prueba'),
('Casa registro')
EXEC [sp_LoadCommercialHouses] @LoadCommercialHouse,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================

EXEC SaveSchemaBackup 'sp_LoadCommercialHouses';
GO
ALTER PROCEDURE [dbo].[sp_LoadCommercialHouses]
(
    @LoadCommercialHouse LoadCommercialHouse READONLY,
    @IdUserAction INT,
    @Message VARCHAR(50) OUT,
    @Flag BIT OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsertedCommercialHouse TABLE (IdCommercialHouse INT, CommercialHouseName VARCHAR(50));

    -- Insertar solo si el nombre no está vacío y no existe en la tabla destino
    INSERT INTO TB_CommercialHouses (Name, Active, CreationDate, IdCreationUser, IdUserAction)
    OUTPUT inserted.IdCommercialHouses, inserted.Name INTO @InsertedCommercialHouse
    SELECT DISTINCT 
        A.CommercialHouseName, 
        1, 
        DATEADD(HOUR, -5, GETDATE()), 
        @IdUserAction, 
        @IdUserAction
    FROM @LoadCommercialHouse A
    LEFT JOIN TB_CommercialHouses B ON B.Name = A.CommercialHouseName
    WHERE B.IdCommercialHouses IS NULL 
          AND A.CommercialHouseName <> '';

    -- Mostrar resultado con mensajes de error detallados
    SELECT 
        A.*, 
        CASE 
            WHEN B.IdCommercialHouse IS NOT NULL THEN 'Registro ingresado correctamente.'
            WHEN C.IdCommercialHouses IS NOT NULL THEN 'Error: La casa comercial ya existe en el sistema.'
            WHEN A.CommercialHouseName = '' THEN 'Error: El nombre de la casa comercial está vacío.'
            ELSE 'Error desconocido: Verifique los datos de entrada.'
        END AS [Message]
    FROM @LoadCommercialHouse A
    LEFT JOIN @InsertedCommercialHouse B ON A.CommercialHouseName = B.CommercialHouseName
    LEFT JOIN TB_CommercialHouses C ON C.Name = A.CommercialHouseName;

    -- Mensaje de estado final
    IF EXISTS (SELECT 1 FROM @InsertedCommercialHouse)
    BEGIN
        SET @Flag = 1;
        SET @Message = 'Casas comerciales cargadas con éxito.';
    END
    ELSE
    BEGIN
        SET @Flag = 0;
        SET @Message = 'No se insertaron casas comerciales. Revise los mensajes de error.';
    END;

END;


GO

/****** Object:  StoredProcedure [dbo].[sp_LoadCriticalDataExam]    Script Date: 11/03/2025 8:24:53 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




EXEC SaveSchemaBackup 'sp_LoadCriticalDataExam';
GO
ALTER PROCEDURE [dbo].[sp_LoadCriticalDataExam]
    @CriticalDataExam LoadCriticalDataExam READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

		declare @InsertedCriticalDates table (IdCriticalDates int, IdAnalyte int, IdDataType int, InitialValue decimal(10,3), FinalValue decimal(10,3))
    
        INSERT INTO TB_CriticalDates(IdAnalyte, IdDataType, InitialValue, FinalValue, IdExpectedValue, CreationDate, IdUserCreation, Active)
		output inserted.IdCriticalDates, inserted.IdAnalyte, inserted.IdDataType, inserted.InitialValue, inserted.FinalValue into @InsertedCriticalDates
        SELECT C.IdAnalyte, F.IdDataType, case when A.LowerLimit = '' then null else cast(A.LowerLimit as decimal(10,3)) end, 
		case when A.UpperLimit = '' then null else cast(A.UpperLimit as decimal(10,3)) end, E.IdExpectedValue, @Date, @IdUser, 1 Active
        FROM @CriticalDataExam A
		INNER JOIN TB_Exam B ON B.ExamCode = A.ExamCode 
		INNER JOIN TB_Analyte C ON C.AnalyteCode = A.NameAnalyte AND C.IdExam = B.IdExam 
		INNER JOIN TB_DataType F ON F.DataType = A.DataType
		LEFT JOIN TB_ExpectedValue E ON E.ExpectedValue = A.ExpectedValue
		WHERE (A.DataType = 'Texto' and A.ExpectedValue is not null and A.ExpectedValue <> '' and E.IdExpectedValue is not null ) or
		(A.DataType = 'Númerico' and A.LowerLimit is not null and A.UpperLimit is not null and A.LowerLimit <> '' and A.UpperLimit <> '' ); 
        
		SELECT A.*,
            CASE 
                WHEN G.IdCriticalDates IS NOT NULL THEN 'Insertado correctamente'
                WHEN B.IdExam IS NULL THEN 'Error: No existe el código de examen en TB_Exam'
                WHEN C.IdAnalyte IS NULL THEN 'Error: No existe el analito en TB_Analyte'
                WHEN F.IdDataType IS NULL THEN 'Error: No existe el tipo de dato en TB_DataType'
                WHEN A.DataType = 'Texto' AND (A.ExpectedValue IS NULL OR A.ExpectedValue = '') THEN 'Error: ExpectedValue es obligatorio para tipo de dato Texto'
                WHEN A.DataType = 'Númerico' AND (A.LowerLimit IS NULL OR A.UpperLimit IS NULL OR A.LowerLimit = '' OR A.UpperLimit = '') THEN 'Error: LowerLimit y UpperLimit son obligatorios para tipo de dato Númerico'
                WHEN E.IdExpectedValue IS NULL AND A.DataType = 'Texto' THEN 'Error: ExpectedValue no existe en TB_ExpectedValue'
                WHEN NOT EXISTS (SELECT 1 FROM TB_ExpectedValue WHERE ExpectedValue = A.ExpectedValue) AND A.DataType = 'Texto' THEN 'Error: ExpectedValue no está registrado en TB_ExpectedValue'
                ELSE 'Error desconocido: Verificar datos de entrada'
            END AS [Message]
        FROM @CriticalDataExam A
        LEFT JOIN TB_Exam B ON B.ExamCode = A.ExamCode 
        LEFT JOIN TB_Analyte C ON C.AnalyteCode = A.NameAnalyte AND C.IdExam = B.IdExam 
        LEFT JOIN TB_DataType F ON F.DataType = A.DataType
        LEFT JOIN TB_ExpectedValue E ON E.ExpectedValue = A.ExpectedValue
        LEFT JOIN @InsertedCriticalDates G ON G.IdAnalyte = C.IdAnalyte 
            AND (CASE WHEN A.LowerLimit = '' THEN NULL ELSE CAST(A.LowerLimit AS DECIMAL(10,3)) END) = G.InitialValue
            AND (CASE WHEN A.UpperLimit = '' THEN NULL ELSE CAST(A.UpperLimit AS DECIMAL(10,3)) END) = G.FinalValue;
        SET @Status = 1;
        SET @StatusMessage = 'Los datos fueron procesados correctamente.';

    END TRY
    BEGIN CATCH
        -- Capturar error y retornar mensaje
        SET @Status = -1;
        SET @StatusMessage = ERROR_MESSAGE();
    END CATCH;



END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadExam]    Script Date: 11/03/2025 8:25:05 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

EXEC SaveSchemaBackup 'sp_LoadExam';
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


    DECLARE @InsertedExams TABLE (
        IdExam INT,
        ExamCode VARCHAR(20)
    );

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
    WHERE L.ExamCode IS NULL AND A.GroupType IS NOT NULL AND A.ExamCode IS NOT NULL
	AND A.ExamName IS NOT NULL AND A.Visible IS NOT NULL AND A.Priority IS NOT NULL
	AND A.LevelOfComplexity IS NOT NULL AND A.Confidential IS NOT NULL 
	AND A.NotPrintResults IS NOT NULL AND A.DeliveryOpportunity IS NOT NULL 
	AND A.Decimal IS NOT NULL AND A.SampleType IS NOT NULL AND A.ObligatoryTemperature IS NOT NULL
	AND A.PBS IS NOT NULL AND A.EpidemiologicalNotification IS NOT NULL AND A.AssociateScore IS NOT NULL


    INSERT INTO TR_Exam_SampleType (IdExam, IdSampleType, IdContainerType, Volume, IdVolumeMeasure, Active, AmbientTemperature, RefrigeratedTemperture, FrozenTemperature, Required)
    SELECT 
    A.IdExam, 
    C.IdSampleType, 
    CAST(D.IdContainerType AS TINYINT), 
    CAST(B.Volume AS DECIMAL(7, 3)), 
    CAST(NULL AS TINYINT), 
    CAST(1 AS BIT), 
    CAST(B.AmbientTemperature AS VARCHAR(15)), 
    CAST(B.RefrigeratedTemperture AS VARCHAR(15)), 
    CAST(B.FrozenTemperature AS VARCHAR(15)), 
    CAST(NULL AS BIT)
	FROM @InsertedExams A
	Inner Join @ExamList B on A.ExamCode = B.ExamCode
	Inner Join TB_SampleType C on C.SampleType = B.SampleType
	Inner Join TB_ContainerType D on D.ContainerTypeName = B.ContainerType


    SELECT 
        A.ExamCode, 
		A.ExamName, 
        CASE 
			WHEN J.IdExam IS NOT NULL THEN 'Registrado correctamente.'
            WHEN L.ExamCode IS NOT NULL THEN ' El Código del Examen ya existe.' 
            WHEN B.IdExamTechnique IS NULL THEN 'Falta el dato IdExamTechnique' 
            WHEN C.IdExamType IS NULL THEN 'Falta el dato IdExamType' 
            WHEN D.IdSection IS NULL THEN 'Falta el dato IdSection' 
            WHEN E.IdTemplate IS NULL THEN 'Falta el dato IdTemplate' 
            WHEN F.IdBiologicalSex IS NULL THEN 'Falta el dato IdBiologicalSex' 
            WHEN G.IdTimeUnit IS NULL THEN 'Falta el dato IdTimeUnit' 
            WHEN I.IdContainerType IS NULL THEN 'Falta el dato IdContainerType'
            WHEN K.IdTimeUnit IS NULL THEN 'Falta el dato IdTimeUnit'
			WHEN A.GroupType IS NOT NULL THEN 'Falta el validar si es tipo grupo.'
			WHEN A.ExamCode IS NOT NULL THEN 'Falta el Codigó del Exámen.'
			WHEN A.ExamName IS NOT NULL THEN 'Falta el nombre del Exámen.'
			WHEN A.Visible IS NOT NULL THEN 'Falta la visibilidad.'
			WHEN A.Priority IS NOT NULL THEN 'Falta la prioridad.'
			WHEN A.LevelOfComplexity IS NOT NULL THEN 'Falta el nivel de complejidad.'
			WHEN A.Confidential IS NOT NULL THEN 'Falta la confidencialidad.'
			WHEN A.NotPrintResults IS NOT NULL THEN 'Falta la decisión de no impresión.'
			WHEN A.DeliveryOpportunity IS NOT NULL THEN 'Falta oportunidad de domicilio.'
			WHEN A.Decimal IS NOT NULL THEN 'Falta cantidad de decimales.'
			WHEN A.SampleType IS NOT NULL THEN 'Faltan los tipos de muestra.'
			WHEN A.ObligatoryTemperature IS NOT NULL THEN 'Falta la obligatoridad de temperatura.'
			WHEN A.PBS IS NOT NULL THEN 'Falta el PBS.'
			WHEN A.EpidemiologicalNotification IS NOT NULL THEN 'Falta la notificación epidemiologica.'
			WHEN A.AssociateScore IS NOT NULL THEN 'Falta el puntaje.'
        END [Message]
    FROM @ExamList A
	left join @InsertedExams J on J.ExamCode = A.ExamCode
    LEFT JOIN TB_ExamTechnique B ON A.ExamTechnique = B.ExamTechnique
    LEFT JOIN TB_ExamType C ON A.ExamType = C.ExamType
    LEFT JOIN TB_Section D ON A.Section = D.SectionName
    LEFT JOIN TB_Template E ON A.Template = E.TemplateName
    LEFT JOIN TB_BiologicalSex F ON A.BiologicalSex = F.BiologicalSex
    LEFT JOIN TB_TimeUnit G ON A.AgeTimeUnit = G.TimeUnit
    LEFT JOIN TB_ContainerType I ON A.ContainerType = I.ContainerTypeName
    LEFT JOIN TB_TimeUnit K ON A.PlanTimeUnit = K.TimeUnit
    LEFT JOIN TB_Exam L ON A.ExamCode = L.ExamCode

	set @Status = 1
	set @Message = 'Proceso finalizado'

END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadExamTechnique]    Script Date: 11/03/2025 8:25:14 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





EXEC SaveSchemaBackup 'sp_LoadExamTechnique';
GO
ALTER PROCEDURE [dbo].[sp_LoadExamTechnique]
    @ExamTechnique LoadExamTechnique READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

		declare @InsertedExamTechnique table (IdExamTechnique int, ExamTechnique varchar(50))
 
        INSERT INTO TB_ExamTechnique(ExamTechnique, Active, CreationDate, IdUserAction)
		output inserted.IdExamTechnique, inserted.ExamTechnique into @InsertedExamTechnique
        SELECT A.ExamTechnique, 1 AS Active, @Date, @IdUser
        FROM @ExamTechnique A
        LEFT JOIN TB_ExamTechnique B
            ON A.ExamTechnique = B.ExamTechnique
        WHERE B.IdExamTechnique IS NULL And A.ExamTechnique <> '';

		select A.*,
		case 
			when B.IdExamTechnique is not null then 'Se registro correctamente.'
			when C.IdExamTechnique is not null then 'Error: La tecnica del examen ya existe.'
			when A.ExamTechnique = '' then 'Error: La tecnica del examen esta vacio'
		end [Message]
		from @ExamTechnique A 
		left join @InsertedExamTechnique B on A.ExamTechnique = B.ExamTechnique
		left join TB_ExamTechnique C on C.ExamTechnique = A.ExamTechnique
        
        SET @Status = 1;
        SET @StatusMessage = 'Los registros fueron procesados.';

    END TRY
    BEGIN CATCH
        SET @Status = -1;
        SET @StatusMessage = ERROR_MESSAGE();
    END CATCH;

END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadExpectedValue]    Script Date: 11/03/2025 8:25:23 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





EXEC SaveSchemaBackup 'sp_LoadExpectedValue';
GO
ALTER PROCEDURE [dbo].[sp_LoadExpectedValue]
    @ExpectedValue LoadExpectedValue READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
 
		declare @InsertedExpectedValue table (IdExpectedValue int, ExpecteValue varchar(50))
 
		INSERT INTO TB_ExpectedValue(ExpectedValue, Active, CreationDate, IdUserAction)
		output inserted.IdExpectedValue, inserted.ExpectedValue into @InsertedExpectedValue
        SELECT A.ExpectedValue, 1 AS Active, @Date, @IdUser
        FROM @ExpectedValue A
        LEFT JOIN TB_ExpectedValue B
            ON A.ExpectedValue = B.ExpectedValue
        WHERE B.IdExpectedValue IS NULL and A.ExpectedValue <> '';

		select A.*,
		case 
			when B.IdExpectedValue is not null then 'Registro ingresado.'
			when C.IdExpectedValue is not null then 'Error: El valor esperado ya existe.'
			when A.ExpectedValue = '' then 'Error: El valor esperado esta vacio'
		end [Message]
		from @ExpectedValue A 
		left join @InsertedExpectedValue B on A.ExpectedValue = B.ExpecteValue
		left join TB_ExpectedValue C on C.ExpectedValue = A.ExpectedValue
        
        SET @Status = 1;
        SET @StatusMessage = 'Los datos fueron insertados correctamente.';
        
    END TRY
    BEGIN CATCH
        -- Capturar error y retornar mensaje
        SET @Status = -1;
        SET @StatusMessage = ERROR_MESSAGE();
    END CATCH;

END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadMedicalDevice]    Script Date: 11/03/2025 8:25:34 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de dispositivo medico.
-- =============================================
/*
DECLARE @LoadMedicalDevice LoadMedicalDevice, @Message varchar(50), @Flag bit
INSERT INTO @LoadMedicalDevice (SectionName)
VALUES 
('Prueba1'),
('Dato 1')
EXEC [sp_LoadMedicalDevice] @LoadMedicalDevice,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
EXEC SaveSchemaBackup 'sp_LoadMedicalDevice';
GO
ALTER PROCEDURE [dbo].[sp_LoadMedicalDevice]
(
    @LoadMedicalDevice LoadMedicalDevice READONLY,
    @IdUserAction INT,
    @Message VARCHAR(50) OUT,
    @Flag BIT OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsertedMedicalDevice TABLE (IdMedicalDevice INT, MedicalDevice VARCHAR(50));

    -- Insertar dispositivos que no existan y cuyo nombre no esté vacío
    INSERT INTO TB_MedicalDevice (MedicalDevice, Active, CreationDate, IdUserAction, DefaultDevice)
    OUTPUT inserted.IdMedicalDevice, inserted.MedicalDevice INTO @InsertedMedicalDevice
    SELECT DISTINCT A.MedicalDevice, 1, DATEADD(HOUR, -5, GETDATE()), @IdUserAction, 0
    FROM @LoadMedicalDevice A
    LEFT JOIN TB_MedicalDevice B ON B.MedicalDevice = A.MedicalDevice
    WHERE B.IdMedicalDevice IS NULL 
          AND A.MedicalDevice IS NOT NULL 
          AND A.MedicalDevice <> '';

    -- Mostrar resultado con mensajes de error detallados
    SELECT 
        A.*,
        CASE
            WHEN B.IdMedicalDevice IS NOT NULL THEN 'Registro ingresado correctamente.'
            WHEN C.IdMedicalDevice IS NOT NULL THEN 'Error: El dispositivo médico ya existe.'
            WHEN A.MedicalDevice IS NULL OR A.MedicalDevice = '' THEN 'Error: El nombre del dispositivo médico está vacío.'
            ELSE 'Error desconocido: Verifique los datos de entrada.'
        END AS [Message]
    FROM @LoadMedicalDevice A
    LEFT JOIN @InsertedMedicalDevice B ON A.MedicalDevice = B.MedicalDevice
    LEFT JOIN TB_MedicalDevice C ON A.MedicalDevice = C.MedicalDevice;

    SET @Flag = 1;
    SET @Message = 'Dispositivos médicos procesados con éxito.';

END;
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadReactive]    Script Date: 11/03/2025 8:25:44 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de reactivos.
-- =============================================
/*
DECLARE @LoadReactive LoadReactive,@Message varchar(50), @Flag bit
INSERT INTO @LoadReactive (ReferenceCode,Reactive)
VALUES 
('P1234','Prueba'),
('DN1234','Dato Nuevo')
EXEC [sp_LoadReactive] @LoadReactive,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
EXEC SaveSchemaBackup 'sp_LoadReactive';
GO
ALTER PROCEDURE [dbo].[sp_LoadReactive]
(
    @LoadReactive LoadReactive READONLY,
    @IdUserAction INT,
    @Message VARCHAR(50) OUT,
    @Flag BIT OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsertedReactive TABLE (IdReactive INT, Reactive VARCHAR(50));

    -- Insertar reactivos que no existan y cuyo nombre no esté vacío
    INSERT INTO TB_Reactive (ReferenceCode, Reactive, Active, CreationDate, IdUserAction)
    OUTPUT inserted.IdReactive, inserted.Reactive INTO @InsertedReactive
    SELECT DISTINCT A.ReferenceCode, A.Reactive, 1, DATEADD(HOUR, -5, GETDATE()), @IdUserAction
    FROM @LoadReactive A
    LEFT JOIN TB_Reactive B ON B.ReferenceCode = A.ReferenceCode OR B.Reactive = A.Reactive
    WHERE B.IdReactive IS NULL 
          AND A.Reactive <> '' 
          AND A.ReferenceCode <> '';

    -- Mostrar resultado con mensajes de error detallados
    SELECT 
        A.*, 
        CASE 
            WHEN B.IdReactive IS NOT NULL THEN 'Registro ingresado correctamente.'
            WHEN C.IdReactive IS NOT NULL THEN 'Error: El reactivo ya existe en el sistema.'
            WHEN A.Reactive = '' THEN 'Error: El nombre del reactivo está vacío.'
            WHEN A.ReferenceCode = '' THEN 'Error: El código de referencia está vacío.'
            ELSE 'Error desconocido: Verifique los datos de entrada.'
        END AS [Message]
    FROM @LoadReactive A
    LEFT JOIN @InsertedReactive B ON A.Reactive = B.Reactive
    LEFT JOIN TB_Reactive C ON A.Reactive = C.Reactive OR A.ReferenceCode = C.ReferenceCode;

    
    SET @Flag = 1;
    SET @Message = 'Reactivos procesados con éxito.';

END;
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadReasonsPostponement]    Script Date: 11/03/2025 8:25:54 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 03/02/2025
-- Description: Procedimiento almacenado para cargue masivo de razon de porponer
-- =============================================
/*
DECLARE @LoadReasonForPostponement LoadReasonForPostponement, @Message varchar(50), @Flag bit
INSERT INTO @LoadReasonForPostponement (PostponementCode, PostponementName)
VALUES 
('12345','Prueba posponer'),
('54321','Cargue prueba')
EXEC [sp_LoadReasonsPostponement] @LoadReasonForPostponement,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
EXEC SaveSchemaBackup 'sp_LoadReasonsPostponement';
GO
ALTER PROCEDURE [dbo].[sp_LoadReasonsPostponement]
(
    @LoadReasonForPostponement LoadReasonForPostponement READONLY,
    @IdUserAction INT,
    @Message VARCHAR(50) OUT,
    @Flag BIT OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @InsertedReason TABLE (IdReasonForPostponement INT, PostponementName VARCHAR(50));

    -- Insertar solo si el código y el nombre no están vacíos y no existen en la tabla destino
    INSERT INTO TB_ReasonsForPostponement (PostponementCode, PostponementName, CreationDate, IdUserCreation, Active)
    OUTPUT inserted.IdReasonsForPostponement, inserted.PostponementName INTO @InsertedReason
    SELECT DISTINCT 
        A.PostponementCode, 
        A.PostponementName,
        DATEADD(HOUR, -5, GETDATE()), 
        @IdUserAction, 
        1 
    FROM @LoadReasonForPostponement A
    LEFT JOIN TB_ReasonsForPostponement B
        ON B.PostponementName = A.PostponementName
    WHERE 
        B.IdReasonsForPostponement IS NULL 
        AND A.PostponementName <> '' 
        AND A.PostponementCode <> '';

    -- Mostrar resultado con mensajes de error detallados
    SELECT 
        A.*, 
        CASE 
            WHEN B.IdReasonForPostponement IS NOT NULL THEN 'Registro ingresado correctamente.'
            WHEN C.IdReasonsForPostponement IS NOT NULL THEN 'Error: La razón de postergación ya existe en el sistema.'
            WHEN A.PostponementName = '' THEN 'Error: El nombre de la razón de postergación está vacío.'
            WHEN A.PostponementCode = '' THEN 'Error: El código de postergación está vacío.'
            ELSE 'Error desconocido: Verifique los datos de entrada.'
        END AS [Message]
    FROM @LoadReasonForPostponement A
    LEFT JOIN @InsertedReason B ON A.PostponementName = B.PostponementName
    LEFT JOIN TB_ReasonsForPostponement C ON A.PostponementName = C.PostponementName;

    -- Mensaje de estado final
    IF EXISTS (SELECT 1 FROM @InsertedReason)
    BEGIN
        SET @Flag = 1;
        SET @Message = 'Razones de postergación cargadas con éxito.';
    END
    ELSE
    BEGIN
        SET @Flag = 0;
        SET @Message = 'No se insertaron razones de postergación. Revise los mensajes de error.';
    END

END;
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadReferenceValue]    Script Date: 11/03/2025 8:26:04 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

EXEC  SaveSchemaBackup 'sp_LoadReferenceValue';
GO
ALTER PROCEDURE [dbo].[sp_LoadReferenceValue]
    @ReferenceValueList LoadReferenceValue READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    BEGIN TRY
        
        DECLARE @RefValueChange TABLE (
            IdReferenceValue INT,
            IdAnalyte INT,
            InitialValue VARCHAR(50),
            FinalValue VARCHAR(50)
        );

       
        INSERT INTO TB_ReferenceValue (
            IdAnalyte, IdExamTechnique, IdReactive, IdMedicalDevice, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit,
            IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText,
            ScheduledUpdateDate, Status, Active, CreationDate, IdUserAction
        )
        OUTPUT inserted.IdReferenceValue, inserted.IdAnalyte, inserted.InitialValue, inserted.FinalValue INTO @RefValueChange
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
        LEFT JOIN TB_ExpectedValue J ON J.ExpectedValue = A.ExpectedValue
        WHERE
        (
            (A.DataType = 'Numérico' AND 
                A.AnalyteCode IS NOT NULL AND A.MedicalDevice IS NOT NULL AND A.BiologicalSex IS NOT NULL AND 
                A.MinAge IS NOT NULL AND A.MaxAge IS NOT NULL AND A.AgeTimeUnit IS NOT NULL AND A.UnitOfMeasurement IS NOT NULL AND 
                A.DataType IS NOT NULL AND A.InitialValue IS NOT NULL AND A.FinalValue IS NOT NULL AND A.Reactive IS NOT NULL
            ) 
            OR 
            (A.DataType = 'Texto' AND 
                A.AnalyteCode IS NOT NULL AND A.MedicalDevice IS NOT NULL AND A.BiologicalSex IS NOT NULL AND 
                A.MinAge IS NOT NULL AND A.MaxAge IS NOT NULL AND A.AgeTimeUnit IS NOT NULL AND A.UnitOfMeasurement IS NOT NULL AND 
                A.DataType IS NOT NULL AND A.ExpectedValue IS NOT NULL AND J.IdExpectedValue IS NOT NULL AND A.Reactive IS NOT NULL
            )
        );

        
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

        SELECT 
            A.*,
            CASE 
                WHEN B.IdReferenceValue IS NOT NULL THEN 'Insertado correctamente'
                WHEN NOT EXISTS (SELECT 1 FROM TB_Analyte X WHERE X.AnalyteCode = A.AnalyteCode) 
                    THEN 'AnalyteCode no existe en TB_Analyte'
                WHEN NOT EXISTS (SELECT 1 FROM TB_ExamTechnique X WHERE X.ExamTechnique = A.ExamTechnique) 
                    THEN 'ExamTechnique no existe en TB_ExamTechnique'
                WHEN NOT EXISTS (SELECT 1 FROM TB_Reactive X WHERE X.Reactive = A.Reactive) 
                    THEN 'Reactive no existe en TB_Reactive'
                WHEN NOT EXISTS (SELECT 1 FROM TB_MedicalDevice X WHERE X.MedicalDevice = A.MedicalDevice) 
                    THEN 'MedicalDevice no existe en TB_MedicalDevice'
                WHEN NOT EXISTS (SELECT 1 FROM TB_BiologicalSex X WHERE X.BiologicalSex = A.BiologicalSex) 
                    THEN 'BiologicalSex no existe en TB_BiologicalSex'
                WHEN NOT EXISTS (SELECT 1 FROM TB_TimeUnit X WHERE X.TimeUnit = A.AgeTimeUnit) 
                    THEN 'AgeTimeUnit no existe en TB_TimeUnit'
                WHEN NOT EXISTS (SELECT 1 FROM TB_UnitOfMeasurement X WHERE X.UnitOfMeasurement = A.UnitOfMeasurement) 
                    THEN 'UnitOfMeasurement no existe en TB_UnitOfMeasurement'
                WHEN NOT EXISTS (SELECT 1 FROM TB_DataType X WHERE X.DataType = A.DataType) 
                    THEN 'DataType no existe en TB_DataType'
                WHEN (A.ExpectedValue IS NOT NULL AND 
                      NOT EXISTS (SELECT 1 FROM TB_ExpectedValue X WHERE X.ExpectedValue = A.ExpectedValue)) 
                    THEN 'ExpectedValue no existe en TB_ExpectedValue'
                ELSE 'No se insertó por razones desconocidas'
            END AS [Message]
        FROM @ReferenceValueList A
        LEFT JOIN TB_Analyte C ON C.AnalyteCode = A.AnalyteCode
        LEFT JOIN @RefValueChange B ON C.IdAnalyte = B.IdAnalyte and B.FinalValue = A.FinalValue and B.InitialValue = A.InitialValue;

        SET @Status = 1;
        SET @StatusMessage = 'La operación se completó exitosamente.';
    END TRY
    BEGIN CATCH
        SET @Status = 0;
        SET @StatusMessage = 'Error: ' + ERROR_MESSAGE();
    END CATCH
END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadSampleType]    Script Date: 11/03/2025 8:26:13 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

EXEC SaveSchemaBackup 'sp_LoadSampleType';
GO
ALTER PROCEDURE [dbo].[sp_LoadSampleType]
    @SampleType LoadSampleType READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
		Declare @InsertedSampleType table (IdSampleType int, AlternativeCode varchar(50), SampleType varchar(50))

        -- Insertar los registros que no existen en TB_SampleType
        INSERT INTO TB_SampleType (AlternativeCode, SampleType, Active, CreationDate, IdUserAction)
        output inserted.IdSampleType, inserted.AlternativeCode, inserted.SampleType into @InsertedSampleType
		SELECT A.AlternativeCode, A.SampleType, 1 AS Active, @Date, @IdUser
        FROM @SampleType A
        LEFT JOIN TB_SampleType B 
            ON A.AlternativeCode = B.AlternativeCode 
            or A.SampleType = B.SampleType
        WHERE B.IdSampleType IS NULL and A.SampleType <> '';
        
		select A.*,
		case 
			when B.IdSampleType is not null then 'Registro ingresado.'
			when C.IdSampleType is not null then 'Error: El tipo de muestra ya existe'
			when A.SampleType = '' then 'Error: El tipo de muestra esta vacio'
		end [Message]
		from @SampleType A
		left join @InsertedSampleType B on A.AlternativeCode = B.AlternativeCode and A.SampleType = B.SampleType
		left join TB_SampleType C on A.AlternativeCode = C.AlternativeCode or A.SampleType = C.SampleType

        SET @Status = 1;
        SET @StatusMessage = 'Los datos fueron procesados.';
        
END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadSection]    Script Date: 11/03/2025 8:26:22 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 31/01/2025
-- Description: Procedimiento almacenado para cargue masivo de sección.
-- =============================================
/*
DECLARE @LoadSection LoadSection, @Message varchar(50), @Flag bit
INSERT INTO @LoadSection (SectionName)
VALUES 
('Prueba1'),
('Dato 1')
EXEC [sp_LoadSection] @LoadSection,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
EXEC SaveSchemaBackup 'sp_LoadSection';
GO
ALTER PROCEDURE [dbo].[sp_LoadSection]
(
	@LoadSection LoadSection READONLY,
	@IdUserAction int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

		Declare @InsertedSection table (IdSection int, SectionName varchar(50))

		INSERT INTO TB_Section(SectionName, Active, CreationDate, IdUserAction)
		output inserted.IdSection, inserted.SectionName into @InsertedSection
		SELECT DISTINCT A.SectionName, 1,DATEADD(HOUR,-5,GETDATE()), @IdUserAction 
		FROM @LoadSection A
		LEFT JOIN TB_Section B
		   ON B.SectionName = A.SectionName
		WHERE B.IdSection IS NULL AND A.SectionName <> ''

		select A.*, 
		case 
			when B.IdSection IS not null then 'Registro ingresado'
			when C.SectionName IS not null then 'Error: No ingresado porque la seccion ya existe'
			when A.SectionName = '' then 'Error: Nombre de la seccion vacio'
		end [Message]
		from @LoadSection A
		left join @InsertedSection B on A.SectionName = B.SectionName
		left join TB_Section C on A.SectionName = C.SectionName

		SET @Flag = 1;
		SET @Message = 'Sección cargada con exito.'

END
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadUnitOfMeasurement]    Script Date: 11/03/2025 8:26:32 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


EXEC SaveSchemaBackup 'sp_LoadUnitOfMeasurement';
GO
ALTER PROCEDURE [dbo].[sp_LoadUnitOfMeasurement]
    @UnitOfMeasurement LoadUnitOfMeasurement READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY

		declare @InsertedUnitOfMeasurement table (IdUnitOfMeasurement int, UnitOfMeasurement varchar(50))

        INSERT INTO TB_UnitOfMeasurement(UnitOfMeasurement, Active, CreationDate, IdUserAction)
		output inserted.IdUnitOfMeasurement, inserted.UnitOfMeasurement into @InsertedUnitOfMeasurement
        SELECT A.UnitOfMeasurement, 1 AS Active, @Date, @IdUser
        FROM @UnitOfMeasurement A
        LEFT JOIN TB_UnitOfMeasurement B
            ON A.UnitOfMeasurement = B.UnitOfMeasurement
        WHERE B.IdUnitOfMeasurement IS NULL and A.UnitOfMeasurement <> '';
        
		select A.*,
		case 
			when B.IdUnitOfMeasurement is not null then 'Registro ingresado.'
			when C.IdUnitOfMeasurement is not null then 'Error: Unidad de medida ya existe.'
			when A.UnitOfMeasurement = '' then 'Error: La unidad de medida esta vacia.'
		end [Message]
		from @UnitOfMeasurement A 
		left join @InsertedUnitOfMeasurement B on A.UnitOfMeasurement = B.UnitOfMeasurement
		left join TB_UnitOfMeasurement C on C.UnitOfMeasurement = A.UnitOfMeasurement

        SET @Status = 1;
        SET @StatusMessage = 'Los datos fueron procesados correctamente.';

    END TRY
    BEGIN CATCH
        -- Capturar error y retornar mensaje
        SET @Status = -1;
        SET @StatusMessage = ERROR_MESSAGE();
    END CATCH;

END
GO

