SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 16/03/2022
-- Description: Procedimiento almacenado para listar las profesiones.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Profession]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT IdProfession, ProfessionName
	FROM TB_Profession
END
GO
