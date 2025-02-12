SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar los perfiles.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Profile]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdProfile, ProfileName 
	FROM TB_Profile
	WHERE Active = 'True'
END
GO
