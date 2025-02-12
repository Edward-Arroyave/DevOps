SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2022
-- Description: Procedimiento almacenado para listar categoria de discapacidad.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_DisabilityCategory]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdDisabilityCategory, CONCAT(DisabilityCategoryCode,': ', DisbilityCategory) DisbilityCategory
	FROM TB_DisabilityCategory
	WHERE Active = 'True'

END
GO
