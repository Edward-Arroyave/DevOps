SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/12/2022
-- Description: Procedimiento almacenado para retornar detalle de valor de referencia de Analito.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_ReferenceValue]
(
	@IdReferenceValue int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdAnalyte, IdExamTechnique, IdMedicalDevice, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, IdUnitOfMeasurement, IdReactive, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText
	FROM TB_ReferenceValue
	WHERE IdReferenceValue = @IdReferenceValue
END
GO
