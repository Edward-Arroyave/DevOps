SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/11/20212
-- Description: Procedimiento almacenado para retornar detalle analito.
-- =============================================
--EXEC [sp_Consult_Analyte] 8
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Analyte]
(
	@IdExam int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdAnalyte, IdExam, AnalyteCode, AnalyteName, Visible, Active
	FROM TB_Analyte
	WHERE IdExam = @IdExam
	ORDER BY CASE WHEN Position IS NULL AND AnalyteCode LIKE '%-%' THEN CONVERT(int,SUBSTRING(AnalyteCode,(CHARINDEX('-',AnalyteCode)+1),3)) ELSE Position END ASC
END
GO
