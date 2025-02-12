SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 03/06/2022
-- Description: Procedimiento almacenado para retornar información	tipo de cortes para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_TypesOfCuts]
(
	@IdTypesOfCuts int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTypesOfCuts, Description
	FROM PTO.TB_TypesOfCuts
	WHERE IdTypesOfCuts = @IdTypesOfCuts
END
GO
