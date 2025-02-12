SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Poala Tellez Gonzalez
-- Create Date: 25/07/2023
-- Description: Procedimiento almacenado para crear/actualizar zona para cliente.
-- =============================================
--EXEC [sp_Detail_CommercialZone] 7
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_CommercialZone]
(
	@IdCommercialZone int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdCommercialZone, CommercialZoneCode, CommercialZoneName, 
		STUFF((
				SELECT ',' + CONVERT(varchar(5),B.IdCity)
				FROM TR_CommercialZone_City B
				WHERE B.IdCommercialZone = A.IdCommercialZone
					AND B.Active = 'True'
				FOR XML PATH('')),1,1,'') IdCity,
		STUFF((
				SELECT ', ' + CONVERT(varchar(5),B.IdCity), ' - ', CONVERT(varchar(30),C.CityName)
				FROM TR_CommercialZone_City B
				INNER JOIN TB_City C
					ON C.IdCity = B.IdCity
				WHERE B.IdCommercialZone = A.IdCommercialZone
					AND B.Active = 'True'
				FOR XML PATH('')),1,1,'') City
	FROM TB_CommercialZone A
	WHERE A.IdCommercialZone = @IdCommercialZone
END
GO
