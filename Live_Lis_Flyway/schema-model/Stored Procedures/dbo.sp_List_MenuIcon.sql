SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/05/2022
-- Description: Procedimiento almacenado para listar los Iconos para menú.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_MenuIcon]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdMenuIcon, MenuIconCode, MenuIconName
	FROM TB_MenuIcon
END
GO
