SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/05/2023
-- Description: Procedimiento almacenado para consultar trazabilidad de las muestras de Paternidad
-- =============================================
-- EXEC [History].[sp_Consult_TraceabilityPaternSamples] 480
-- =============================================
CREATE PROCEDURE [History].[sp_Consult_TraceabilityPaternSamples]
(
	@IdRequest_Patient int
)
AS
BEGIN
    SET NOCOUNT ON

    SELECT A.IdRequest, A.RequestNumber, A.IdPatient, A.ActionDate, 
			CASE WHEN SampleChangeReason = '' OR SampleChangeReason IS NULL THEN CONCAT('Registro muestra "', B.SampleType, '"') ELSE CONCAT('Cambio de muestra a "', B.SampleType,'"') END AS Movement, 
			A.SampleChangeReason
	FROM (
			SELECT IdRequest, RequestNumber, IdPatient, ActionDate, Action, IdSampleType,
			    CASE WHEN IdSampleType = LAG(IdSampleType, 1, 0) OVER (ORDER BY ActionDate) THEN 0 ELSE 1 END AS Igual,
				SampleChangeReason
			FROM History.TH_PaternityRequest_Patient
			WHERE IdRequest_Patient = @IdRequest_Patient
				AND IdSampleType IS NOT NULL
			) A
	INNER JOIN TB_SampleType B
		ON B.IdSampleType = A.IdSampleType
	WHERE A.Igual = 1
	ORDER BY A.IdPatient, A.Action, A.ActionDate
END
GO
