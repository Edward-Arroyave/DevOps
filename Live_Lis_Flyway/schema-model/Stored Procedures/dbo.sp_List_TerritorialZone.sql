SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para listar zona territorial.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_TerritorialZone]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTerritorialZone, CONCAT(TerritorialZoneCode,': ', TerritorialZone) TerritorialZone
	FROM TB_TerritorialZone

END
GO
