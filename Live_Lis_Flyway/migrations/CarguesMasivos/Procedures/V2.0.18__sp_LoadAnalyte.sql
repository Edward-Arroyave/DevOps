/****** Object:  StoredProcedure [dbo].[sp_LoadAnalyte]    Script Date: 19/02/2025 11:55:51 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_LoadAnalyte]
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
        BEGIN TRANSACTION;

        
        WITH AnalyteExam AS
        (
            SELECT 
                B.ExamCode, 
                B.IdExam, 
                COUNT(DISTINCT A.IdAnalyte) AS AnalyteCode
            FROM TB_Analyte A
            RIGHT JOIN TB_Exam B 
                ON A.IdExam = B.IdExam AND A.Active = 1 --AND A.AnalyteCode != B.ExamCode
            INNER JOIN @AnalyteList C 
                ON C.CodeExam = B.ExamCode --AND C.NameAnalyte != A.AnalyteName
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
        SELECT 
            A.IdExam, 
            A.ExamCode + case when GroupType = 'SI' Then '-' + CAST((A.AnalyteCode  + ROW_NUMBER() OVER (PARTITION BY A.ExamCode ORDER BY B.NameAnalyte)) AS VARCHAR) Else '' End AS AnalyteCode,
            B.NameAnalyte, 
            D.IdExamTechnique,
            E.IdUnitOfMeasurement,
            B.Comments,
            F.IdDataType,
            case when B.InitialValue = '' then null else B.InitialValue end,
            case when B.FinalValue = '' then null else B.FinalValue end,
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
        INNER JOIN TB_ExamTechnique D 
            ON D.ExamTechnique = B.ExamTechnique
        INNER JOIN TB_UnitOfMeasurement E 
            ON E.UnitOfMeasurement = B.UnitOfMeasurement
        INNER JOIN TB_DataType F 
            ON F.DataType = B.DataType
        LEFT JOIN TB_ExpectedValue G 
            ON G.ExpectedValue = B.ExpectedValue;

        -- Si la operación fue exitosa
        COMMIT TRANSACTION;
        SET @status = 1;
        SET @statusMessage = 'Datos insertados exitosamente en TB_Analyte.';
    END TRY
    BEGIN CATCH
        -- Manejo de errores
        ROLLBACK TRANSACTION;
        SET @status = 0;
        SET @statusMessage = ERROR_MESSAGE();
    END CATCH
END;
GO

