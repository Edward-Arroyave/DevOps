SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/05/2023
-- Description: Procedimiento almacenado para a consultar detalles de cambio de valores de referencia.
-- =============================================
--EXEC [sp_Detail_UpdateReferenceValue] 46
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_UpdateReferenceValue]
(
	@IdRefValueChange int
)
AS
	DECLARE @IdRefValueChangeBef int, @IdRefValueChangeStatus int, @IdReferenceValue int
BEGIN
    SET NOCOUNT ON

	SET @IdRefValueChangeStatus = (SELECT IdRefValueChangeStatus FROM TB_RefValueChange WHERE IdRefValueChange = @IdRefValueChange)
	SET @IdReferenceValue = (SELECT IdReferenceValue FROM TB_RefValueChange WHERE IdRefValueChange = @IdRefValueChange)
	SET @IdRefValueChangeBef = (SELECT TOP 1 IdRefValueChange FROM TB_RefValueChange WHERE IdReferenceValue = @IdReferenceValue AND IdRefValueChange < @IdRefValueChange ORDER BY IdRefValueChange DESC)

	IF @IdRefValueChangeStatus != 1
		BEGIN
			SELECT A.IdRefValueChange, A.IdReferenceValue, A.IdMedicalDevice, B.MedicalDevice, A.IdReactive, A.IdExamTechnique, C.ExamTechnique, H.Reactive, A.IdBiologicalSex, D.BiologicalSex, CONCAT(A.MinAge,' - ', A.MaxAge, ' ', F.TimeUnit) AgeRange, A.IdDataType, E.DataType, 
				CASE WHEN A.IdDataType = 1 THEN G.ExpectedValue ELSE CONCAT_WS(' - ', A.InitialValue, A.FinalValue) END ReferenceValue,
				A.IdUnitOfMeasurement, I.UnitOfMeasurement, A.CreationDate, ISNULL(A.ReturnDate, A.ScheduledUpdateDate) AS ScheduledUpdateDate
			FROM TB_RefValueChange A
			INNER JOIN TB_MedicalDevice B
				ON B.IdMedicalDevice = A.IdMedicalDevice
			INNER JOIN TB_ExamTechnique C
				ON C.IdExamTechnique = A.IdExamTechnique
			INNER JOIN TB_BiologicalSex D
				ON D.IdBiologicalSex = A.IdBiologicalSex
			INNER JOIN TB_DataType E
				ON E.IdDataType = A.IdDataType
			INNER JOIN TB_TimeUnit F
				ON F.IdTimeUnit = A.IdAgeTimeUnit
			INNER JOIN TB_Reactive H
				ON H.IdReactive = A.IdReactive
			INNER JOIN TB_UnitOfMeasurement I
				ON I.IdUnitOfMeasurement = A.IdUnitOfMeasurement
			INNER JOIN TB_RefValueChangeStatus J
				ON J.IdRefValueChangeStatus = A.IdRefValueChangeStatus
			LEFT JOIN TB_ExpectedValue G
					ON G.IdExpectedValue = A.IdExpectedValue
			WHERE A.IdRefValueChange IN (@IdRefValueChange, @IdRefValueChangeBef)
			ORDER BY A.IdRefValueChange DESC
		END
	ELSE
		BEGIN
			SELECT '' AS IdRefValueChange, A.IdReferenceValue, A.IdMedicalDevice, B.MedicalDevice, A.IdReactive, A.IdExamTechnique, C.ExamTechnique, H.Reactive, A.IdBiologicalSex, D.BiologicalSex, CONCAT(A.MinAge,' - ', A.MaxAge, ' ', F.TimeUnit) AgeRange, A.IdDataType, E.DataType, 
				CASE WHEN A.IdDataType = 1 THEN G.ExpectedValue ELSE CONCAT_WS(' - ', A.InitialValue, A.FinalValue) END ReferenceValue,
				A.IdUnitOfMeasurement, I.UnitOfMeasurement, A.CreationDate, 'Vigente' AS ScheduledUpdateDate	
			FROM TB_ReferenceValue A
			INNER JOIN TB_MedicalDevice B
				ON B.IdMedicalDevice = A.IdMedicalDevice
			INNER JOIN TB_ExamTechnique C
				ON C.IdExamTechnique = A.IdExamTechnique
			INNER JOIN TB_BiologicalSex D
				ON D.IdBiologicalSex = A.IdBiologicalSex
			INNER JOIN TB_DataType E
				ON E.IdDataType = A.IdDataType
			INNER JOIN TB_TimeUnit F
				ON F.IdTimeUnit = A.IdAgeTimeUnit
			INNER JOIN TB_Reactive H
				ON H.IdReactive = A.IdReactive
			INNER JOIN TB_UnitOfMeasurement I
				ON I.IdUnitOfMeasurement = A.IdUnitOfMeasurement
			LEFT JOIN TB_ExpectedValue G
					ON G.IdExpectedValue = A.IdExpectedValue
			WHERE A.IdReferenceValue = @IdReferenceValue

			UNION ALL

			SELECT A.IdRefValueChange, A.IdReferenceValue, A.IdMedicalDevice, B.MedicalDevice, A.IdReactive, A.IdExamTechnique, C.ExamTechnique, H.Reactive, A.IdBiologicalSex, D.BiologicalSex, CONCAT(A.MinAge,' - ', A.MaxAge, ' ', F.TimeUnit) AgeRange, A.IdDataType, E.DataType, 
				CASE WHEN A.IdDataType = 1 THEN G.ExpectedValue ELSE CONCAT_WS(' - ', A.InitialValue, A.FinalValue) END ReferenceValue,
				A.IdUnitOfMeasurement, I.UnitOfMeasurement, A.CreationDate, J.RefValueChangeStatus AS ScheduledUpdateDate	
			FROM TB_RefValueChange A
			INNER JOIN TB_MedicalDevice B
				ON B.IdMedicalDevice = A.IdMedicalDevice
			INNER JOIN TB_ExamTechnique C
				ON C.IdExamTechnique = A.IdExamTechnique
			INNER JOIN TB_BiologicalSex D
				ON D.IdBiologicalSex = A.IdBiologicalSex
			INNER JOIN TB_DataType E
				ON E.IdDataType = A.IdDataType
			INNER JOIN TB_TimeUnit F
				ON F.IdTimeUnit = A.IdAgeTimeUnit
			INNER JOIN TB_Reactive H
				ON H.IdReactive = A.IdReactive
			INNER JOIN TB_UnitOfMeasurement I
				ON I.IdUnitOfMeasurement = A.IdUnitOfMeasurement
			INNER JOIN TB_RefValueChangeStatus J
				ON J.IdRefValueChangeStatus = A.IdRefValueChangeStatus
			LEFT JOIN TB_ExpectedValue G
					ON G.IdExpectedValue = A.IdExpectedValue
			WHERE A.IdRefValueChange = @IdRefValueChange
		END

END
GO
