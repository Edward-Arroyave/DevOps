SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/09/2023
-- Description: Procedimiento almacenado para consultar resultado de examen.
-- =============================================
--EXEC [WebResult].[sp_Consult_ExamResult] 487163
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Consult_ExamResult]
(
	@IdPatient_Exam int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdRequest, B.IdPatient_Exam, B.IdExam, E.ExamCode, E.ExamName
	FROM TB_Request A
	INNER JOIN TR_Patient_Exam B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_Exam E
		ON E.IdExam = B.IdExam
	WHERE B.IdPatient_Exam = @IdPatient_Exam
	ORDER BY A.IdRequest

	SELECT A.IdRequest, C.IdAnalyte, D.AnalyteCode, D.AnalyteName,
		CASE WHEN F.IdDataType = 1 THEN G.ExpectedValue
			WHEN F.IdDataType = 2 THEN CONCAT(F.InitialValue, ' - ', F.FinalValue)
			WHEN F.IdDataType = 3 THEN F.CodificationText END AS ReferenceValue,
		C.Results
	FROM TB_Request A
	INNER JOIN TR_Patient_Exam B
		ON B.IdRequest = A.IdRequest
	INNER JOIN TB_Exam E
		ON E.IdExam = B.IdExam
	LEFT JOIN ANT.TB_Results C
		ON C.IdPatient_Exam = B.IdPatient_Exam
	LEFT JOIN TB_Analyte D
		ON D.IdAnalyte = C.IdAnalyte
	LEFT JOIN TB_ReferenceValue F
		ON F.IdAnalyte = C.IdAnalyte
			AND F.IdReferenceValue = C.IdReferenceValue
			AND F.Active = 'True'
	LEFT JOIN TB_ExpectedValue G
		ON G.IdExpectedValue = F.IdExpectedValue
			AND G.Active = 'True'
	WHERE B.IdPatient_Exam = @IdPatient_Exam
	ORDER BY A.IdRequest
END
GO
