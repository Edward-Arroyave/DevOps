SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/10/2022
-- Description: Procedimiento almacenado para crear campos de un formulario extra.
-- =============================================
--EXEC [dbo].[sp_Detail_AdditionalForm] 154
-- =============================================
CREATE PROCEDURE [dbo].[sp_Detail_AdditionalForm]
(
	@IdAdditionalForm int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT DISTINCT A.IdAdditionalForm, A.AdditionalForm, B.IdAdditionalFormField, C.AdditionalFormField, C.Obligatory, E.IdAdditionalFormDataType, E.AdditionalFormDataType, B.IdAccordionOrganization, F.AccordionOrganization, D.IdAdditionalFormFieldOption, D.AdditionalFormFieldOption, C.IdDefaultList, G.DefaultListName, G.TableName,
		B.IdAdditionalForm_AdditionalFormField, B.Active
	FROM TB_AdditionalForm A
	INNER JOIN TR_AdditionalForm_AdditionalFormField B
		ON B.IdAdditionalForm = A.IdAdditionalForm
	INNER JOIN TB_AdditionalFormField C
		ON C.IdAdditionalFormField = B.IdAdditionalFormField
	INNER JOIN TB_AdditionalFormDataType E
		ON E.IdAdditionalFormDataType = C.IdAdditionalFormDataType
	LEFT JOIN TB_AccordionOrganization F
		ON F.IdAccordionOrganization = B.IdAccordionOrganization
	LEFT JOIN TB_AdditionalFormFieldOption D
		ON D.IdAdditionalFormField= C.IdAdditionalFormField
			AND D.IdAdditionalForm = A.IdAdditionalForm
	LEFT JOIN TB_DefaultList G
		ON G.IdDefaultList = C.IdDefaultList
	WHERE A.IdAdditionalForm = @IdAdditionalForm
END
GO
