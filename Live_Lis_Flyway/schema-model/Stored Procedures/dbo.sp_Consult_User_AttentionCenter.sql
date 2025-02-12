SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/03/2022
-- Description: Procedimiento almacenado para listar todas los centros de atención y los que estan asociados a un usuario.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_User_AttentionCenter]
(
	@IdUser int,
	@Message varchar(50) out,
	@Flag bit out
)
AS
BEGIN
    SET NOCOUNT ON
	BEGIN
		SELECT DISTINCT A.IdAttentionCenter, A.AttentionCenterName, ISNULL(B.Active,'False') Active
		FROM (
			SELECT IdAttentionCenter, AttentionCenterName
			FROM TB_AttentionCenter 
			WHERE Active = 'True' ) A
		LEFT JOIN TR_User_AttentionCenter B
			ON B.IdAttentionCenter = A.IdAttentionCenter
				AND B.IdUser = @IdUser
				AND B.Active = 'True'

		SET @Message = CONCAT('Attention center associated with the user ', @IdUser)
		SET @Flag = 1
	END
END
GO
