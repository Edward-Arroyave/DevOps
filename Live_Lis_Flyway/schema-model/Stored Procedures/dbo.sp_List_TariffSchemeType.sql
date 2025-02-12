SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 05/04/2022
-- Description: Procedimiento almacenado para listar esquemas tarifarios.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_TariffSchemeType]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTariffSchemeType, TariffSchemeTypeName
	FROM TB_TariffSchemeType
	WHERE Active = 'True'
END
GO
