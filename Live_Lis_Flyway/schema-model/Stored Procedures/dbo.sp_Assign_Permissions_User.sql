SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/12/2022
-- Description: Procedimiento almacenado para asociar los permisos de los roles asignados a un usuario.
-- =============================================
--EXEC [sp_Assign_Permissions_User] 4,2
-- =============================================
CREATE PROCEDURE [dbo].[sp_Assign_Permissions_User]
(
   @IdUser int,
   @IdUserAction int
)
AS
	 DECLARE @IdRole int
BEGIN
    SET NOCOUNT ON

	SET @IdRole = (SELECT IdRole FROM TB_User WHERE IdUser = @IdUser)

	MERGE TR_User_Menu AS TARGET
	USING
		(SELECT A.IdMenu, A.ToRead, A.ToCreate, A.ToUpdate, DATEADD(HOUR,-5,GETDATE()) Date, A.IdUserAction FROM TR_Role_Menu A INNER JOIN TB_Menu B ON B.IdMenu = A.IdMenu WHERE A.IdRole = @IdRole AND B.Active = 'True') SOURCE
	ON TARGET.IdUser = @IdUser
		AND TARGET.IdMenu = SOURCE.IdMenu
	WHEN NOT MATCHED BY TARGET
	THEN
		INSERT (IdUser, IdMenu, Active, ToRead, ToCreate, ToUpdate, CreationDate, IdUserAction)
		VALUES (
				@IdUser,
				SOURCE.IdMenu,
				1,
				SOURCE.ToRead,
				SOURCE.ToCreate,
				SOURCE.ToUpdate,
				SOURCE.Date,
				SOURCE.IdUserAction
				)
	WHEN MATCHED AND TARGET.IdUser = @IdUser
	THEN
		UPDATE
			SET TARGET.Active = 1,
				TARGET.ToRead = SOURCE.ToRead,
				TARGET.ToCreate = SOURCE.ToCreate,
				TARGET.ToUpdate = SOURCE.ToUpdate,
				TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
				TARGET.IdUserAction = @IdUserAction
	WHEN NOT MATCHED BY SOURCE AND TARGET.IdUser = @IdUser
	THEN
		UPDATE
			SET TARGET.Active = 0,
				TARGET.UpdateDate = DATEADD(HOUR,-5,GETDATE()),
				TARGET.IdUserAction = @IdUserAction;
END
GO
