SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:      Wendy Paola Tellez Gonzalez
-- Create Date: 20/05/2022
-- Description: Procedimiento almacenado para retornar información parte del cuerpo para editar.
-- =============================================
CREATE PROCEDURE [PTO].[sp_Detail_BodyPart]
(
	@IdBodyPart int
)
AS
BEGIN
    SET NOCOUNT ON

	SELECT IdBodyPart, Description, BlockQuantity
	FROM PTO.TB_BodyPart
	WHERE IdBodyPart = @IdBodyPart
END
GO
