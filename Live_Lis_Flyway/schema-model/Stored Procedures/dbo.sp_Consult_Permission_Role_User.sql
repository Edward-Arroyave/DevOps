SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/03/2022
-- Description: Procedimiento almacenado para cargar los módulos y submódulos asignados a un usuario por rol y usuario.
-- =============================================
-- EXEC [sp_Consult_Permission_Role_User] 'juan'
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Permission_Role_User]
(
	@UserName varchar(50)
) 
AS
	DECLARE @IdUser int
BEGIN
    SET NOCOUNT ON
	
	SET @IdUser = (SELECT IdUser FROM TB_User WHERE UserName = @UserName)

	IF OBJECT_ID ('tempdb..##Permission') IS NOT NULL
		BEGIN
			DROP TABLE ##Permission
		END

	SELECT A.IdMenu, CONCAT_WS('#', A.IdMenu, A.Level) MenuCode, A.MenuName, A.ParentIdMenu, A.Level, A.OrderNumber, C.MenuIconCode AS MenuIcon, A.MenuURL, A.Active, A.Status, 
	ISNULL(B.IdUser, (SELECT @IdUser)) IdUser, ISNULL(B.ToRead,0) ToRead, ISNULL(B.ToCreate,0) ToCreate, ISNULL(B.ToUpdate,0) ToUpdate
		INTO ##Permission
	FROM TB_Menu A
	LEFT JOIN TR_User_Menu B
		ON B.IdMenu = A.IdMenu
			AND B.IdUser = @IdUser
			AND B.Active = 'True'
	LEFT JOIN TB_MenuIcon C
		ON C.IdMenuIcon = A.IdMenuIcon
	WHERE A.Status = 'True'
		AND A.Active = 'True'

	IF OBJECT_ID ('tempdb..##Permission_Module') IS NOT NULL
		BEGIN
			DROP TABLE ##Permission_Module
		END

	SELECT A.IdModule, A.Module_Code, A.ModuleName, A.Level_Module, A.OrderNumber_Module, ModuleIcon, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module,
		A.IdSubModule_I, SubModule_ICode, A.SubModule_I, A.Level_SubModule_I, A.OrderNumber_SubModule_I, SubModule_I_URL, A.ToRead_SubModule_I, A.ToCreate_SubModule_I, A.ToUpdate_SubModule_I,
		A.IdSubModule_II, SubModule_IICode, A.SubModule_II, A.Level_SubModule_II, A.OrderNumber_SubModule_II, SubModule_II_URL, A.ToRead_SubModule_II, A.ToCreate_SubModule_II, A.ToUpdate_SubModule_II,
		B.IdMenu AS IdSubModule_III, B.MenuCode SubModule_IIICode, B.MenuName AS SubModule_III, B.Level AS Level_SubModule_III, B.OrderNumber OrderNumber_SubModule_III, B.MenuURL AS SubModule_III_URL, B.ToRead AS ToRead_SubModule_III, B.ToCreate AS ToCreate_SubModule_III, B.ToUpdate AS ToUpdate_SubModule_III
		INTO ##Permission_Module
	FROM (
		SELECT DISTINCT A.IdModule, A.Module_Code, A.ModuleName, A.Level_Module, A.OrderNumber_Module, A.ModuleIcon, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module,
			A.IdSubModule_I, SubModule_ICode, A.SubModule_I, A.Level_SubModule_I, A.OrderNumber_SubModule_I, A.SubModule_I_URL, A.ToRead_SubModule_I, A.ToCreate_SubModule_I, A.ToUpdate_SubModule_I,
			B.IdMenu AS IdSubModule_II, B.MenuCode SubModule_IICode, B.MenuName AS SubModule_II, B.Level AS Level_SubModule_II, B.OrderNumber OrderNumber_SubModule_II, B.MenuURL AS SubModule_II_URL, B.ToRead AS ToRead_SubModule_II, B.ToCreate AS ToCreate_SubModule_II, B.ToUpdate AS ToUpdate_SubModule_II
		FROM (
			SELECT A.IdModule, A.Module_Code, A.ModuleName, A.Level_Module, A.OrderNumber_Module, A.ModuleIcon, A.ToRead_Module, A.ToCreate_Module, A.ToUpdate_Module,
				B.IdMenu AS IdSubModule_I, B.MenuCode SubModule_ICode, B.MenuName AS SubModule_I, B.Level AS Level_SubModule_I, B.OrderNumber OrderNumber_SubModule_I, B.MenuURL AS SubModule_I_URL, B.ToRead AS ToRead_SubModule_I, B.ToCreate AS ToCreate_SubModule_I, B.ToUpdate AS ToUpdate_SubModule_I
			FROM (
				SELECT A.IdMenu AS IdModule, A.MenuCode Module_Code, A.MenuName AS ModuleName, Level AS Level_Module, OrderNumber AS OrderNumber_Module , MenuIcon AS ModuleIcon, A.ToRead AS ToRead_Module, A.ToCreate AS ToCreate_Module, A.ToUpdate AS ToUpdate_Module 
				FROM ##Permission A
				WHERE A.Active = 'True'
					AND A.ParentIdMenu IS NULL
				) A
			LEFT JOIN ##Permission B
				ON B.ParentIdMenu = A.IdModule
					AND B.Level = 2
			WHERE B.Active ='True'
			) A
		LEFT JOIN ##Permission B
			ON B.ParentIdMenu = A.IdSubModule_I
				AND B.Active ='True'
		) A
	LEFT JOIN ##Permission B
		ON B.ParentIdMenu = A.IdSubModule_II
	ORDER BY 1 ASC

	SELECT IdModule, Module_Code, ModuleName, Level_Module, OrderNumber_Module, ModuleIcon, ToRead_Module, ToCreate_Module, ToUpdate_Module,
		IdSubModule_I, SubModule_ICode, SubModule_I, Level_SubModule_I, OrderNumber_SubModule_I, SubModule_I_URL, ToRead_SubModule_I, ToCreate_SubModule_I, ToUpdate_SubModule_I,
		IdSubModule_II, SubModule_IICode, SubModule_II, Level_SubModule_II, OrderNumber_SubModule_II, SubModule_II_URL, ToRead_SubModule_II, ToCreate_SubModule_II, ToUpdate_SubModule_II,
		IdSubModule_III, SubModule_IIICode, SubModule_III, Level_SubModule_III, OrderNumber_SubModule_III, SubModule_III_URL, ToRead_SubModule_III, ToCreate_SubModule_III, ToUpdate_SubModule_III
	FROM ##Permission_Module
	ORDER BY OrderNumber_Module, IdModule, OrderNumber_SubModule_I, IdSubModule_I, OrderNumber_SubModule_II, IdSubModule_II, OrderNumber_SubModule_III, IdSubModule_III

END
GO
