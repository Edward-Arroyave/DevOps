SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 30/03/2022
-- Description: Procedimiento almacenado para retornar las especialidades asociadas a un usuario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_User_ProfessionalSpeciality]
(
	@IdUser int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON

	IF EXISTS (SELECT IdUser FROM TR_User_ProfessionalSpeciality WHERE IdUser = @IdUser)
		BEGIN
			SELECT DISTINCT C.IdProfessionalSpeciality, C.ProfessionalSpecialityName
			FROM TR_User_ProfessionalSpeciality A
			INNER JOIN TB_User B
				ON B.IdUser = A.IdUser
			INNER JOIN TB_ProfessionalSpeciality C
				ON C.IdProfessionalSpeciality = A.IdProfessionalSpeciality
			WHERE A.IdUser = @IdUser
				AND A.Active = 'True'

			SET @Message = CONCAT('Profession speciality associated with the user ', @IdUser)
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'User has no associated professional specialities'
			SET @Flag = 0
		END
END
GO
