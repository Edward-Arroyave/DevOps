SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 14/06/2022
-- Description: Procedimiento almacenado para retornar detalle de fracciones de corte.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_BlockFractions]
(
	@IdBlockFractions int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdBlockFractions, IdPatient_Exam, BlockName
	FROM PTO.TB_BlockFractions
	WHERE IdBlockFractions = @IdBlockFractions
END
GO
