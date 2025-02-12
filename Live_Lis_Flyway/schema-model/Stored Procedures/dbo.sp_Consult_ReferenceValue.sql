SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/12/2022
-- Description: Procedimiento almacenado para retornar consultar valores de referencia de Analito.
-- =============================================
--EXEC [sp_Consult_ReferenceValue] 9597 
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_ReferenceValue]
(
	@IdAnalyte int
)
AS
BEGIN
    SET NOCOUNT ON

SELECT	A.IdReferenceValue, A.IdAnalyte, A.IdMedicalDevice, B.MedicalDevice, A.IdReactive, H.Reactive, A.IdExamTechnique, C.ExamTechnique, A.IdBiologicalSex, D.BiologicalSex, 
		CONCAT(A.MinAge,' - ', A.MaxAge, ' ', F.TimeUnit) AgeRange, A.IdDataType, E.DataType, A.IdUnitOfMeasurement, I.UnitOfMeasurement, 
		CASE WHEN A.IdDataType = 1 THEN G.ExpectedValue ELSE CONCAT_WS(' - ', A.InitialValue, A.FinalValue) END ReferenceValue, A.Status AS Active, K.Name AS CommercialHouse
FROM	TB_ReferenceValue A
		INNER JOIN TB_MedicalDevice B
			ON B.IdMedicalDevice = A.IdMedicalDevice
		LEFT JOIN TB_ExamTechnique C
			ON C.IdExamTechnique = A.IdExamTechnique
		INNER JOIN TB_BiologicalSex D
			ON D.IdBiologicalSex = A.IdBiologicalSex
		LEFT JOIN TB_DataType E
			ON E.IdDataType = A.IdDataType
		INNER JOIN TB_TimeUnit F
			ON F.IdTimeUnit = A.IdAgeTimeUnit
		INNER JOIN TB_Reactive H
			ON H.IdReactive = A.IdReactive
		LEFT JOIN TB_UnitOfMeasurement I
			ON I.IdUnitOfMeasurement = A.IdUnitOfMeasurement
		LEFT JOIN TB_ExpectedValue G
			ON G.IdExpectedValue = A.IdExpectedValue
		LEFT JOIN TR_CommercialHouse_Reactive J
			ON J.IdReactive = H.IdReactive AND J.Active = 1
		LEFT JOIN TB_CommercialHouses K
			ON K.IdCommercialHouses = J.IdCommercialHouse AND K.Active = 1
WHERE	A.IdAnalyte = @IdAnalyte
AND		A.Active = 'True'
END
GO
