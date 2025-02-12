SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 25/10/2022	
-- Description: Procedimiento almacenado para consultar examenes.
-- =============================================
--  EXEC [sp_Consult_Exam] '','','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Exam]
(
	@CUPSOrCode varchar(10),
	@ExamName varchar(100),
	@IdSampleType varchar(5),
	@IdSection varchar(5),
	@PageSize INT = 200,
	@NumberPage int = 1
)
AS
	declare @SKIPPEDROWS INT, @OriginalSize int

BEGIN
    SET NOCOUNT ON

	SET @OriginalSize = 200
	SET @SKIPPEDROWS = (@NumberPage-1)*@OriginalSize
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 06/02/2024
-- Description: Se quita el top en la consulta debido a agregacion de paginacion de resultados y se agrega a la consulta COUNT(*) OVER () TotalRecords
-- Pruebas:		Realizadas con El Inge Willinton Morales
-- Antes:	SELECT DISTINCT  TOP 1000 A.IdExam,
-- Ahora:	SELECT DISTINCT  A.IdExam,
-- =============================================
	SELECT DISTINCT  A.IdExam,
		STUFF((SELECT ',' + CONVERT(varchar(6), G.CUPS)
				FROM TR_Service_Exam F
				INNER JOIN TB_Service G
					ON G.IdService = F.IdService
				WHERE F.IdExam = A.IdExam
					AND F.Active = 'True'
				FOR XML PATH('')),1,1,'') CUPS,
		A.ExamCode, A.ExamName, 
		STUFF((SELECT ',' + CONVERT(varchar(6), G.IdSampleType)
				FROM TR_Exam_SampleType G
				WHERE G.IdExam = A.IdExam
					AND G.Active = 'True'
				FOR XML PATH('')),1,1,'') IdSampleType,
		STUFF((SELECT ',' + CONVERT(varchar(50), H.SampleType)
				FROM TR_Exam_SampleType G
				INNER JOIN TB_SampleType H
					ON H.IdSampleType = G.IdSampleType
				WHERE G.IdExam = A.IdExam
					AND G.Active = 'True'
				FOR XML PATH('')),1,1,'') SampleType,
		E.IdSection, E.SectionName, A.IdAdditionalForm, A.Active, 
		A.Score, A.PlanValidity, A.IdValidityFormat, A.ActiveValidity, COUNT(*) OVER () TotalRecords
	FROM TB_Exam A 
	LEFT JOIN TR_Service_Exam B
		ON B.IdExam = A.IdExam
			AND B.Active = 'True'
	LEFT JOIN TB_Service C
		ON C.IdService = B.IdService
	LEFT JOIN TR_Exam_SampleType F
		ON F.IdExam = A.IdExam
	LEFT JOIN TB_Section E
		ON E.IdSection = A.IdSection
	WHERE ((CASE WHEN @CUPSOrCode = '' THEN '' ELSE C.CUPS END = @CUPSOrCode)
				OR (CASE WHEN @CUPSOrCode = '' THEN '' ELSE A.ExamCode END) = @CUPSOrCode)
			AND CASE WHEN @ExamName = '' THEN '' ELSE A.ExamName END LIKE '%' +@ExamName+ '%'
			AND CASE WHEN @IdSampleType = '' THEN '' ELSE F.IdSampleType END = @IdSampleType
			AND CASE WHEN @IdSection = '' THEN '' ELSE E.IdSection END = @IdSection
	ORDER BY A.IdExam DESC

	OFFSET @SKIPPEDROWS ROWS
	FETCH NEXT @PageSize ROWS ONLY

END

GO
