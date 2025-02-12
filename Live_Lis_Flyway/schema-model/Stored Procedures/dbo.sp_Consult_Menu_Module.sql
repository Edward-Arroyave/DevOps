SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 25/04/2022
-- Description: Procedimiento almacenado consultar módulo del menú creado.
-- =============================================
-- EXEC [dbo].[sp_Consult_Menu_Module] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Menu_Module]
AS
BEGIN
	SELECT DISTINCT A.IdMenu AS IdModule, A.MenuName AS ModuleName, A.Level AS Level_Module, A.OrderNumber AS OrderNumberModule, A.Status AS StatusModule, MI.MenuIconCode, A.Active AS ActiveModule, 
					B.IdMenu AS IdSubModule_I, B.MenuName AS SubModule_I, B.Level AS Level_SubModule_I, B.OrderNumber AS OrderNumberSubModule_I, B.Status AS StatusSubModule_I, B.Active AS ActiveSubModule_I,
					C.IdMenu AS IdSubModule_II, C.MenuName AS SubModule_II, C.Level Level_SubModule_II, C.OrderNumber AS OrderNumberSubModule_II, C.Status AS StatusSubModule_II, C.Active AS ActiveSubModule_II,
					D.IdMenu AS IdSubModule_III, D.MenuName AS SubModule_III, D.Level AS Level_SubModule_III, D.OrderNumber AS OrderNumberSubModule_III, D.Status AS StatusSubModule_III, D.Active AS ActiveSubModule_III
	FROM TB_Menu A
	LEFT JOIN TB_MenuIcon MI
		ON MI.IdMenuIcon = A.IdMenuIcon
	LEFT JOIN TB_Menu B
		ON B.ParentIdMenu = A.IdMenu
			AND B.Active = 'True'
	LEFT JOIN TB_Menu C
		ON C.ParentIdMenu = B.IdMenu
			AND C.Active = 'True'
	LEFT JOIN TB_Menu D
		ON D.ParentIdMenu = C.IdMenu
			AND D.Active = 'True'
	WHERE A.ParentIdMenu IS NULL
		AND A.Active = 'True'
	ORDER BY A.OrderNumber, A.IdMenu, B.OrderNumber, B.IdMenu, C.OrderNumber, C.IdMenu, D.OrderNumber, D.IdMenu
END
GO
