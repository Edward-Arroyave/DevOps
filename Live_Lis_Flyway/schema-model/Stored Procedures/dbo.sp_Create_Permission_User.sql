SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 13/09/2021
-- Description: Procedimiento almacenado para asignar o actualizar permisos de un usuario.
-- =============================================
--DECLARE @Permission User_Menu
--INSERT INTO @Permission (IdUser, IdMenu, ToRead, ToCreate, ToUpdate, IdUserAction)
--VALUES (1012, 1,1,1,1,44),(1012, 2,1,1,1,44)
--EXEC [sp_Create_Permission_User] @Permission
-- =============================================
CREATE PROCEDURE [dbo].[sp_Create_Permission_User]
(
	@Permission User_Menu READONLY
)
AS
BEGIN
    SET NOCOUNT ON

	MERGE TR_User_Menu AS TARGET
	USING
		(SELECT IdUser, IdMenu, ToRead, ToCreate, ToUpdate, DATEADD(HOUR,-5,GETDATE()) Date, IdUserAction FROM @Permission) SOURCE
	ON TARGET.IdUser = SOURCE.IdUser
		AND TARGET.IdMenu = SOURCE.IdMenu
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdUser, IdMenu, Active, ToRead, ToCreate, ToUpdate, CreationDate, IdUserAction)
		VALUES (
				SOURCE.IdUser,
				SOURCE.IdMenu,
				1,
				SOURCE.ToRead,
				SOURCE.ToCreate,
				SOURCE.ToUpdate,
				SOURCE.Date,
				SOURCE.IdUserAction
				)
	WHEN MATCHED AND TARGET.IdUser = (SELECT TOP 1 IdUser FROM @Permission)
	THEN
		UPDATE
			SET TARGET.Active = 1,
				TARGET.ToRead = SOURCE.ToRead,
				TARGET.ToCreate = SOURCE.ToCreate,
				TARGET.ToUpdate = SOURCE.ToUpdate,
				TARGET.UpdateDate = SOURCE.Date,
				TARGET.IdUserAction = SOURCE.IdUserAction;
END

GO
