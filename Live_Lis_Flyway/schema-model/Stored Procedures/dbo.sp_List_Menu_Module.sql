SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 24/04/2022
-- Description: Procedimiento almacenado para listar un módulo o submódulo en el menú.
-- =============================================
-- EXEC [sp_List_Menu_Module] 
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Menu_Module]
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdMenu AS IdModule, A.MenuName AS ModuleName, A.Level Level_Module, A.OrderNumber AS OrderNumberModule, A.Active, 
				B.IdMenu AS IdSubModule_I, B.MenuName AS SubModule_I, B.Level Level_SubModule_I, B.OrderNumber AS OrderNumberSubModule_I,
				C.IdMenu AS IdSubModule_II, C.MenuName AS SubModule_II, C.Level Level_SubModule_II, C.OrderNumber AS OrderNumberSubModule_II,
				D.IdMenu AS IdSubModule_III, D.MenuName AS SubModule_III, D.Level Level_SubModule_III, D.OrderNumber AS OrderNumberSubModule_III
	FROM TB_Menu A
	LEFT JOIN TB_Menu B
		ON B.ParentIdMenu = A.IdMenu
			AND A.Active = 'True'
			AND B.Active = 'True'
			AND B.MenuURL IS NULL
	LEFT JOIN TB_Menu C
		ON C.ParentIdMenu = B.IdMenu
			AND C.Active = 'True'
			AND C.MenuURL IS NULL
	LEFT JOIN TB_Menu D
		ON D.ParentIdMenu = C.IdMenu
			AND D.Active = 'True'
			AND D.MenuURL IS NULL
	WHERE A.ParentIdMenu IS NULL
	ORDER BY A.OrderNumber, A.IdMenu, B.OrderNumber, C.OrderNumber, D.OrderNumber
END
GO
