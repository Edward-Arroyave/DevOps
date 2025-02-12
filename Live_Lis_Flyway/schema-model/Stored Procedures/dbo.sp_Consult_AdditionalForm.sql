SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/10/2022
-- Description: Procedimiento almacenado para crear campos de un formulario extra.
-- =============================================
--EXEC [dbo].[sp_Consult_AdditionalForm] 3
-- =============================================
CREATE PROCEDURE [dbo].[sp_Consult_AdditionalForm]
(
	@IdAdditionalFormType int
)
AS
BEGIN
    SET NOCOUNT ON
	
	SELECT A.IdAdditionalForm, A.AdditionalForm, A.IdCompany, B.CompanyName, A.Active
	FROM TB_AdditionalForm A
	LEFT JOIN TB_Company B
		ON B.IdCompany = A.IdCompany
	WHERE A.IdAdditionalFormType = @IdAdditionalFormType
END
GO
