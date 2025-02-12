SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 13/09/2021
-- Description: Procedimiento almacenado para asignar o actualizar permisos de un usuario.
-- =============================================
--DECLARE @Permission Role_Menu
--INSERT INTO @Permission (IdRole, IdMenu, ToRead, ToCreate, ToUpdate, IdUserAction)
--VALUES (23,5,1,1,1,4), (23,5,1,1,0,4)
--EXEC [sp_Create_Permission_Role] @Permission
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Permission_Role]
(
	@Permission Role_Menu READONLY
)
AS
BEGIN
    SET NOCOUNT ON

	MERGE TR_Role_Menu AS TARGET
	USING
		(SELECT DISTINCT IdRole, IdMenu, ToRead, ToCreate, ToUpdate, DATEADD(HOUR,-5,GETDATE()) Date, IdUserAction FROM @Permission) SOURCE
	ON TARGET.IdRole = SOURCE.IdRole
		AND TARGET.IdMenu = SOURCE.IdMenu
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdRole, IdMenu, Active, ToRead, ToCreate, ToUpdate, CreationDate, IdUserAction)
		VALUES (
				SOURCE.IdRole,
				SOURCE.IdMenu,
				1,
				SOURCE.ToRead,
				SOURCE.ToCreate,
				SOURCE.ToUpdate,
				SOURCE.Date,
				SOURCE.IdUserAction
				)
	WHEN MATCHED AND TARGET.IdRole = (SELECT TOP 1 IdRole FROM @Permission)
	THEN
		UPDATE
			SET TARGET.Active = 1,
				TARGET.ToRead = SOURCE.ToRead,
				TARGET.ToCreate = SOURCE.ToCreate,
				TARGET.ToUpdate = SOURCE.ToUpdate,
				TARGET.UpdateDate = SOURCE.Date,
				TARGET.IdUserAction =  SOURCE.IdUserAction;
END
GO
