SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		Wendy Paola Tellez Gonzalez
-- Create Date: 03/11/2022
-- Description: Procedimiento almacenado para ver información de un examen. 
-- =============================================
--	EXEC [sp_Detail_Exam] 595
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Exam]
(
	@IdExam int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT distinct A.IdExam, A.GroupType, 
		STUFF((SELECT ', ' + CONVERT(VARCHAR(50), B.IdService)
				FROM TR_Service_Exam B
				WHERE B.IdExam = A.IdExam
					AND B.Active = 'True'
				FOR XML PATH('')),1,1,'') IdService,
		A.ExamCode, A.ExamName, A.LevelOfComplexity, A.IdExamType, H.ExamType, A.IdSection, I.SectionName, A.IdBiologicalSex, J.BiologicalSex, A.MinAge, A.MaxAge, A.IdAgeTimeUnit, K.TimeUnit AS AgeUnit, A.Priority, 
		STUFF((SELECT ', ' + CONVERT(VARCHAR(5), D.IdOptimumShippingTemperature)
				FROM TR_Exam_OptShippingTemp D
				WHERE D.IdExam = A.IdExam
					AND D.Active = 'True'
				FOR XML PATH('')),1,1,'') IdOptimumShippingTemperature,
		A.AmbientTemperature, A.RefrigeratedTemperture, A.FrozenTemperature, A.SampleConditions, A.IdExamTechnique, M.ExamTechnique, A.DeliveryOpportunity, A.ControlOpportunity, A.ResultsFormula, A.Comment, A.VisibleResult, A.Decimal, A.Monday, A.Tuesday, A.Wednesday, 
		A.Thursday, A.Friday, A.Saturday, A.Sunday, A.Confidential, A.PreparationOrObservation, A.ClinicalImportance, A.OtherObservations,
		A.TestComponents, A.PBS, A.SOATCode, A.EpidemiologicalNotification, A.TakingFrequency, A.IdTimeUnit, K2.TimeUnit,
		STUFF((SELECT ', ' + CONVERT(VARCHAR(5), E.IdAttentionCenter)
				FROM TR_Exam_AttentionCenter E
				WHERE E.IdExam = A.IdExam
					AND E.Active = 'True'
				FOR XML PATH('')),1,1,'') IdAttentionCenter,
				A.IdTemplate, A.AmbientTemperature, A.RefrigeratedTemperture, A.FrozenTemperature, T.TemplateStartDate,
				A.Score, A.PlanValidity, A.IdValidityFormat, A.ActiveValidity
	FROM TB_Exam A
	LEFT JOIN TB_ExamType H
		ON H.IdExamType = A.IdExamType
	LEFT JOIN TB_Section I
		ON I.IdSection = A.IdSection
	LEFT JOIN TB_BiologicalSex J
		ON J.IdBiologicalSex = A.IdBiologicalSex
	LEFT JOIN TB_TimeUnit K
		ON K.IdTimeUnit = A.IdAgeTimeUnit
	LEFT JOIN TB_TimeUnit K2
		ON K2.IdTimeUnit = A.IdTimeUnit
	LEFT JOIN TB_ExamTechnique M
		ON M.IdExamTechnique = A.IdExamTechnique
	LEFT JOIN TR_Template_Exam T
		ON A.IdExam = T.IdExam and T.TemplateEndDate is null
	WHERE A.IdExam = @IdExam

	SELECT B.IdSampleType, C.SampleType, B.IdContainerType, D.ContainerTypeName, B.Volume, B.IdVolumeMeasure, E.VolumeMeasure, B.Active, B.AmbientTemperature, 
	B.RefrigeratedTemperture, B.FrozenTemperature, B.Required, A.Score, A.PlanValidity, A.IdValidityFormat, A.ActiveValidity
	FROM TB_Exam A
	INNER JOIN TR_Exam_SampleType B
		ON B.IdExam = A.IdExam
	INNER JOIN TB_SampleType C
		ON C.IdSampleType = B.IdSampleType
	LEFT JOIN TB_ContainerType D
		ON D.IdContainerType = B.IdContainerType
	LEFT JOIN TB_VolumeMeasure E
		ON E.IdVolumeMeasure = B.IdVolumeMeasure
	WHERE A.IdExam = @IdExam
	--	AND B.Active = 'True'
END
GO
