/****** Object:  StoredProcedure [dbo].[sp_LoadUser]    Script Date: 19/02/2025 12:09:04 p. m. ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:      Marlly Merchan
-- Create Date: 03/02/2025
-- Description: Procedimiento almacenado para cargue masivo de usuarios.
-- =============================================
/*
DECLARE @LoadUser LoadUser, @Message varchar(50), @Flag bit
INSERT INTO @LoadUser (Name, LastName, IdIdentificationType,IdentificationNumber,BirthDate, Email, TelephoneNumber, ProfileType, Role, Title, Profession, ProfessionalCardNumber, AttentionCenter)
VALUES 
('Juan','Diaz','CC', '21221','1986-11-02','juana.d@prueba.com','321555522','Administrativo','Prueba','Aux Enfermeria', 'Enfermeria','RP1233','Sede vip')

EXEC [sp_LoadUser] @LoadUser,2,@Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_LoadUser]
(
    @LoadUser LoadUser READONLY,
    @IdUserAction INT,
    @Message VARCHAR(50) OUT,
    @Flag BIT OUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Insertar nuevos usuarios evitando duplicados
    INSERT INTO TB_User (IdIdentificationType, IdentificationNumber, Name, LastName, BirthDate, Email, TelephoneNumber, IdRole, IdProfession, RegistrationNumber, CreationDate, IdUserAction, Active, Password)
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
		'123456789'
    FROM @LoadUser a
    LEFT JOIN TB_User u 
        ON u.IdentificationNumber = a.IdentificationNumber -- Cambio para hacer la validación por identificación, no nombre
    INNER JOIN TB_IdentificationType b 
        ON a.IdIdentificationType = b.IdentificationTypeDesc OR a.IdIdentificationType = b.IdentificationTypeCode
    INNER JOIN TB_Role c 
        ON c.RoleName = a.Role
    INNER JOIN TB_Profession d 
        ON d.ProfessionName = a.Profession
    WHERE u.IdUser IS NULL

    -- Insertar perfiles evitando duplicados
    INSERT INTO TR_User_Profile (IdProfile, IdUser, CreationDate, IdUserAction, Active)
    SELECT DISTINCT 
        e.IdProfile, 
        g.IdUser, 
        DATEADD(HOUR,-5,GETDATE()), 
        @IdUserAction, 
        1
    FROM @LoadUser a
    INNER JOIN TB_Profile e 
        ON e.ProfileName = a.ProfileType
    INNER JOIN TB_User g 
        ON g.IdentificationNumber = a.IdentificationNumber
    LEFT JOIN TR_User_Profile p 
        ON p.IdUser = g.IdUser AND p.IdProfile = e.IdProfile
    WHERE p.IdProfile IS NULL

    -- Insertar centros de atención evitando duplicados
    INSERT INTO TR_User_AttentionCenter (IdAttentionCenter, IdUser, CreationDate, Active)
    SELECT DISTINCT 
        b.IdAttentionCenter, 
        g.IdUser, 
        DATEADD(HOUR,-5,GETDATE()), 
        1
    FROM @LoadUser a
    INNER JOIN TB_AttentionCenter b 
        ON b.AttentionCenterName = a.AttentionCenter
    INNER JOIN TB_User g 
        ON g.IdentificationNumber = a.IdentificationNumber
    LEFT JOIN TR_User_AttentionCenter ac 
        ON ac.IdUser = g.IdUser AND ac.IdAttentionCenter = b.IdAttentionCenter
    WHERE ac.IdAttentionCenter IS NULL

	
    IF @@ROWCOUNT > 0
    BEGIN
        SET @Flag = 1;
        SET @Message = 'Usuario cargado con éxito.';
    END
    ELSE
    BEGIN
        SET @Flag = 0;
        SET @Message = 'Información ya existente, no se realiza cargue.';
    END;
	
	----Usuario --
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
		'123456789'
    FROM @LoadUser a
    LEFT JOIN TB_User u 
        ON u.IdentificationNumber = a.IdentificationNumber
    INNER JOIN TB_IdentificationType b 
        ON a.IdIdentificationType = b.IdentificationTypeDesc OR a.IdIdentificationType = b.IdentificationTypeCode
    INNER JOIN TB_Role c 
        ON c.RoleName = a.Role
    INNER JOIN TB_Profession d 
        ON d.ProfessionName = a.Profession
     
	------ Perfil --
    SELECT DISTINCT 
        e.IdProfile, 
        g.IdUser, 
        DATEADD(HOUR,-5,GETDATE()), 
        @IdUserAction, 
        1
    FROM @LoadUser a
    INNER JOIN TB_Profile e 
        ON e.ProfileName = a.ProfileType
    INNER JOIN TB_User g 
        ON g.IdentificationNumber = a.IdentificationNumber
    LEFT JOIN TR_User_Profile p 
        ON p.IdUser = g.IdUser AND p.IdProfile = e.IdProfile

    ------ Centro de atención ---
	SELECT DISTINCT 
        b.IdAttentionCenter, 
        g.IdUser, 
        DATEADD(HOUR,-5,GETDATE()), 
        1
    FROM @LoadUser a
    INNER JOIN TB_AttentionCenter b 
        ON b.AttentionCenterName = a.AttentionCenter
    INNER JOIN TB_User g 
        ON g.IdentificationNumber = a.IdentificationNumber
    LEFT JOIN TR_User_AttentionCenter ac 
        ON ac.IdUser = g.IdUser AND ac.IdAttentionCenter = b.IdAttentionCenter
END;
GO

