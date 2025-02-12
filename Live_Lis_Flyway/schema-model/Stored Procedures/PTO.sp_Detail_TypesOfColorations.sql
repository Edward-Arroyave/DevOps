SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/06/2022
-- Description: Procedimiento almacenado para retornar información	tipo de coloración para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_TypesOfColorations]
(
	@IdTypesOfColorations int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTypesOfColorations, Description
	FROM PTO.TB_TypesOfColorations
	WHERE IdTypesOfColorations = @IdTypesOfColorations
END
GO
