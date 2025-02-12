SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:     Wendy Paola Tellez Gonzalez
-- Create Date: 30/09/2022
-- Description: Procedimiento almacenado para generar etiquetas.
-- ============================================
-- EXEC [dbo].[sp_Generate_Label] 64346
-- ============================================
CREATE PROCEDURE [dbo].[sp_Generate_Label]
(
	@IdRequest int
)
AS
BEGIN
    SET NOCOUNT ON

	IF OBJECT_ID ('tempdb..#Exam_Sample') IS NOT NULL
		BEGIN
			DROP TABLE #Exam_Sample
		END

	SELECT C.ExamCode, E.IdSampleType, E.AlternativeCode, E.SampleType, F.ContractCode, G.AttentionCenterCode
		INTO #Exam_Sample
	FROM TB_Request A
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest
			AND B.Active = 'True'
	INNER JOIN TB_Exam C
		ON C.IdExam = B.IdExam
	INNER JOIN TR_Exam_SampleType D
		ON D.IdExam = C.IdExam
			AND D.Active = 'True'
	INNER JOIN TB_SampleType E
		ON E.IdSampleType = D.IdSampleType
	INNER JOIN TB_Contract F
		ON F.IdContract = A.IdContract
	INNER JOIN TB_AttentionCenter G
		ON G.IdAttentionCenter = isnull(A.IdAttentionCenterOrigin,A.IdAttentionCenter)
	WHERE A.IdRequest = @IdRequest

	UNION ALL

	SELECT DISTINCT I.ExamCode, E.IdSampleType, E.AlternativeCode, E.SampleType, F.ContractCode, G.AttentionCenterCode
	FROM TB_Request A
	INNER JOIN TR_Request_Exam B
		ON B.IdRequest = A.IdRequest
			AND B.Active = 'True'
	INNER JOIN TB_ExamGroup C
		ON C.IdExamGroup = B.IdExamGroup
	INNER JOIN TR_ExamGroup_Exam H
		ON H.IdExamGroup = C.IdExamGroup
			AND H.Active = 'True'
	INNER JOIN TB_Exam I
		ON I.IdExam = H.IdExam
	INNER JOIN TR_Exam_SampleType D
		ON D.IdExam = I.IdExam
			AND D.Active = 'True'
	INNER JOIN TB_SampleType E
		ON E.IdSampleType = D.IdSampleType
	INNER JOIN TB_Contract F
		ON F.IdContract = A.IdContract
	INNER JOIN TB_AttentionCenter G
		ON G.IdAttentionCenter = isnull(A.IdAttentionCenterOrigin,A.IdAttentionCenter)
	WHERE A.IdRequest = @IdRequest
	
	SELECT DISTINCT STUFF((
				SELECT ', ' + B.ExamCode
				FROM #Exam_Sample B
				WHERE A.IdSampleType = B.IdSampleType
				FOR XML PATH('')),1,1,'') ExamCode, A.AlternativeCode AS IdSampleType, A.SampleType, A.ContractCode, A.AttentionCenterCode
	FROM #Exam_Sample A

END
GO
