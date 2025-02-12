SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/06/2022
-- Description: Procedimiento almacenado para consutar procesos patologicos.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_PathologyProcess]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPathologyProcess, Description, TemplateFlag, WorksheetFlag, TrackingFlag, ProcessSequence, Active 
	FROM PTO.TB_PathologyProcess

END
GO
