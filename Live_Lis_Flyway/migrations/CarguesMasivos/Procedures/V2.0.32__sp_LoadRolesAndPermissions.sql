/****** Object:  StoredProcedure [dbo].[sp_LoadRolesAndPermissions]    Script Date: 19/02/2025 12:08:27 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_LoadRolesAndPermissions]
    @RolesAndPermissions LoadRolesAndPermissions READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Role VARCHAR(50),
    @Area VARCHAR(50),
    @Profile VARCHAR(50),
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    DECLARE @IdRole INT;
    
    BEGIN TRY
        -- Buscar el Id del Rol
        SELECT @IdRole = IdRole
        FROM TB_Role
        WHERE RoleName = @Role;
        
        -- Si no existe, insertarlo
        IF @IdRole IS NULL 
        BEGIN
            INSERT INTO TB_Role (RoleName, IdProfile, CreationDate, IdUserAction, ToggleAdmin)
            SELECT @Role, A.IdProfile, @Date, @IdUser, 0 ToggleAdmin
            FROM TB_Profile A
            WHERE A.ProfileName = @Profile;

            SET @IdRole = SCOPE_IDENTITY();
        END
        
        -- Insertar permisos del rol
        INSERT INTO TR_Role_Menu (IdRole, IdMenu, Active, ToRead, ToCreate, ToUpdate, CreationDate, IdUserAction)
        SELECT @IdRole, B.IdMenu, 1 Active, A.[View], A.[Create], A.Edit, @Date, @IdUser
        FROM @RolesAndPermissions A
        INNER JOIN TB_Menu B ON B.MenuName = A.Permissions
        LEFT JOIN TR_Role_Menu C ON C.IdMenu = B.IdMenu AND C.IdRole = @IdRole
        WHERE C.IdRole_Menu IS NOT NULL;
        
        IF @@ROWCOUNT <> 0
        BEGIN
            SET @Status = 1;
            SET @StatusMessage = 'Roles y permisos insertados correctamente.';
        END
        ELSE
        BEGIN
            SET @Status = 0;
            SET @StatusMessage = 'No se insertaron datos porque ya existen en la tabla.';

			SELECT @Role "Role", @Profile "Profile", @Area Area, A.* 
			FROM @RolesAndPermissions A
			INNER JOIN TB_Menu B ON B.MenuName = A.Permissions
			LEFT JOIN TR_Role_Menu C ON C.IdMenu = B.IdMenu AND C.IdRole = @IdRole
			WHERE C.IdRole_Menu IS NULL;

        END
    END TRY
    BEGIN CATCH
        -- Capturar error y retornar mensaje
        SET @Status = -1;
        SET @StatusMessage = ERROR_MESSAGE();
    END CATCH;
END
GO

