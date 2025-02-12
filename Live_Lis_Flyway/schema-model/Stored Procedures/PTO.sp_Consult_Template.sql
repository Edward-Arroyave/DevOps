SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/06/2022
-- Description: Procedimiento almacenado para consutar pantillas.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_Template]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTemplate, IdBodyPart, TemplateName, TemplateDescription, Active 
	FROM PTO.TB_Template

END
GO
