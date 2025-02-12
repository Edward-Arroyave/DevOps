SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/05/2023
-- Description: Procedimiento almacenado para actuallizar valores de referencia de acuerdo con la programación.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Update_ReferenceValue]
AS
BEGIN
    SET NOCOUNT ON

	UPDATE A
		SET IdExamTechnique = B.IdExamTechnique,
			IdMedicalDevice = B.IdMedicalDevice,
			IdReactive = B.IdReactive,
			IdBiologicalSex = B.IdBiologicalSex,
			MinAge = B.MinAge,
			MaxAge = B.MaxAge,
			IdAgeTimeUnit = B.IdAgeTimeUnit,
			IdUnitOfMeasurement = B.IdUnitOfMeasurement,
			IdDataType = B.IdDataType,
			InitialValue = B.InitialValue,
			FinalValue = B.FinalValue,
			IdExpectedValue = B.IdExpectedValue,
			CodificationText = B.CodificationText
	FROM TB_ReferenceValue A
	INNER JOIN TB_RefValueChange B
		ON B.IdReferenceValue = A.IdReferenceValue
	WHERE B.IdRefValueChangeStatus = 1
		AND B.ScheduledUpdateDate = CONVERT(DATE,DATEADD(HOUR,-5,GETDATE()))


	UPDATE TB_RefValueChange
		SET IdRefValueChangeStatus = 2
	FROM TB_RefValueChange
	WHERE IdRefValueChangeStatus = 1
		AND ScheduledUpdateDate = CONVERT(DATE,DATEADD(HOUR,-5,GETDATE()))

END
GO
