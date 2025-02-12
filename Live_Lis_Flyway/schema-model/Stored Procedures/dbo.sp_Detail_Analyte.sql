SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/11/2022
-- Description: Procedimiento almacenado para retornar detalle analito.
-- =============================================
--EXEC [sp_Consult_Analyte] '','','',''
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_Analyte]
(
	@IdAnalyte int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdAnalyte, IdExam, AnalyteCode, AnalyteName, IdSampleType, IdExamTechnique, IdUnitOfMeasurement, Comments, ResultFormula, IdDataType, InitialValue, FinalValue, IdExpectedValue, CodificationText
	FROM TB_Analyte
	WHERE IdAnalyte = @IdAnalyte
END
GO
