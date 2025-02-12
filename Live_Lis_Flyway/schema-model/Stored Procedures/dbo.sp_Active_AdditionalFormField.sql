SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/10/2022
-- Description: Procedimiento almacenado para crear campos de un formulario extra.
-- =============================================
--EXEC [dbo].[sp_Active_AdditionalFormField] 22
-- =============================================
CREATE PROCEDURE [dbo].[sp_Active_AdditionalFormField]
(
	@IdAdditionalForm_AdditionalFormField int,
	@Active bit,
	@IdAccordionOrganization int
)
AS
BEGIN
    SET NOCOUNT ON
	
	UPDATE TR_AdditionalForm_AdditionalFormField
		SET Active = @Active,
			IdAccordionOrganization = @IdAccordionOrganization
	WHERE IdAdditionalForm_AdditionalFormField = @IdAdditionalForm_AdditionalFormField
END
GO
