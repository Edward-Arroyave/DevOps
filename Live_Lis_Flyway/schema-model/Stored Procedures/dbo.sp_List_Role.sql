SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar roles.
-- =============================================
-- EXEC [dbo].[sp_List_Role] 'ed'
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Role]
--(
--	@Keyword varchar(20)
--)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdRole, RoleName
	FROM TB_Role
	--WHERE RoleName LIKE '%'+@Keyword+'%'
	--	AND Active = 'True'
END
GO
