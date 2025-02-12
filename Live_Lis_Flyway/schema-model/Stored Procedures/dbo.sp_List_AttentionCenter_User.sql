SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 10/09/2021
-- Description: Procedimiento almacenado para listar las sedes asociadas a un usuario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_AttentionCenter_User]
(
    @UserName varchar(50),
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	
	IF EXISTS (SELECT A.IdUser FROM TR_User_AttentionCenter A INNER JOIN TB_User B ON A.IdUser = B.IdUser WHERE B.UserName = @UserName)
		BEGIN
			SELECT DISTINCT B.IdAttentionCenter, B.AttentionCenterCode, B.AttentionCenterName
			FROM TR_User_AttentionCenter A
			INNER JOIN TB_AttentionCenter B
				ON A.IdAttentionCenter = B.IdAttentionCenter
			INNER JOIN TB_User C
				ON A.IdUser = C.IdUser
			WHERE C.UserName = @UserName
				AND B.Active = 'True'
				AND A.Active = 'True'

			SET @Message = CONCAT('AttentionCenter associated with the user ',@UserName) 
			SET @Flag = 1
		END
	ELSE
		BEGIN
			SET @Message = 'User has no associated AttentionCenter'
			SET @Flag = 0
		END
END
GO
