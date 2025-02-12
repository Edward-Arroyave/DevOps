SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/05/2022
-- Description: Procedimiento almacenado para barrios de acuerdo con una localidad.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Neighborhood]
(
	@IdLocality int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdNeighborhood, CONCAT(NeighborhoodCode,': ', Neighborhood) Neighborhood
	FROM TB_Neighborhood
	WHERE IdLocality = @IdLocality
END
GO
