SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 26/03/2022
-- Description: Procedimiento almacenado para consultar roles creados.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_Role]
AS
BEGIN

    SET NOCOUNT ON
/*	
    SELECT A.IdRole, A.RoleName, B.ProfileName, A.Active, A.CreationDate
	FROM TB_Role A
	INNER JOIN TB_Profile B
		ON B.IdProfile = A.IdProfile
		*/
		SELECT A.IdRole, A.RoleName, A.CreationDate, A.Active,
        STUFF((
	        SELECT '/' + ProfileName FROM TB_Profile F 
				LEFT JOIN TR_Role_Profile G 
					ON G.IdProfile = F.IdProfile
	        WHERE G.IdRole = A.IdRole
				AND G.Active = 1 AND F.Active = 1
	        FOR XML PATH(''),TYPE).value('.', 'NVARCHAR(MAX)'), 1,1,'') AS ProfileName
        FROM TB_Role A
		--	WHERE A.Active = 1 
			ORDER BY A.IdRole DESC
	

-- =============================================
-- Author:      César Orlando Jiménez Muñoz
-- Create Date: 22/01/2024
-- Description: Se ajusta procedimiento para unir los nombres de los perfiles en un solo registro cuando se seleccionan asi en la configuracion
-- =============================================
--Antes
--SELECT A.IdRole, A.RoleName, B.ProfileName, A.Active, A.CreationDate
--FROM TB_Role A
--INNER JOIN TB_Profile B ON B.IdProfile = A.IdProfile
--Ahora
--WITH UserRoles AS.......
-- =============================================
/*
WITH UserRoles AS (
                    SELECT
						R.IdRole,
                        U.UserName,
                        R.RoleName,
                        P.ProfileName,
						R.Active,
						R.CreationDate,
                        CONCAT_WS(' ', IT.IdentificationTypeCode, U.IdentificationNumber) AS Identification,
                        CONCAT_WS(' ', U.Name, U.LastName) AS Name,
                        U.IdUser,
                        U.SessionDate,
                        COUNT(U.IdUser) OVER (PARTITION BY U.IdUser) AS UserCount
                    FROM
                        TB_User U
                        INNER JOIN TR_User_Profile UP ON UP.IdUser = U.IdUser
                        INNER JOIN TR_Role_Profile R ON R.IdRole = U.IdRole
                        INNER JOIN TB_Profile P ON P.IdProfile = UP.IdProfile
                        INNER JOIN TB_IdentificationType IT ON IT.IdIdentificationType = U.IdIdentificationType
                    WHERE
                        UP.Active = 1 and
                        U.Active = 1
                )
                SELECT --distinct
					idrole,
                    RoleName,					                    
                    CASE
                        WHEN UserCount > 1 THEN 'Administrativo/Asistencial'
                        ELSE ProfileName
                    END AS ProfileName,
					Active,
					CreationDate/*
                    Identification,
                    Name,
                    IdUser,
					UserName,
                    SessionDate
					IdRole, RoleName, ProfileName, Active, CreationDate*/
                FROM
                    UserRoles
                WHERE
                    UserCount = 1 OR (UserCount > 1 AND ProfileName = 'Asistencial')

*/
END

GO
