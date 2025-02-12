SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/06/2022
-- Description: Procedimiento almacenado para consutar medios de fijación
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_FixingMedium]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdFixingMedium, Description, Active 
	FROM PTO.TB_FixingMedium

END
GO
