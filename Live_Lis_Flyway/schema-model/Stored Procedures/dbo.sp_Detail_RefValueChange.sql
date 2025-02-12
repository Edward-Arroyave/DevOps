SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/12/2022
-- Description: Procedimiento almacenado para crear valor de referencia de Analito.
-- =============================================
--EXEC [sp_Detail_RefValueChange] 52
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_RefValueChange]
(
	@IdRefValueChange int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdRefValueChange, IdReferenceValue, IdExamTechnique, IdMedicalDevice, IdReactive, IdBiologicalSex, MinAge, MaxAge, IdAgeTimeUnit, IdUnitOfMeasurement, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText, ScheduledUpdateDate
	FROM TB_RefValueChange
	WHERE IdRefValueChange = @IdRefValueChange
END
GO
