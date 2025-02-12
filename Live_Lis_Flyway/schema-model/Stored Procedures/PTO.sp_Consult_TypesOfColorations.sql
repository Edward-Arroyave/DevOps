SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/06/2022
-- Description: Procedimiento almacenado para tipos de coloración.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_TypesOfColorations]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTypesOfColorations, Description, Active 
	FROM PTO.TB_TypesOfColorations

END
GO
