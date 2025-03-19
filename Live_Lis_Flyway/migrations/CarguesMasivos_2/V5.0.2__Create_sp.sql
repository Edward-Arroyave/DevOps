/****** Object:  StoredProcedure [dbo].[sp_LoadRolesAndPermissions]    Script Date: 11/03/2025 8:23:05 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_LoadRolesAndPermissions]
    @RolesAndPermissions LoadRolesAndPermissions READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @IdRole INT;

    DECLARE @TablePermissions TABLE (
        ProfileName VARCHAR(50),
        RoleName VARCHAR(50),
        AreaName VARCHAR(50),
        Module VARCHAR(50),
		[Permissions] VARCHAR(50),
        ViewPermissions BIT,
        EditPermissions BIT,
        CreatePermissions BIT
    );


    BEGIN TRY
        -- Extraer permisos en formato JSON y asegurarse de que ModulesPermission es válido
        WITH CTE_Split AS (
            SELECT 
                ProfileName,
                RoleName,
                AreaName,
                value AS ModuleJson
            FROM @RolesAndPermissions
            CROSS APPLY STRING_SPLIT(ModulesPermission, ';')
            WHERE LEN(value) > 0 -- Evitar valores vacíos
        ),
        CTE_Parse AS (
            SELECT
                ProfileName,
                RoleName,
                AreaName,
                JSON_VALUE(ModuleJson, '$.module') AS Module,
                JSON_VALUE(ModuleJson, '$.permissions') AS [Permissions],
                CAST(CASE WHEN JSON_VALUE(ModuleJson, '$.view') = 'SI' THEN 1 ELSE 0 END AS BIT) AS ViewPermissions,
                CAST(CASE WHEN JSON_VALUE(ModuleJson, '$.edit') = 'SI' THEN 1 ELSE 0 END AS BIT) AS EditPermissions,
                CAST(CASE WHEN JSON_VALUE(ModuleJson, '$.create') = 'SI' THEN 1 ELSE 0 END AS BIT) AS CreatePermissions
            FROM CTE_Split
            WHERE ISJSON(ModuleJson) = 1 -- Validar que sea JSON válido
        )
        INSERT INTO @TablePermissions
        SELECT * FROM CTE_Parse;

        -- Insertar roles en TB_Role si no existen
        INSERT INTO TB_Role (RoleName, IdUserAction, CreationDate)
        SELECT DISTINCT A.RoleName, @IdUser, @Date
        FROM @TablePermissions A
        LEFT JOIN TB_Role B ON A.RoleName = B.RoleName
        WHERE B.IdRole IS NULL 
              AND A.RoleName IS NOT NULL 
              AND A.RoleName <> '';

        -- Insertar permisos en TR_Role_Menu para Modules
        INSERT INTO TR_Role_Menu (IdRole, IdMenu, ToRead, ToUpdate, ToCreate, IdUserAction, CreationDate)
        SELECT 
            r.IdRole, 
            m.IdMenu, 
            ISNULL(tp.ViewPermissions, 0), 
            ISNULL(tp.EditPermissions, 0), 
            ISNULL(tp.CreatePermissions, 0),
			@IdUser,
			@Date
        FROM @TablePermissions tp
        INNER JOIN TB_Role r ON r.RoleName = tp.RoleName
        INNER JOIN TB_Menu m 
            ON m.MenuName = tp.Module 
            AND m.Active = 1 
            AND m.ParentIdMenu IS NULL;

        -- Insertar permisos en TR_Role_Menu para Menus
        INSERT INTO TR_Role_Menu (IdRole, IdMenu, ToRead, ToUpdate, ToCreate, IdUserAction, CreationDate)
        SELECT 
            r.IdRole, 
            m.IdMenu, 
            ISNULL(tp.ViewPermissions, 0), 
            ISNULL(tp.EditPermissions, 0), 
            ISNULL(tp.CreatePermissions, 0),
			@IdUser,
			@Date
        FROM @TablePermissions tp
        INNER JOIN TB_Role r ON r.RoleName = tp.RoleName
        INNER JOIN TB_Menu m 
            ON m.MenuName = tp.[Permissions] 
            AND m.Active = 1;

        -- Generar mensajes de salida
       SELECT 
            tp.RoleName, 
            tp.Module, 
            tp.[Permissions],
            CASE 
                WHEN r.IdRole IS NULL THEN 'Error: El rol no existe o no pudo ser insertado.'
                WHEN m.IdMenu IS NULL AND tp.Module IS NOT NULL THEN 'Error: El módulo no existe en TB_Menu o no está activo.'
                WHEN m.IdMenu IS NULL AND tp.[Permissions] IS NOT NULL THEN 'Error: El menú no existe en TB_Menu o no está activo.'
                ELSE 'Permiso asignado correctamente.'
            END
        FROM @TablePermissions tp
        LEFT JOIN TB_Role r ON r.RoleName = tp.RoleName
        LEFT JOIN TB_Menu m ON m.MenuName = isnull(tp.Module, tp.[Permissions]);

        -- Asignar mensaje de salida
        SET @Status = 1;
        SET @StatusMessage = 'Roles y Permisos procesados correctamente';

    END TRY
    BEGIN CATCH
        -- Capturar error y retornar mensaje
        SET @Status = -1;
        SET @StatusMessage = ERROR_MESSAGE();
    END CATCH;
END;
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadUser]    Script Date: 11/03/2025 8:23:17 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_LoadUser]
(
    @LoadUser LoadUser READONLY,
    @IdUserAction INT,
    @Message VARCHAR(MAX) OUT,
    @Flag BIT OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TableUser TABLE (
        IdUser INT,
        IdIdentificationType INT, 
        IdentificationNumber VARCHAR(50), 
        UserName VARCHAR(50)
    );

    -- Insertar nuevos usuarios evitando duplicados
    INSERT INTO TB_User (IdIdentificationType, IdentificationNumber, Name, LastName, BirthDate, Email, TelephoneNumber, IdRole, IdProfession, RegistrationNumber, CreationDate, IdUserAction, Active, Password, UserName, IdCountry, IdCity, PasswordExpires,AccountExpires, ExpirationDate)
    OUTPUT inserted.IdUser, inserted.IdIdentificationType, inserted.IdentificationNumber, inserted.UserName 
    INTO @TableUser
    SELECT DISTINCT 
        b.IdIdentificationType, 
        a.IdentificationNumber, 
        a.Name, 
        a.LastName, 
        a.BirthDate, 
        a.Email, 
        a.TelephoneNumber, 
        c.IdRole, 
        d.IdProfession,
        a.ProfessionalCardNumber,
        DATEADD(HOUR,-5,GETDATE()), 
        @IdUserAction, 
        1,
        a.Password,
        a.UserName,
        g.IdCountry,
        e.IdCity,
		0,
		0,
		null
    FROM @LoadUser a
    LEFT JOIN TB_User u 
        ON u.IdentificationNumber = a.IdentificationNumber AND u.UserName = a.UserName
    INNER JOIN TB_IdentificationType b 
        ON a.IdIdentificationType = b.IdentificationTypeDesc OR a.IdIdentificationType = b.IdentificationTypeCode
    INNER JOIN TB_Role c 
        ON c.RoleName = a.Role
    INNER JOIN TB_Profession d 
        ON d.ProfessionName = a.Profession
    LEFT JOIN TB_City e ON e.CityName = a.City
    LEFT JOIN TB_Department f ON f.DepartmentName = a.Estado
    LEFT JOIN TB_Country g ON g.CountryName = a.Country
    WHERE u.IdUser IS NULL;

    -- Insertar perfiles evitando duplicados
    INSERT INTO TR_User_Profile (IdProfile, IdUser, CreationDate, IdUserAction, Active)
    SELECT DISTINCT 
        e.IdProfile, 
        b.IdUser, 
        DATEADD(HOUR,-5,GETDATE()), 
        @IdUserAction, 
        1
    FROM @LoadUser a
    INNER JOIN @TableUser b 
        ON b.IdentificationNumber = a.IdentificationNumber AND b.UserName = a.UserName
    INNER JOIN TB_Profile e 
        ON e.ProfileName = a.ProfileType
    LEFT JOIN TR_User_Profile p 
        ON p.IdUser = b.IdUser AND p.IdProfile = e.IdProfile
    WHERE p.IdProfile IS NULL;

    -- Insertar centros de atención evitando duplicados
    IF EXISTS (SELECT 1 FROM @LoadUser WHERE AttentionCenter IS NOT NULL AND LEN(AttentionCenter) > 0)
    BEGIN
        DECLARE @TableAttentionCenter TABLE (
            IdUser INT,
            IdAttentionCenter INT
        );

        -- Extraer cada centro de atención y asociarlo al usuario
        INSERT INTO @TableAttentionCenter (IdUser, IdAttentionCenter)
        SELECT DISTINCT 
            u.IdUser, 
            ac.IdAttentionCenter
        FROM @LoadUser l
        INNER JOIN @TableUser u ON u.IdentificationNumber = l.IdentificationNumber AND u.UserName = l.UserName
        CROSS APPLY STRING_SPLIT(l.AttentionCenter, ';') AS SplitCenters
        INNER JOIN TB_AttentionCenter ac ON ac.AttentionCenterName = TRIM(SplitCenters.value)
        LEFT JOIN TR_User_AttentionCenter existing ON existing.IdUser = u.IdUser AND existing.IdAttentionCenter = ac.IdAttentionCenter
        WHERE existing.IdAttentionCenter IS NULL;

        -- Insertar los centros de atención procesados
        INSERT INTO TR_User_AttentionCenter (IdAttentionCenter, IdUser, CreationDate, Active)
        SELECT IdAttentionCenter, IdUser, DATEADD(HOUR,-5,GETDATE()), 1
        FROM @TableAttentionCenter;
    END;

    -- Mostrar errores por registro
    SELECT 
        a.*, 
        CASE 
            WHEN b.IdUser IS NOT NULL THEN 'El Usuario fue registrado correctamente.' 
            WHEN f.IdUser IS NOT NULL THEN 'El Usuario no se registró, debido a que ya existe.' 
            WHEN c.IdIdentificationType IS NULL THEN 'El tipo de identificación no existe'
            WHEN d.IdRole IS NULL THEN 'El Rol no existe'
            WHEN e.IdProfession IS NULL THEN 'La Profesión no existe'
        END AS [Message]
    FROM @LoadUser a
    LEFT JOIN @TableUser b 
        ON a.IdentificationNumber = b.IdentificationNumber AND a.UserName = b.UserName
    LEFT JOIN TB_User f 
        ON f.UserName = a.UserName AND a.IdentificationNumber = f.IdentificationNumber
    LEFT JOIN TB_IdentificationType c 
        ON a.IdIdentificationType = c.IdentificationTypeDesc OR a.IdIdentificationType = c.IdentificationTypeCode
    LEFT JOIN TB_Role d 
        ON d.RoleName = a.Role
    LEFT JOIN TB_Profession e 
        ON e.ProfessionName = a.Profession;

    -- Mensaje final de proceso
    SET @Message = 'Proceso finalizado';
    SET @Flag = 1;
END;
GO

/****** Object:  StoredProcedure [dbo].[sp_LoadContainer]    Script Date: 11/03/2025 8:23:30 a. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROCEDURE [dbo].[sp_LoadContainer]
    @Container LoadContainer READONLY,
    @IdUser INT,
    @Date DATETIME,
    @Status INT OUTPUT,
    @StatusMessage VARCHAR(MAX) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
		declare @InsertedContainer table (IdContainer int, ContainerName varchar(50))

        INSERT INTO TB_ContainerType(ContainerTypeName, Color, Active, CreationDate, IdUserAction)
		output inserted.IdContainerType, inserted.ContainerTypeName into @InsertedContainer
        SELECT A.ContainerName, A.Color, 1 AS Active, @Date, @IdUser
        FROM @Container A
        LEFT JOIN TB_ContainerType B
            ON A.ContainerName = B.ContainerTypeName
        WHERE B.IdContainerType IS NULL and A.ContainerName <> '' and A.Color <> '';
        
		select A.*,
		case 
			when B.IdContainer is not null then 'Registro ingresado.'
			when C.IdContainerType is not null then 'Error: El tipo de contenedor ya existe.'
			when A.ContainerName = '' then 'Error: El nombre de tipo de contenedor se encuentra vacio.'
			when A.Color = '' then 'Error: El color del tipo de contenedor se encuentra vacio.'
		end [Message]
		from @Container A 
		left join @InsertedContainer B on A.ContainerName = B.ContainerName
		left join TB_ContainerType C on C.ContainerTypeName = A.ContainerName

        SET @Status = 1;
        SET @StatusMessage = 'Los datos fueron procesados.';

END
GO

