SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 01/04/2022
-- Description: Procedimiento almacenado para listar zona de compañia.
-- =============================================
---EXEC [dbo].[sp_List_CompanyZone]
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_CommercialZone]
(
	@IdCity int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT A.IdCommercialZone, A.CommercialZoneName
	FROM TB_CommercialZone A
	INNER JOIN TR_CommercialZone_City B
		ON B.IdCommercialZone = A.IdCommercialZone
	WHERE B.IdCity = @IdCity

END
GO
