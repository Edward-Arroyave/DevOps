SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para retornar información medio de fijación para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_FixingMedium]
(
	@IdFixingMedium int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdFixingMedium, Description
	FROM PTO.TB_FixingMedium
	WHERE IdFixingMedium = @IdFixingMedium
END
GO
