SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/03/2022
-- Description: Procedimiento almacenado para consultar los usuarios creados.
-- =============================================
--EXEC [sp_Consult_User] 1
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_User]
(
	@CompanyUser bit
)
AS
BEGIN
    SET NOCOUNT ON
		
	IF @CompanyUser = 0
		BEGIN
			SELECT A.IdUser, CONCAT_WS(' ', A.Name, A.LastName) FullName,  A.UserName, B.ProfessionName, EncryptedUser, A.PhotoNameContainer AS PhotoCode, A.SignatureNameContainer AS SignatureCode, A.SessionDate, A.Active, A.PhotoNameContainer, A.SignatureNameContainer
			FROM TB_User A
			LEFT JOIN TB_Profession B
				ON B.IdProfession = A.IdProfession
			WHERE A.CompanyUser = 'False'
		END
	ELSE IF @CompanyUser = 1 
		BEGIN
			SELECT A.IdUser, A.UserName, A.Email, A.IdCompany, B.CompanyName, 
				STUFF((SELECT DISTINCT ', ', + CONVERT(varchar(20),D.ContractCode) 
						FROM TR_User_Contract C
						INNER JOIN TB_Contract D
							ON D.IdContract = C.IdContract
						WHERE C.IdUser = A.IdUser
							AND C.Active = 'True'
						FOR XML PATH ('')
						),1,1,'') Contracts,
				A.Active
			FROM TB_User A
			INNER JOIN TB_Company B
				ON B.IdCompany = A.IdCompany
			WHERE A.CompanyUser = 'True'
				AND A.Removed = 'False'
		END
END
GO
