SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 30/09/2021
-- Description: Procedimiento almacenado para listar los permisos sociados un rol.
-- =============================================
-- EXEC [sp_Consult_Permission_Role] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Permission_Role]
(
	@IdRole int
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT * FROM TB_Role WHERE IdRole = @IdRole AND Active = 'True')
		BEGIN
			IF OBJECT_ID ('tempdb..#Module') IS NOT NULL
				BEGIN
					DROP TABLE #Module
				END
			
			SELECT DISTINCT A.IdRole, A.RoleName, C.IdMenu, C.MenuName, C.Level, B.ToRead, B.ToCreate, B.ToUpdate
				INTO #Module
			FROM TB_Role A
			INNER JOIN TR_Role_Menu B
				ON B.IdRole = A.IdRole
			INNER JOIN TB_Menu C
				ON C.IdMenu = B.IdMenu
					AND C.ParentIdMenu IS NULL
			WHERE A.IdRole = @IdRole


			IF OBJECT_ID ('tempdb..#SubModule_I') IS NOT NULL
				BEGIN
					DROP TABLE #SubModule_I
				END
			
			SELECT DISTINCT A.IdRole, A.RoleName, C.IdMenu, C.MenuName, C.ParentIdMenu, C.Level, B.ToRead, B.ToCreate, B.ToUpdate
				INTO #SubModule_I
			FROM TB_Role A
			INNER JOIN TR_Role_Menu B
				ON B.IdRole = A.IdRole
			INNER JOIN TB_Menu C
				ON C.IdMenu = B.IdMenu
					AND C.Level = 2
			WHERE A.IdRole = @IdRole

			IF OBJECT_ID ('tempdb..#SubModule_II') IS NOT NULL
				BEGIN
					DROP TABLE #SubModule_II
				END

			SELECT DISTINCT A.IdRole, A.RoleName, C.IdMenu, C.MenuName, C.ParentIdMenu, C.Level, B.ToRead, B.ToCreate, B.ToUpdate
				INTO #SubModule_II
			FROM TB_Role A
			INNER JOIN TR_Role_Menu B
				ON B.IdRole = A.IdRole
			INNER JOIN TB_Menu C
				ON C.IdMenu = B.IdMenu
					AND C.Level = 3
			WHERE A.IdRole = @IdRole

			IF OBJECT_ID ('tempdb..#SubModule_III') IS NOT NULL
				BEGIN
					DROP TABLE #SubModule_III
				END

			SELECT DISTINCT A.IdRole, A.RoleName, C.IdMenu, C.MenuName, C.ParentIdMenu, C.Level, B.ToRead, B.ToCreate, B.ToUpdate
				INTO #SubModule_III
			FROM TB_Role A
			INNER JOIN TR_Role_Menu B
				ON B.IdRole = A.IdRole
			INNER JOIN TB_Menu C
				ON C.IdMenu = B.IdMenu
					AND C.Level = 4
			WHERE A.IdRole = @IdRole

			IF OBJECT_ID ('tempdb..#PermissionRole') IS NOT NULL
				BEGIN
					DROP TABLE #PermissionRole
				END

			SELECT A.IdRole, A.RoleName, A.IdMenu IdModule, A.MenuName Module, A.Level Level_Module, A.ToRead ToRead_Module, A.ToCreate ToCreate_Module, A.ToUpdate ToUpdate_Module, 
				B.IdMenu IdSubModule_I, B.MenuName SubModule_I, B.Level Level_SubModule_I, B.ToRead ToRead_SubModule_I, B.ToCreate, B.ToUpdate,
				C.IdMenu IdSubModule_II, C.MenuName SubModule_II, C.Level Level_SubModule_II, C.ToRead ToRead_SubModule_II, C.ToCreate ToCreate_SubModule_II, C.ToUpdate ToUpdate_SubModule_II, 
				D.IdMenu IdSubModule_III, D.MenuName SubModule_III, D.Level Level_SubModule_III, D.ToRead ToRead_SubModule_III, D.ToCreate ToCreate_SubModule_III, D.ToUpdate ToUpdate_SubModule_III
			FROM #Module A
			LEFT JOIN #SubModule_I B
				ON B.ParentIdMenu = A.IdMenu
			LEFT JOIN #SubModule_II C
				ON C.ParentIdMenu = B.IdMenu
			LEFT JOIN #SubModule_III D
				ON D.ParentIdMenu = C.IdMenu
		END
END
GO
