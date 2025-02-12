SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 17/06/2022
-- Description: Procedimiento almacenado para consutar partes del cuerpo.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Consult_BodyPart]
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdBodyPart, Description, BlockQuantity, Active 
	FROM PTO.TB_BodyPart
END
GO
