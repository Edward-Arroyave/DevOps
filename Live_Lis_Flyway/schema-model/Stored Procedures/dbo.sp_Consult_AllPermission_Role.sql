SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/03/2022
-- Description: Procedimiento almacenado para listar todos los módulos y permisos para un rol.
-- =============================================
-- EXEC [dbo].[sp_Consult_AllPermission_Role] 18
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_AllPermission_Role]
(
	@IdRole int = NULL
)
AS
	DECLARE @IdProfile int
BEGIN
    SET NOCOUNT ON

	SET @IdProfile = (SELECT IdProfile FROM TB_Role WHERE IdRole = @IdRole)

	IF OBJECT_ID ('tempdb..##Module') IS NOT NULL
		BEGIN
			DROP TABLE ##Module
		END

	SELECT DISTINCT A.IdMenu AS IdModule, A.MenuName AS ModuleName, A.Level AS Level_Module, A.OrderNumber AS OrderNumber_Menu, AA.MenuIconCode, A.IdProfile,
					B.IdMenu AS IdSubModule_I, B.MenuName AS SubModule_I, B.Level AS Level_SubModule_I, B.OrderNumber AS OrderNumber_SubModule_I,
					C.IdMenu AS IdSubModule_II, C.MenuName AS SubModule_II, C.Level Level_SubModule_II, C.OrderNumber AS OrderNumber_SubModule_II,
					D.IdMenu AS IdSubModule_III, D.MenuName AS SubModule_III, D.Level AS Level_SubModule_III, D.OrderNumber AS OrderNumber_SubModule_III
		INTO ##Module
	FROM TB_Menu A
	LEFT JOIN TB_MenuIcon AA
		ON AA.IdMenuIcon = A.IdMenuIcon
	INNER JOIN TB_Menu B
		ON B.ParentIdMenu = A.IdMenu
			AND A.Active = 'True'
			AND B.Active = 'True'
	LEFT JOIN TB_Menu C
		ON C.ParentIdMenu = B.IdMenu
			AND C.Active = 'True'
	LEFT JOIN TB_Menu D
		ON D.ParentIdMenu = C.IdMenu
			AND D.Active = 'True'
	WHERE A.ParentIdMenu IS NULL
	--	AND A.IdProfile = @IdProfile
	ORDER BY A.OrderNumber, B.OrderNumber, C.OrderNumber, D.OrderNumber

	SELECT A.IdProfile, A.IdModule, A.ModuleName, A.Level_Module, A.OrderNumber_Menu, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, 
		A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.OrderNumber_SubModule_I, A.ToRead_SubModule_I, A.ToCreate_SubModule_I, A.ToUpdate_SubModule_I, 
		A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.OrderNumber_SubModule_II, A.ToRead_SubModule_II, A.ToCreate_SubModule_II, A.ToUpdate_SubModule_II, 
		A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III, A.OrderNumber_SubModule_III, B.ToRead ToRead_SubModule_III, B.ToCreate ToCreate_SubModule_III, B.ToUpdate ToUpdate_SubModule_III
	FROM (
		SELECT A.IdProfile, A.IdModule, A.ModuleName, A.Level_Module, A.OrderNumber_Menu, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, 
			A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.OrderNumber_SubModule_I, A.ToRead_SubModule_I, A.ToCreate_SubModule_I, A.ToUpdate_SubModule_I, 
			A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.OrderNumber_SubModule_II, B.ToRead ToRead_SubModule_II, B.ToCreate ToCreate_SubModule_II, B.ToUpdate ToUpdate_SubModule_II, 
			A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III, A.OrderNumber_SubModule_III
		FROM (
			SELECT  A.IdProfile, A.IdModule, A.ModuleName, A.Level_Module, A.OrderNumber_Menu, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, 
				A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, OrderNumber_SubModule_I, B.ToRead ToRead_SubModule_I, B.ToCreate ToCreate_SubModule_I, B.ToUpdate ToUpdate_SubModule_I, 
				A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.OrderNumber_SubModule_II, 
				A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III, A.OrderNumber_SubModule_III
			FROM (
				SELECT A.IdProfile, A.IdModule, A.ModuleName, A.Level_Module, A.MenuIconCode, A.OrderNumber_Menu, B.ToRead ToRead_Module, B.ToCreate ToCreate_Module, B.ToUpdate ToUpdate_Module, 
					A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, OrderNumber_SubModule_I,
					A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, OrderNumber_SubModule_II, 
					A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III, OrderNumber_SubModule_III
				FROM ##Module A
				LEFT JOIN TR_Role_Menu B
					ON B.IdMenu = A.IdModule
						AND B.IdRole = @IdRole
						AND B.Active = 'True'
				) A
			LEFT JOIN TR_Role_Menu B
				ON B.IdMenu = A.IdSubModule_I
					AND B.IdRole = @IdRole
					AND B.Active = 'True'
			) A
		LEFT JOIN TR_Role_Menu B
			ON B.IdMenu = A.IdSubModule_II
				AND B.IdRole = @IdRole
				AND B.Active = 'True'
		) A
	LEFT JOIN TR_Role_Menu B
		ON B.IdMenu = A.IdSubModule_III
			AND B.IdRole = @IdRole
			AND B.Active = 'True'
	ORDER BY A.ModuleName,A.OrderNumber_Menu, A.OrderNumber_SubModule_I, A.OrderNumber_SubModule_II, A.OrderNumber_SubModule_III ASC
END
GO
