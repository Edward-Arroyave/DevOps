SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/04/2022
-- Description: Procedimiento almacenado para consultar los esquemas tarifarios creados.
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_TariffScheme]
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT A.IdTariffScheme, A.TariffSchemeCode, A.TariffSchemeName, B.TariffSchemeTypeName, A.Active
	FROM TB_TariffScheme A
	INNER JOIN TB_TariffSchemeType B
		ON B.IdTariffSchemeType = A.IdTariffSchemeType

END
GO
