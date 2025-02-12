SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 31/05/2022
-- Description: Procedimiento almacenado para retornar información clasificación de patología para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_PathologyClassification]
(
	@IdPathologyClassification int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPathologyClassification, Description
	FROM PTO.TB_PathologyClassification
	WHERE IdPathologyClassification = @IdPathologyClassification
END
GO
