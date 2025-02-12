SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 04/04/2022
-- Description: Procedimiento almacenado para listar esquemas tarifarios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_TariffScheme]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTariffScheme, CONCAT_WS(' - ', TariffSchemeCode, TariffSchemeName) AS TariffSchemeName
	FROM TB_TariffScheme
	WHERE Active = 'True'
END
GO
