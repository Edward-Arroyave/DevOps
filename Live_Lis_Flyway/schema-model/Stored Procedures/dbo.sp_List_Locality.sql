SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/05/2022
-- Description: Procedimiento almacenado para localidades de acuerdo con la ciudad.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Locality]
(
	@IdCity int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdLocality, CONCAT(LocalityCode, ': ', Locality) Locality
	FROM TB_Locality
	WHERE IdCity = @IdCity
END
GO
