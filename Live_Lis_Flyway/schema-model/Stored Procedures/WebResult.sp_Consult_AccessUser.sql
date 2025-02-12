SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/10/2023
-- Description: Procedimiento almacenado para consultar usuarios con accesso al portal de resultados. 
-- =============================================
--EXEC [WebResult].[sp_Consult_AccessUser] '','','','','',''
-- =============================================
CREATE PROCEDURE [WebResult].[sp_Consult_AccessUser]
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdUser, A.UserName, A.IdRole, B.RoleName, CONCAT_WS(' ', C.IdentificationTypeCode, A.IdentificationNumber) AS Identification, CONCAT_WS(' ', A.Name, A.LastName) AS FullPatientName,
		MAX(D.ActionDate) AS LastAccess, A.AccessResultWeb AS Active
	FROM TB_User A
	INNER JOIN TB_Role B
		ON B.IdRole = A.IdRole
	INNER JOIN TB_IdentificationType C
		ON C.IdIdentificationType = A.IdIdentificationType
	LEFT JOIN History.TH_Binnacle D
		ON D.UserName = A.UserName
			AND D.Action = 'LogIn'
			AND D.AccessSystem = 'Web Resultados'
	WHERE AccessResultWeb IS NOT NULL
	GROUP BY A.IdUser, A.UserName, A.IdRole, B.RoleName, C.IdentificationTypeCode, A.IdentificationNumber, A.Name, A.LastName, A.AccessResultWeb
END
GO
