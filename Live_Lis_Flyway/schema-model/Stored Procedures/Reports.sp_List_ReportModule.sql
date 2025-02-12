SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/07/2022
-- Description: Procedimiento almacenado para listar módulos de informes.
-- =============================================
--EXEC [Reports].[sp_List_ReportModule] 1
-- =============================================
CREATE PROCEDURE [Reports].[sp_List_ReportModule]
(
	@IdProfile int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT 
		B.IdMenu, 
		CASE 
			WHEN B.IdMenu = 15 THEN 'Tesorería' 
			WHEN B.IdMenu = 64 THEN 'Facturación' 
			WHEN B.IdMenu = 177 THEN 'Radicación' 
			ELSE B.MenuName END ModuleName
	FROM Reports.TB_ReportList A
	INNER JOIN TB_Menu B
		ON B.IdMenu = A.IdMenu
	INNER JOIN TB_Profile C
		ON C.IdProfile = A.IdProfile
	WHERE A.IdProfile = @IdProfile
END
GO
