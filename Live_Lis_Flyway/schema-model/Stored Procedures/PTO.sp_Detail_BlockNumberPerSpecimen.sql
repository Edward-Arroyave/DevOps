SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 06/07/2022
-- Description: Procedimiento almacenado para retornar detalle de número de bloque por muestra.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_BlockNumberPerSpecimen]
(
	@IdBlockNumberPerSpecimen int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdBlockNumberPerSpecimen, IdBodyPart, BlockName
	FROM PTO.TB_BlockNumberPerSpecimen
	WHERE IdBlockNumberPerSpecimen = @IdBlockNumberPerSpecimen
END
GO
