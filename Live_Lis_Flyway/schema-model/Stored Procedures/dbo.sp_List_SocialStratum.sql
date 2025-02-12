SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/05/2022
-- Description: Procedimiento almacenado para listar estrato.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_SocialStratum]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdSocialStratum, SocialStratum
	FROM TB_SocialStratum
END
GO
