SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 21/04/2021
-- Description: Procedimiento almacenado para listar etnia.
-- =============================================
CREATE PROCEDURE [dbo].[sp_List_Ethnicity]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdEthnicity, CONCAT(EthnicityCode,': ', Ethnicity) Ethnicity
	FROM TB_Ethnicity
	WHERE Active = 'True'

END
GO
