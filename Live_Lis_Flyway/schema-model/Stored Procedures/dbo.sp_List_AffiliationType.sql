SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 12/05/2022
-- Description: Procedimiento almacenado para listar tipos de afiliación.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_AffiliationType]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdAffiliationType, CONCAT(AffiliationTypeCode,': ', AffiliationType) AffiliationType
	FROM TB_AffiliationType
END
GO
