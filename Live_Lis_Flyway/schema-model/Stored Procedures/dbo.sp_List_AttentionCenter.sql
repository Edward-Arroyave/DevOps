SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar centros de atención.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_AttentionCenter]
--(
--	@Keyword varchar(20)
--)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdAttentionCenter, AttentionCenterName
	FROM TB_AttentionCenter
	--WHERE AttentionCenterName LIKE '%'+@Keyword+'%'
	--	AND Active = 'True'
END
GO
