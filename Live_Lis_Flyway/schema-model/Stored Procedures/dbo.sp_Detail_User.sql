SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 24/09/2021
-- Description: Procedimiento almacenado para listar los datos de un usuario creado.
-- =============================================
/*
DECLARE @Message varchar(50), @Flag bit 
EXEC [sp_Detail_User] 1,1057, @Message out, @Flag out
SELECT @Message, @Flag
*/
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_User]
(
	@CompanyUser bit,
	@IdUser int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF @CompanyUser = 0
		BEGIN
			IF EXISTS (SELECT IdUser FROM TB_User WHERE IdUser = @IdUser)
				BEGIN
					SELECT DISTINCT A.IdUser, A.IdIdentificationType, A.IdentificationNumber, A.Name, A.LastName, 
						STUFF((SELECT DISTINCT ',', + CONVERT(varchar(5),P.IdProfile) 
						FROM TR_User_Profile P
						WHERE P.IdUser = A.IdUser
							AND P.Active = 'True'
						FOR XML PATH ('')
						),1,1,'') Profile, 
						A.BirthDate, ISNULL(A.IdCountry, G.IdCountry) IdCountry, F.IdDepartment, A.IdCity, A.TelephoneNumber, A.Email, A.IdRole, I.RoleName, 
						A.UserName, A.UserNameAlternative, A.PasswordExpires, A.IdPasswdRenewalPeriod, A.PasswordExpirationDate, A.AccountExpires, A.ExpirationDate, 
						A.RegistrationNumber, A.IdProfession, A.IdEntailmentType, A.PhotoNameContainer, A.SignatureNameContainer , A.IdInstitution
					FROM TB_User A
					INNER JOIN TB_Role I
						ON I.IdRole = A.IdRole
					LEFT JOIN TB_City C
						ON C.IdCity = A.IdCity
					LEFT JOIN TB_Department F
						ON F.IdDepartment = C.IdDepartment
					LEFT JOIN TB_Country G
						ON G.IdCountry = F.IdCountry
					LEFT JOIN TB_Country H
						ON H.IdCountry = A.IdCountry
					LEFT JOIN TB_Profession E
						ON E.IdProfession = A.IdProfession
					WHERE A.IdUser = @IdUser
						AND A.CompanyUser = 0

					SET @Message = 'User found'
					SET @Flag = 1
				END
			ELSE
				BEGIN
					SET @Message = 'User does not exists'
					SET @Flag = 0
				END
		END
	ELSE
		BEGIN
			SELECT IdUser, IdIdentificationType, IdentificationNumber, Name, LastName, Email, TelephoneNumber, IdCompany,
				STUFF((SELECT DISTINCT ',', + CONVERT(varchar(5),P.IdContract) 
						FROM TR_User_Contract P
						WHERE P.IdUser = A.IdUser
							AND P.Active = 'True'
						FOR XML PATH ('')
						),1,1,'') Contract
						, A.IdInstitution
			FROM TB_User A
			WHERE A.IdUser = @IdUser
				AND A.CompanyUser = 1
				AND A.Removed = 'False'

			SELECT B.IdContract, C.ContractCode, C.ContractName, B.WaitingResult, B.PartialResult, B.FinishedResult, A.IdInstitution
			FROM TB_User A
			INNER JOIN TR_User_Contract B
				ON B.IdUser = A.IdUser
			INNER JOIN TB_Contract C
				ON C.IdContract = B.IdContract
			WHERE A.IdUser = @IdUser
				AND A.CompanyUser = 1
				AND A.Removed = 'False'
				AND B.Active = 'True'

			SET @Message = 'User found'
			SET @Flag = 1
		END
END
GO
