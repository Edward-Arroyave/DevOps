SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/03/2022
-- Description: Procedimiento almacenado para listar todos los módulos y permisos.
-- =============================================
-- EXEC [dbo].[sp_Consult_Permission_User] 1029
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Permission_User]
(
	@IdUser int
)
AS
	DECLARE @IdProfile varchar(10)
	DECLARE @SQL NVARCHAR(4000)
BEGIN
    SET NOCOUNT ON

	SET @IdProfile = (SELECT STUFF((SELECT DISTINCT ''',''' + CONVERT(VARCHAR(2),IdProfile) FROM TR_User_Profile WHERE IdUser = @IdUser AND Active = 'True' FOR XML PATH('')),1,2,'')) +''''

	IF OBJECT_ID ('tempdb..##Module') IS NOT NULL
		BEGIN
			DROP TABLE ##Module
		END

	SET @SQL = 'SELECT DISTINCT A.IdMenu AS IdModule, B.MenuURL AS URLSubI, C.MenuURL AS URLSubII, D.MenuURL AS URLSubIII, A.IdProfile, A.MenuName AS ModuleName, A.Level AS Level_Module, AA.MenuIconCode, A.OrderNumber, B.IdMenu AS IdSubModule_I, B.MenuName AS SubModule_I, B.Level AS Level_SubModule_I, C.IdMenu AS IdSubModule_II, C.MenuName AS SubModule_II, C.Level Level_SubModule_II, D.IdMenu AS IdSubModule_III, D.MenuName AS SubModule_III, D.Level AS Level_SubModule_III
		INTO ##Module
	FROM TB_Menu A
	LEFT JOIN TB_MenuIcon AA
		ON AA.IdMenuIcon = A.IdMenuIcon
			AND A.Active = ''True''
			AND A.Status = ''True''
	INNER JOIN TB_Menu B
		ON B.ParentIdMenu = A.IdMenu
			AND B.Active = ''True''
			AND B.Status = ''True''
	LEFT JOIN TB_Menu C
		ON C.ParentIdMenu = B.IdMenu
			AND C.Active = ''True''
			AND C.Status = ''True''
	LEFT JOIN TB_Menu D
		ON D.ParentIdMenu = C.IdMenu
			AND D.Active = ''True''
			AND D.Status = ''True''
	WHERE A.ParentIdMenu IS NULL AND A.Active= ''True''
	ORDER BY A.OrderNumber'
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 22/01/2024
-- Description: Se agrega condicion de que se muestren los menus activos solamente
-- =============================================
--Antes
--WHERE A.ParentIdMenu IS
--Ahora
--WHERE A.ParentIdMenu IS NULL AND A.Active= ''True''
-- =============================================
	EXEC (@SQL)

	--SELECT A.IdModule, A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.ToRead_SubModule_I, A.ToCreate_SubModule_I,  A.ToUpdate_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.ToRead_SubModule_II, A.ToCreate_SubModule_II, A.ToUpdate_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III, B.ToRead ToRead_SubModule_III, B.ToCreate ToCreate_SubModule_III, B.ToUpdate ToUpdate_SubModule_III
	--FROM (
	--	SELECT A.IdModule, A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.ToRead_SubModule_I, A.ToCreate_SubModule_I, A.ToUpdate_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, B.ToRead ToRead_SubModule_II, B.ToCreate ToCreate_SubModule_II, B.ToUpdate ToUpdate_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III
	--	FROM (
	--		SELECT  A.IdModule, A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, B.ToRead ToRead_SubModule_I, B.ToCreate ToCreate_SubModule_I, B.ToUpdate ToUpdate_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III
	--		FROM (
	--			SELECT A.IdModule, A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, B.ToRead ToRead_Module, B.ToCreate ToCreate_Module, B.ToUpdate ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III
	--			FROM ##Module A
	--			LEFT JOIN TR_User_Menu B
	--				ON B.IdMenu = A.IdModule
	--					AND B.IdUser = @IdUser
	--					AND Active = 'True'
	--			) A
	--		LEFT JOIN TR_User_Menu B
	--			ON B.IdMenu = A.IdSubModule_I
	--				AND B.IdUser = @IdUser
	--		) A
	--	LEFT JOIN TR_User_Menu B
	--		ON B.IdMenu = A.IdSubModule_II
	--			AND B.IdUser = @IdUser
	--	) A
	--LEFT JOIN TR_User_Menu B
	--	ON B.IdMenu = A.IdSubModule_III
	--		AND B.IdUser = @IdUser


	SELECT A.IdModule, A.URLSubI, A.URLSubII, A.URLSubIII, A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.ToRead_SubModule_I, A.ToCreate_SubModule_I,  A.ToUpdate_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.ToRead_SubModule_II, A.ToCreate_SubModule_II, A.ToUpdate_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III, B.ToRead ToRead_SubModule_III, B.ToCreate ToCreate_SubModule_III, B.ToUpdate ToUpdate_SubModule_III
	FROM (
		SELECT A.IdModule, A.URLSubI, A.URLSubII, A.URLSubIII,  A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.ToRead_SubModule_I, A.ToCreate_SubModule_I, A.ToUpdate_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, B.ToRead ToRead_SubModule_II, B.ToCreate ToCreate_SubModule_II, B.ToUpdate ToUpdate_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III
		FROM (
			SELECT  A.IdModule,A.URLSubI, A.URLSubII, A.URLSubIII, A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, B.ToRead ToRead_SubModule_I, B.ToCreate ToCreate_SubModule_I, B.ToUpdate ToUpdate_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III
			FROM (
				SELECT A.IdModule, A.URLSubI, A.URLSubII, A.URLSubIII, A.IdProfile, A.ModuleName, A.Level_Module, A.MenuIconCode, B.ToRead ToRead_Module, B.ToCreate ToCreate_Module, B.ToUpdate ToUpdate_Module, A.IdSubModule_I, A.SubModule_I, A.Level_SubModule_I, A.IdSubModule_II, A.SubModule_II, A.Level_SubModule_II, A.IdSubModule_III, A.SubModule_III, A.Level_SubModule_III
				FROM ##Module A
				LEFT JOIN TR_User_Menu B
					ON B.IdMenu = A.IdModule
						AND B.IdUser = @IdUser
						AND Active = 'True'
				) A
			LEFT JOIN TR_User_Menu B
				ON B.IdMenu = A.IdSubModule_I
					AND B.IdUser = @IdUser
			) A
		LEFT JOIN TR_User_Menu B
			ON B.IdMenu = A.IdSubModule_II
				AND B.IdUser = @IdUser
		) A
	LEFT JOIN TR_User_Menu B
		ON B.IdMenu = A.IdSubModule_III
			AND B.IdUser = @IdUser
-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 04/12/2023
-- Description: Se agrega SubModule_I al order by para dar solucion a incidente de asignacion de permisos a los usuarios
-- =============================================
--Antes
--ORDER BY ModuleName ASC
--Ahora
--ORDER BY ModuleName, SubModule_I ASC
-- =============================================
	ORDER BY ModuleName, SubModule_I ASC
END

GO
