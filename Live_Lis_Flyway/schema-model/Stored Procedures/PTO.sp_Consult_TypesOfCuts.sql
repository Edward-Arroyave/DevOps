SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/06/2022
-- Description: Procedimiento almacenado para tipos de corte.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_TypesOfCuts]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdTypesOfCuts, Description, Active 
	FROM PTO.TB_TypesOfCuts

END
GO
