SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/06/2022
-- Description: Procedimiento almacenado para consutar clasificación patologica.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_PathologyClassification]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdPathologyClassification, Description, Active 
	FROM PTO.TB_PathologyClassification

END
GO
