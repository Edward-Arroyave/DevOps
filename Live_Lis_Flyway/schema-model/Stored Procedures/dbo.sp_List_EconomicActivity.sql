SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 08/11/2021
-- Description: Procedimiento almacenado para listar actividades economicas.
-- =============================================
---EXEC [dbo].[sp_List_EconomicActivity]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_EconomicActivity]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdEconomicActivity, EconomicActivityName
	FROM TB_EconomicActivity
	WHERE Active = 'True'

END
GO
