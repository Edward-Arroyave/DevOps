SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para retornar información de asignación para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_Template]
(
	@IdTemplate int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTemplate, IdPathologyProcess, IdBodyPart, TemplateName, TemplateDescription
	FROM PTO.TB_Template
	WHERE IdTemplate = @IdTemplate
END
GO
