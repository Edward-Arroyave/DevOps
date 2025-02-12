SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Poala Tellez Gonzalez
-- Create Date: 25/07/2023
-- Description: Procedimiento almacenado para consultar zonas comerciales.
-- =============================================
--EXEC [sp_Consult_CommercialZone]
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_CommercialZone]
AS
BEGIN
    SET NOCOUNT ON

	SELECT DISTINCT A.IdCommercialZone, A.CommercialZoneCode, A.CommercialZoneName, A.Active, 
		CASE WHEN B.IdCommercialZone IS NOT NULL THEN 1 ELSE 0 END AS PartnerCities
	FROM TB_CommercialZone A
	LEFT JOIN TR_CommercialZone_City B
		ON B.IdCommercialZone = A.IdCommercialZone
END
GO
