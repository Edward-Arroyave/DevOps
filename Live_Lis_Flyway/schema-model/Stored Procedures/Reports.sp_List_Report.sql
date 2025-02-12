SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/07/2022
-- Description: Procedimiento almacenado para listar informes de acuerdo con el módulo.
-- =============================================
-- EXEC [Reports].[sp_List_Report] 71
-- =============================================
CREATE PROCEDURE [Reports].[sp_List_Report]
(
	@IdMenu int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdReport, A.ReportName, A.ReportCode
	FROM Reports.TB_ReportList A
	INNER JOIN TB_Menu B
		ON B.IdMenu = A.IdMenu
	INNER JOIN TB_Profile C
		ON C.IdProfile = A.IdProfile
	WHERE A.IdMenu = @IdMenu
END


GO
