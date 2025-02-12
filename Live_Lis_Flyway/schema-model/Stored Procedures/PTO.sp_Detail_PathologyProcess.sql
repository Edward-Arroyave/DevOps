SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para retornar información proceso de patología para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_PathologyProcess]
(
	@IdPathologyProcess int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPathologyProcess, Description, TemplateFlag, WorksheetFlag, TrackingFlag, ProcessSequence
	FROM PTO.TB_PathologyProcess
	WHERE IdPathologyProcess = @IdPathologyProcess
END
GO
