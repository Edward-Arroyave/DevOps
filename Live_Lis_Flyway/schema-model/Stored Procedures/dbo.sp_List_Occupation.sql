SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para listar ocupaciones.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Occupation]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdOccupation, OccupationCode, Occupation
	FROM TB_Occupation
	WHERE Active = 'True'
END
GO
