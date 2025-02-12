SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 15/06/2022
-- Description: Procedimiento almacenado para retornar detalle de fracciones de lamina.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_LeafFractions]
(
	@IdLeafFractions int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdLeafFractions, IdBlockFractions, IdPatient_Exam, LeafName
	FROM PTO.TB_LeafFractions
	WHERE IdLeafFractions = @IdLeafFractions
END
GO
